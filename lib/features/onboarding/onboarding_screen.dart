import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_localizations.dart';
import '../../data/models/user_profile.dart';
import '../../navigation/main_navigation.dart';
import '../../providers/user_provider.dart';
import '../../widgets/body_map/body_map_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageCtrl = PageController();
  int _page = 0;

  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  String _gender = 'male';
  String _fitnessLevel = 'beginner';
  final Set<String> _selectedAreas = {};

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < 2) {
      if (_page == 1 && !_validateProfile()) return;
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finish();
    }
  }

  bool _validateProfile() {
    if (_nameCtrl.text.trim().isEmpty) {
      _showSnack('Please enter your name.');
      return false;
    }
    final age = int.tryParse(_ageCtrl.text.trim());
    if (age == null || age < 10 || age > 100) {
      _showSnack('Please enter a valid age (10–100).');
      return false;
    }
    return true;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryTextColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _finish() async {
    if (!_validateProfile()) return;
    final profile = UserProfile(
      name: _nameCtrl.text.trim(),
      age: int.parse(_ageCtrl.text.trim()),
      gender: _gender,
      fitnessLevel: _fitnessLevel,
      primaryPainAreas: _selectedAreas.toList(),
    );
    await context.read<UserProvider>().completeOnboarding(profile);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, a, __) => const MainNavigation(),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.backgroundColor,
            AppColors.backgroundColor2,
            AppColors.backgroundColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _IntroPage(),
                  _ProfilePage(
                    nameCtrl: _nameCtrl,
                    ageCtrl: _ageCtrl,
                    gender: _gender,
                    fitnessLevel: _fitnessLevel,
                    onGenderChanged: (v) => setState(() => _gender = v),
                    onFitnessChanged: (v) => setState(() => _fitnessLevel = v),
                  ),
                  _PainAreaPage(
                    selectedAreas: _selectedAreas,
                    onAreaTapped: (a) => setState(() {
                      if (_selectedAreas.contains(a)) {
                        _selectedAreas.remove(a);
                      } else {
                        _selectedAreas.add(a);
                      }
                    }),
                  ),
                ],
              ),
            ),
            _BottomBar(
              page: _page,
              isLast: _page == 2,
              onNext: _next,
              onBack: _page > 0
                  ? () => _pageCtrl.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                      )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared helpers ─────────────────────────────────────────────

const _kPillShadow = [
  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
];

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: GoogleFonts.dmSans(
          color: AppColors.primaryTextColor.withValues(alpha: 0.45),
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      );
}

// ── Page 1: Intro ──────────────────────────────────────────────

