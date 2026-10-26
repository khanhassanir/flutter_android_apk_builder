import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/data/exercise_data.dart';
import 'package:physioai/data/models/exercise_plan.dart';
import 'package:physioai/data/plan_data.dart';
import 'package:physioai/engine/chat_context.dart';
import 'package:physioai/engine/chat_engine.dart';
import 'package:physioai/features/chat/chat_message.dart';
import 'package:physioai/features/exercises/exercise_detail_screen.dart';
import 'package:physioai/features/exercises/exercises_screen.dart';
import 'package:physioai/features/exercises/plan_detail_screen.dart';
import 'package:physioai/features/exercises/plans_browse_view.dart';
import 'package:physioai/providers/plan_provider.dart';
import 'package:physioai/data/hive_boxes/hive_service.dart';
import 'package:physioai/data/models/assessment_result.dart';
import 'package:physioai/providers/assessment_provider.dart';
import 'package:physioai/service/groq_service.dart';
import 'package:provider/provider.dart';

import 'chat_knowledge_base.dart';
import 'widgets/chat_top_bar.dart';
import 'widgets/input_bar.dart';
import 'widgets/message_bubble.dart';
import 'widgets/new_chat_bar.dart';
import 'widgets/quick_replies_bar.dart';
import 'widgets/terminal_replies_bar.dart';
import 'widgets/typing_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messages = <ChatMessage>[];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;
  ChatContext _context = ChatContext.empty;
  List<String> _currentQuickReplies = [
    'I have back pain',
    'Show me recovery plans',
    'Knee pain',
    'What can you do?',
  ];

  ChatPhase _phase = ChatPhase.active;
  String? _postFlowTopic;
  Set<String> _usedTerminalKeys = {};

  final GroqService _groqService = GroqService();
  bool _useAIAPI = true;
  List<Map<String, String>> _conversationHistory = [];

  @override
  void initState() {
    super.initState();
    _addBot(
      "Hello — I'm your Physio Assistant. I can identify exercises for your pain area, recommend a structured recovery plan, and answer questions about technique, timelines, and when to see a professional.\n\nWhat's bothering you today?",
      quickReplies: [
        'I have back pain',
        'Show me recovery plans',
        'Knee pain',
        'What can you do?'
      ],
    );
  }

  void _addBot(
    String text, {
    List<String> quickReplies = const [],
    List<String> exerciseIds = const [],
    String? planId,
    String? browseTarget,
  }) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: false,
        quickReplies: quickReplies,
        exerciseIds: exerciseIds,
        planId: planId,
        browseTarget: browseTarget,
      ));
      _currentQuickReplies = quickReplies;
    });
    _scrollToBottom();
  }

  Future<void> _send(String text) async {
    if (_phase != ChatPhase.active) return;
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _controller.clear();

    final wasInFlow = _context.inFlow;

    setState(() {
      _messages.add(ChatMessage(text: trimmed, isUser: true));
      _currentQuickReplies = [];
      _isTyping = true;
    });
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;

    // Knowledge base check — always runs first, no network needed
    final kb = ChatKnowledgeBase.match(trimmed);
    if (kb != null) {
      setState(() => _isTyping = false);
      _addBot(
        kb.message,
        exerciseIds: kb.exerciseIds,
        planId: kb.planId,
        browseTarget: kb.browseTarget,
        quickReplies: kb.quickReplies,
      );
      return;
    }

    try {
      _conversationHistory.add({'role': 'user', 'content': trimmed});

      if (_useAIAPI) {
        final aiResponse = await _groqService.sendMessage(
          trimmed,
          conversationHistory: _conversationHistory,
        );

        _conversationHistory.add({'role': 'assistant', 'content': aiResponse});

        if (_conversationHistory.length > 20) {
          _conversationHistory =
              _conversationHistory.sublist(_conversationHistory.length - 20);
        }

        setState(() => _isTyping = false);

        _addBot(
          aiResponse,
          quickReplies: _getContextualQuickReplies(trimmed, aiResponse),
        );
      } else {
        final (response, newContext) = ChatEngine.respond(trimmed, _context);
        final flowJustEnded = wasInFlow && !newContext.inFlow;

        setState(() {
          _isTyping = false;
          _context = newContext;
          if (flowJustEnded) {
            _phase = ChatPhase.postFlow;
            _postFlowTopic = newContext.topic;
          }
        });

        _addBot(
          response.message,
          quickReplies: response.quickReplies,
          exerciseIds: response.exerciseIds,
          planId: response.planId,
          browseTarget: response.browseTarget,
        );

        if (flowJustEnded) {
          await _persistChatSession(newContext.topic);
        }
      }
    } catch (e) {
      setState(() => _isTyping = false);
      _addBot(
        'I apologize, but I\'m having trouble connecting to my knowledge base. '
        'Please check your internet connection and try again. '
        'You can also use the quick replies below for common questions.',
        quickReplies: [
          'I have back pain',
          'Show me exercises',
          'Show me recovery plans',
          'What can you do?'
        ],
      );
    }
  }

  List<String> _getContextualQuickReplies(
      String userInput, String aiResponse) {
    final input = userInput.toLowerCase();

    if (input.contains('back pain') || input.contains('lower back')) {
      return [
        'Show me exercises for lower back',
        'How long until I see improvement?',
        'Can I use heat or ice?',
        'When to see a doctor?'
      ];
    } else if (input.contains('neck') || input.contains('shoulder')) {
      return [
        'Neck stretches',
        'Shoulder mobility exercises',
        'Posture tips',
        'When to see a doctor?'
      ];
    } else if (input.contains('knee')) {
      return [
        'Knee strengthening exercises',
        'Is walking safe?',
        'How to reduce swelling?',
        'Return to sport timeline'
      ];
    } else if (input.contains('exercise') || input.contains('workout')) {
      return [
        'Show me beginner exercises',
        'Proper form tips',
        'How often to exercise?',
        'Pain vs discomfort'
      ];
    } else if (input.contains('recovery') || input.contains('heal')) {
      return [
        'Recovery timeline',
        'Best practices for healing',
        'Activities to avoid',
        'When to progress'
      ];
    } else {
      return [
        'I have back pain',
        'Neck and shoulder pain',
        'Knee pain',
        'What exercises should I do?'
      ];
    }
  }

  Future<void> _sendWithStreaming(String text) async {
    if (_phase != ChatPhase.active) return;
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _controller.clear();

    setState(() {
      _messages.add(ChatMessage(text: trimmed, isUser: true));
      _currentQuickReplies = [];
      _isTyping = true;
    });
    _scrollToBottom();

    // Knowledge base check — instant, no streaming needed
    await Future.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    final kb = ChatKnowledgeBase.match(trimmed);
    if (kb != null) {
      setState(() => _isTyping = false);
      _addBot(
        kb.message,
        exerciseIds: kb.exerciseIds,
        planId: kb.planId,
        browseTarget: kb.browseTarget,
        quickReplies: kb.quickReplies,
      );
      return;
    }

    final placeholderIndex = _messages.length;
    setState(() {
      _messages.add(const ChatMessage(text: '', isUser: false));
    });

    _conversationHistory.add({'role': 'user', 'content': trimmed});

    String fullResponse = '';

    try {
      await for (final chunk in _groqService.sendMessageStream(
        trimmed,
        conversationHistory: _conversationHistory,
      )) {
        fullResponse += chunk;
        setState(() {
          _messages[placeholderIndex] = ChatMessage(
            text: fullResponse,
            isUser: false,
            quickReplies: fullResponse.contains('exercise')
                ? ['Show me exercises', 'More details']
                : _getContextualQuickReplies(trimmed, fullResponse),
          );
        });
        _scrollToBottom();
      }

      _conversationHistory
          .add({'role': 'assistant', 'content': fullResponse});

      setState(() => _isTyping = false);
    } catch (e) {
      setState(() {
        _isTyping = false;
        _messages[placeholderIndex] = const ChatMessage(
          text: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
        );
      });
    }
  }

  void _toggleAIMode() {
    setState(() => _useAIAPI = !_useAIAPI);
    _addBot(
      _useAIAPI
          ? 'Switched to AI mode. I can now give detailed, conversational responses for any physiotherapy question. App-specific queries (exercises, plans) are always answered instantly.'
          : 'Switched to offline mode. I\'ll use guided protocols for pain-specific consultations. App queries are always available.',
      quickReplies: [
        'I have back pain',
        'Show me recovery plans',
        'Knee pain',
        'What can you do?'
      ],
    );
  }

  Future<void> _persistChatSession(String? topic) async {
    HiveService.chatCount = HiveService.chatCount + 1;
    final now = DateTime.now();
    final firstUser = _messages.firstWhere(
      (m) => m.isUser,
      orElse: () => const ChatMessage(text: 'Chat session', isUser: true),
    );
    final chatName = firstUser.text.length > 80
        ? '${firstUser.text.substring(0, 80)}…'
        : firstUser.text;
    await HiveService.assessmentsBox.add(AssessmentResult(
      id: '${now.millisecondsSinceEpoch}',
      date: now,
      area: topic ?? 'general',
      painType: 'general',
      intensity: 0,
      duration: 'ongoing',
      diagnosis: chatName,
      confidence: 0,
      exerciseIds: const [],
      source: 'chat',
    ));
    if (mounted) context.read<AssessmentProvider>().refresh();
  }

  Future<void> _sendTerminal(String key) async {
    final entry = terminalFollowup[_postFlowTopic];
    final String displayLabel;
    final String responseText;

    if (key == 'doctor') {
      displayLabel = 'When to see a doctor?';
      responseText = doctorResponse;
    } else {
      displayLabel = entry?.$1 ?? 'Tell me more';
      responseText = entry?.$2 ??
          'Please consult a physiotherapist for personalised advice.';
    }

    final newUsed = {..._usedTerminalKeys, key};
    final hasFollowup = terminalFollowup.containsKey(_postFlowTopic);
    final totalBubbles = hasFollowup ? 2 : 1;
    final willEnd = newUsed.length >= totalBubbles;

    setState(() {
      _messages.add(ChatMessage(text: displayLabel, isUser: true));
      _usedTerminalKeys = newUsed;
      _isTyping = true;
    });
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    setState(() {
      _isTyping = false;
      if (willEnd) _phase = ChatPhase.ended;
    });

    _addBot(responseText);

    if (willEnd) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      _addBot('For a new pain area or concern, start a fresh consultation below.');
    }
  }

  void _startNewConsultation() {
    setState(() {
      _messages.clear();
      _messages.add(const ChatMessage(
        text:
            "Hello — I'm your Physio Assistant. I can identify exercises for your pain area, recommend a structured recovery plan, and answer questions about technique, timelines, and when to see a professional.\n\nWhat's bothering you today?",
        isUser: false,
        quickReplies: [
          'I have back pain',
          'Show me recovery plans',
          'Knee pain',
          'What can you do?'
        ],
      ));
      _context = ChatContext.empty;
      _phase = ChatPhase.active;
      _postFlowTopic = null;
      _usedTerminalKeys = {};
      _isTyping = false;
      _currentQuickReplies = [
        'I have back pain',
        'Show me recovery plans',
        'Knee pain',
        'What can you do?'
      ];
    });
    _scrollToBottom();
  }

  void _handlePlanTap(String planId) {
    final plan = findPlanById(planId);
    if (plan == null || !context.mounted) return;

    final planProvider = context.read<PlanProvider>();

    if (planProvider.isEnrolledIn(planId)) {
      _showSamePlanSheet(planProvider, plan, planId);
    } else if (planProvider.hasActivePlan) {
      _showPlanConflictSheet(planProvider, plan, planId);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                PlanDetailScreen(plan: plan, color: planCardColor(planId)),
          ));
    }
  }

  void _showSamePlanSheet(
      PlanProvider planProvider, ExercisePlan plan, String planId) {
    final completedDays =
        planProvider.activeEnrollment?.completedDays.length ?? 0;
    final remaining = plan.durationDays - completedDays;
    final progress = planProvider.progressPercent;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetCtx) {
        return Container(
          margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 24.h),
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: planCardColor(planId).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.verified_rounded,
                        color: planCardColor(planId), size: 20.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "You're already on this plan!",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.primaryTextColor,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Great choice — keep going.',
                          style: GoogleFonts.dmSans(
                            color: AppColors.primaryTextColor
                                .withValues(alpha: 0.5),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: planCardColor(planId).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                      color: planCardColor(planId).withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.primaryTextColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '$completedDays of ${plan.durationDays} days complete · $remaining day${remaining == 1 ? '' : 's'} to go',
                      style: GoogleFonts.dmSans(
                        color: AppColors.primaryTextColor
                            .withValues(alpha: 0.55),
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor:
                            AppColors.primaryTextColor.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            planCardColor(planId)),
                        minHeight: 6.h,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  remaining > 0
                      ? 'Stick with it — $remaining more day${remaining == 1 ? '' : 's'} and you\'ll complete this plan. Consistency is everything in physiotherapy. Your pain should improve significantly by the end.'
                      : "You've completed this plan — that's a real achievement. If pain persists, consider starting a longer plan or speaking with a physiotherapist.",
                  style: GoogleFonts.dmSans(
                    color: AppColors.primaryTextColor.withValues(alpha: 0.7),
                    fontSize: 12.sp,
                    height: 1.55,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Navigator.pop(sheetCtx);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlanDetailScreen(
                            plan: plan, color: planCardColor(planId)),
                      ));
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTextColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'View my plan',
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPlanConflictSheet(
      PlanProvider planProvider, ExercisePlan newPlan, String newPlanId) {
    final currentPlan = planProvider.activePlan;
    if (currentPlan == null) return;

    final progress = (planProvider.progressPercent * 100).round();
    final completedDays =
        planProvider.activeEnrollment?.completedDays.length ?? 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetCtx) {
        return Container(
          margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 24.h),
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: AppColors.aiSugesstionCard,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.swap_horiz_rounded,
                        color: AppColors.primaryTextColor, size: 18.sp),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'You already have an active plan',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.primaryTextColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                'Current plan',
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.45),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color:
                      planCardColor(currentPlan.id).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: planCardColor(currentPlan.id)
                        .withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentPlan.name,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.primaryTextColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '$completedDays / ${currentPlan.durationDays} days complete · $progress% done',
                      style: GoogleFonts.dmSans(
                        color: AppColors.primaryTextColor
                            .withValues(alpha: 0.55),
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: planProvider.progressPercent,
                        backgroundColor: AppColors.primaryTextColor
                            .withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          planCardColor(currentPlan.id),
                        ),
                        minHeight: 5.h,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'AI recommended',
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.45),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color:
                        AppColors.primaryTextColor.withValues(alpha: 0.12),
                  ),
                ),
                child: Text(
                  newPlan.name,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(sheetCtx),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTextColor
                              .withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Keep current',
                          style: GoogleFonts.dmSans(
                            color: AppColors.primaryTextColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(sheetCtx);
                        final nav = Navigator.of(context);
                        await planProvider.startPlan(newPlanId);
                        nav.push(MaterialPageRoute(
                          builder: (_) => PlanDetailScreen(
                            plan: newPlan,
                            color: planCardColor(newPlanId),
                          ),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTextColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Switch plan',
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasFollowup = terminalFollowup.containsKey(_postFlowTopic);
    final totalBubbles = hasFollowup ? 2 : 1;
    final showTerminalReplies =
        _phase == ChatPhase.postFlow && _usedTerminalKeys.length < totalBubbles;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            ChatTopBar(
              onToggleAIMode: _toggleAIMode,
              useAIAPI: _useAIAPI,
            ),
            Expanded(child: _buildMessageList()),
            if (_phase == ChatPhase.active && _currentQuickReplies.isNotEmpty)
              QuickRepliesBar(
                replies: _currentQuickReplies,
                onTap: _send,
              ),
            if (showTerminalReplies)
              TerminalRepliesBar(
                topic: _postFlowTopic,
                usedKeys: _usedTerminalKeys,
                onTap: _sendTerminal,
              ),
            if (_phase == ChatPhase.ended)
              NewChatBar(onTap: _startNewConsultation)
            else
              InputBar(
                controller: _controller,
                onSend: _useAIAPI ? _sendWithStreaming : _send,
                enabled: _phase == ChatPhase.active,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isTyping && index == _messages.length) {
          return const TypingBubble();
        }
        final msg = _messages[index];
        return MessageBubble(
          message: msg,
          onExerciseTap: (id) {
            final ex = findExerciseById(id);
            if (ex != null && context.mounted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ExerciseDetailScreen(exercise: ex, fromChat: true),
                  ));
            }
          },
          onPlanTap: _handlePlanTap,
          onBrowseExercises: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ExercisesScreen()),
          ),
          onBrowsePlans: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const PlansBrowseView(standalone: true)),
          ),
        );
      },
    );
  }
}