class _IntroPage extends StatefulWidget {
  @override
  State<_IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<_IntroPage> with TickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..forward();

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _enter.dispose();
    _pulse.dispose();
    super.dispose();
  }

  Animation<double> _fade(double from, double to) => CurvedAnimation(
        parent: _enter,
        curve: Interval(from, to, curve: Curves.easeOut),
      );

  Animation<Offset> _slideFrom(double from, double to, Offset begin) =>
      Tween<Offset>(begin: begin, end: Offset.zero).animate(
        CurvedAnimation(
          parent: _enter,
          curve: Interval(from, to, curve: Curves.easeOutCubic),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final iconScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _enter,
        curve: const Interval(0.1, 0.55, curve: Curves.easeOutBack),
      ),
    );
    final pulseScale = Tween<double>(begin: 1.0, end: 1.055).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App badge ──
            FadeTransition(
              opacity: _fade(0.0, 0.35),
              child: SlideTransition(
                position: _slideFrom(0.0, 0.4, const Offset(0, -0.6)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: _kPillShadow,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryTextColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.self_improvement_rounded,
                            color: Colors.white, size: 14.sp),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        S.appName,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.primaryTextColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 36.h),
            // ── Hero icon with entrance scale + breathing pulse ──
            FadeTransition(
              opacity: _fade(0.1, 0.5),
              child: ScaleTransition(
                scale: iconScale,
                child: ScaleTransition(
                  scale: pulseScale,
                  child: Container(
                    width: 72.w,
                    height: 72.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTextColor,
                      borderRadius: BorderRadius.circular(22.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryTextColor.withValues(alpha: 0.22),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(Icons.self_improvement_rounded,
                        color: Colors.white, size: 36.sp),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            // ── Title ──
            FadeTransition(
              opacity: _fade(0.25, 0.62),
              child: SlideTransition(
                position: _slideFrom(0.25, 0.65, const Offset(-0.08, 0)),
                child: Text(
                  S.onboarding1Title,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            // ── Tagline ──
            FadeTransition(
              opacity: _fade(0.35, 0.68),
              child: Text(
                S.tagline,
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.55),
                  fontSize: 15.sp,
                  height: 1.55,
                ),
              ),
            ),
            const Spacer(),
            // ── Feature cards (staggered) ──
            FadeTransition(
              opacity: _fade(0.5, 0.75),
              child: SlideTransition(
                position: _slideFrom(0.5, 0.78, const Offset(0, 0.5)),
                child: const _FeatureCard(
                  icon: Icons.offline_bolt_outlined,
                  color: AppColors.recentSessionCard,
                  label: '100% Offline — works without internet',
                ),
              ),
            ),
            SizedBox(height: 10.h),
            FadeTransition(
              opacity: _fade(0.62, 0.84),
              child: SlideTransition(
                position: _slideFrom(0.62, 0.86, const Offset(0, 0.5)),
                child: const _FeatureCard(
                  icon: Icons.psychology_outlined,
                  color: AppColors.aiSugesstionCard,
                  label: 'AI-powered pain pattern analysis',
                ),
              ),
            ),
            SizedBox(height: 10.h),
            FadeTransition(
              opacity: _fade(0.74, 0.95),
              child: SlideTransition(
                position: _slideFrom(0.74, 0.97, const Offset(0, 0.5)),
                child: const _FeatureCard(
                  icon: Icons.fitness_center_rounded,
                  color: AppColors.inProgressCard,
                  label: '30+ guided physiotherapy exercises',
                ),
              ),
            ),
            SizedBox(height: 28.h),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _FeatureCard({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: _kPillShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: AppColors.primaryTextColor, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                color: AppColors.primaryTextColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Page 2: Profile form ───────────────────────────────────────

class _ProfilePage extends StatefulWidget {
  final TextEditingController nameCtrl;
  final TextEditingController ageCtrl;
  final String gender;
  final String fitnessLevel;
  final void Function(String) onGenderChanged;
  final void Function(String) onFitnessChanged;

  const _ProfilePage({
    required this.nameCtrl,
    required this.ageCtrl,
    required this.gender,
    required this.fitnessLevel,
    required this.onGenderChanged,
    required this.onFitnessChanged,
  });

  @override
  State<_ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<_ProfilePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
  )..forward();

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  Animation<double> _fade(double from, double to) => CurvedAnimation(
        parent: _enter,
        curve: Interval(from, to, curve: Curves.easeOut),
      );

  Animation<Offset> _up(double from, double to) =>
      Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _enter,
          curve: Interval(from, to, curve: Curves.easeOutCubic),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Heading ──
            FadeTransition(
              opacity: _fade(0.0, 0.38),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-0.06, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _enter,
                  curve: const Interval(0.0, 0.42, curve: Curves.easeOutCubic),
                )),
                child: Text(
                  S.onboarding2Title,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            FadeTransition(
              opacity: _fade(0.08, 0.44),
              child: Text(
                S.onboarding2Subtitle,
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.55),
                  fontSize: 14.sp,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 28.h),
            // ── Name ──
            FadeTransition(
              opacity: _fade(0.18, 0.5),
              child: _SectionLabel(S.fullName),
            ),
            SizedBox(height: 8.h),
            FadeTransition(
              opacity: _fade(0.22, 0.55),
              child: SlideTransition(
                position: _up(0.22, 0.56),
                child: _InputPill(
                  controller: widget.nameCtrl,
                  hint: 'e.g. John Smith',
                  icon: Icons.person_outline_rounded,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // ── Age ──
            FadeTransition(
              opacity: _fade(0.32, 0.62),
              child: _SectionLabel(S.age),
            ),
            SizedBox(height: 8.h),
            FadeTransition(
              opacity: _fade(0.36, 0.66),
              child: SlideTransition(
                position: _up(0.36, 0.67),
                child: _InputPill(
                  controller: widget.ageCtrl,
                  hint: 'e.g. 35',
                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            // ── Gender ──
            FadeTransition(
              opacity: _fade(0.46, 0.74),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(S.gender),
                  SizedBox(height: 10.h),
                  _PillChipGroup(
                    options: const ['male', 'female', 'other'],
                    labels: const [S.male, S.female, S.other],
                    selected: widget.gender,
                    onSelected: widget.onGenderChanged,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // ── Fitness level ──
            FadeTransition(
              opacity: _fade(0.58, 0.86),
              child: SlideTransition(
                position: _up(0.58, 0.87),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(S.fitnessLevel),
                    SizedBox(height: 10.h),
                    _PillChipGroup(
                      options: const ['beginner', 'intermediate', 'active'],
                      labels: const [
                        S.beginnerLevel,
                        S.intermediateLevel,
                        S.activeLevel,
                      ],
                      selected: widget.fitnessLevel,
                      onSelected: widget.onFitnessChanged,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// ── Input pill with focus state ────────────────────────────────

class _InputPill extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  const _InputPill({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  });

  @override
  State<_InputPill> createState() => _InputPillState();
}

class _InputPillState extends State<_InputPill> {
  late final FocusNode _focus = FocusNode()..addListener(_onFocus);
  bool _focused = false;

  void _onFocus() => setState(() => _focused = _focus.hasFocus);

  @override
  void dispose() {
    _focus.removeListener(_onFocus);
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: _focused
            ? Border.all(color: AppColors.dailyAssessment, width: 1.8)
            : Border.all(color: Colors.transparent, width: 1.8),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: AppColors.dailyAssessment.withValues(alpha: 0.28),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : _kPillShadow,
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              widget.icon,
              key: ValueKey(_focused),
              color: _focused
                  ? AppColors.dailyAssessment
                  : AppColors.primaryTextColor.withValues(alpha: 0.4),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              focusNode: _focus,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              textCapitalization: widget.textCapitalization,
              inputFormatters: widget.inputFormatters,
              style: GoogleFonts.dmSans(
                color: AppColors.primaryTextColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: AppColors.dailyAssessment,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.32),
                  fontSize: 15.sp,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillChipGroup extends StatelessWidget {
  final List<String> options;
  final List<String> labels;
  final String selected;
  final void Function(String) onSelected;

  const _PillChipGroup({
    required this.options,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: List.generate(options.length, (i) {
        final isSel = selected == options[i];
        return GestureDetector(
          onTap: () => onSelected(options[i]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: isSel ? AppColors.primaryTextColor : Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: _kPillShadow,
              border: isSel
                  ? null
                  : Border.all(
                      color: Colors.black.withValues(alpha: 0.08), width: 1),
            ),
            child: Text(
              labels[i],
              style: GoogleFonts.dmSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isSel
                    ? Colors.white
                    : AppColors.primaryTextColor.withValues(alpha: 0.6),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Page 3: Pain area body map ─────────────────────────────────

class _PainAreaPage extends StatefulWidget {
  final Set<String> selectedAreas;
  final void Function(String) onAreaTapped;

  const _PainAreaPage({
    required this.selectedAreas,
    required this.onAreaTapped,
  });

  @override
  State<_PainAreaPage> createState() => _PainAreaPageState();
}

class _PainAreaPageState extends State<_PainAreaPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  Animation<double> _fade(double from, double to) => CurvedAnimation(
        parent: _enter,
        curve: Interval(from, to, curve: Curves.easeOut),
      );

  @override
  Widget build(BuildContext context) {
    final mapScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _enter,
        curve: const Interval(0.2, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeTransition(
              opacity: _fade(0.0, 0.38),
              child: Text(
                S.onboarding3Title,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.primaryTextColor,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            FadeTransition(
              opacity: _fade(0.08, 0.45),
              child: Text(
                S.onboarding3Subtitle,
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.55),
                  fontSize: 14.sp,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 14.h),
            // Selected area tags
            if (widget.selectedAreas.isNotEmpty) ...[
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                child: Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: widget.selectedAreas
                      .map(
                        (area) => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color:
                                AppColors.dailyAssessment.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.dailyAssessment
                                  .withValues(alpha: 0.45),
                            ),
                          ),
                          child: Text(
                            area.replaceAll('_', ' '),
                            style: GoogleFonts.dmSans(
                              color: AppColors.primaryTextColor
                                  .withValues(alpha: 0.75),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 12.h),
            ],
            // Body map
            Expanded(
              child: FadeTransition(
                opacity: _fade(0.2, 0.72),
                child: ScaleTransition(
                  scale: mapScale,
                  child: BodyMapWidget(
                    selectedAreas: widget.selectedAreas,
                    onAreaTapped: widget.onAreaTapped,
                    multiSelect: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Bar ─────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final int page;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback? onBack;

  const _BottomBar({
    required this.page,
    required this.isLast,
    required this.onNext,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, bottom + 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) => _Dot(active: i == page)),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              if (onBack != null) ...[
                Expanded(child: _BackBtn(onBack!)),
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: _NextBtn(
                  label: isLast ? S.getStarted : S.next,
                  onTap: onNext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: active ? 26.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: active
            ? AppColors.primaryTextColor
            : AppColors.primaryTextColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ── Pressable buttons with scale feedback ──────────────────────

class _NextBtn extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NextBtn({required this.label, required this.onTap});

  @override
  State<_NextBtn> createState() => _NextBtnState();
}

class _NextBtnState extends State<_NextBtn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 90),
  );
  late final Animation<double> _scale = Tween<double>(begin: 1.0, end: 0.94)
      .animate(CurvedAnimation(parent: _press, curve: Curves.easeOut));

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _press.forward(),
      onTapUp: (_) {
        _press.reverse();
        widget.onTap();
      },
      onTapCancel: () => _press.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 52.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryTextColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _BackBtn extends StatefulWidget {
  final VoidCallback onTap;
  const _BackBtn(this.onTap);

  @override
  State<_BackBtn> createState() => _BackBtnState();
}

class _BackBtnState extends State<_BackBtn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 90),
  );
  late final Animation<double> _scale = Tween<double>(begin: 1.0, end: 0.94)
      .animate(CurvedAnimation(parent: _press, curve: Curves.easeOut));

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _press.forward(),
      onTapUp: (_) {
        _press.reverse();
        widget.onTap();
      },
      onTapCancel: () => _press.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 52.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: AppColors.primaryTextColor.withValues(alpha: 0.14),
              width: 1.5,
            ),
            boxShadow: _kPillShadow,
          ),
          child: Text(
            S.back,
            style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
