import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_localizations.dart';
import '../../data/hive_boxes/hive_service.dart';
import '../../features/posture/posture_screen.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/exercise_provider.dart';
import '../../providers/plan_provider.dart';
import '../../providers/progress_provider.dart';
import '../../providers/user_provider.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(int)? onNavigate;

  const SettingsScreen({super.key, this.onNavigate});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
/*
  bool _notifications = true;
*/

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.backgroundColor, AppColors.backgroundColor2, AppColors.backgroundColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _TopBar(onBackTap: () => widget.onNavigate?.call(0)),
              const Divider(color: AppColors.divider, height: 1, thickness: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  children: [
                  if (user.profile != null) ...[
                    _ProfileCard(profile: user.profile!),
                    //const SizedBox(height: 28),
                  ],
                  /*_SectionLabel('Preferences'),*/
                  /*const SizedBox(height: 12),
                  _TogglePill(
                    label: 'Dark Mode',
                    icon: Icons.dark_mode_outlined,
                    value: user.isDarkMode,
                    onChanged: (_) => user.toggleDarkMode(),
                  ),*/
                  /*const SizedBox(height: 12),
                  _TogglePill(
                    label: 'Notifications',
                    icon: Icons.notifications_outlined,
                    value: _notifications,
                    onChanged: (v) => setState(() => _notifications = v),
                  ),*/
                  const SizedBox(height: 28),
                  _SectionLabel('Features'),
                  const SizedBox(height: 12),
                  _SettingsPill(
                    label: 'Posture Check',
                    icon: Icons.camera_alt_outlined,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const PostureScreen()),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _SectionLabel('Legal & Support'),
                  const SizedBox(height: 12),
                  _SettingsPill(
                    label: 'Privacy Policy',
                    icon: Icons.privacy_tip_outlined,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _SettingsPill(
                    label: 'Terms and Conditions',
                    icon: Icons.description_outlined,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _SettingsPill(
                    label: 'Support',
                    icon: Icons.support_agent_outlined,
                    onTap: () {},
                  ),
                  const SizedBox(height: 28),
                  _SectionLabel('Debug'),
                  const SizedBox(height: 12),
                  _DebugClearButton(onNavigate: widget.onNavigate),
                  const SizedBox(height: 28),
                  _DisclaimerCard(),
                ],
              ),
            ),
              const SizedBox(height: 108),
          ],
        ),
      ),
    ),
  );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onBackTap;

  const _TopBar({required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Text(
              'Settings',
              style: GoogleFonts.dmSans(
                color: AppColors.primaryTextColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onBackTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.primaryTextColor,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Card ───────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final dynamic profile;
  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.recentSessionCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white, width: 1.5),
            ),
            child: Icon(Icons.person_rounded,
                color: AppColors.primaryTextColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: GoogleFonts.dmSans(
                    color: AppColors.primaryTextColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${profile.age} yrs · ${profile.fitnessLevel}',
                  style: GoogleFonts.dmSans(
                    color: AppColors.primaryTextColor.withValues(alpha: 0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        color: AppColors.primaryTextColor.withValues(alpha: 0.45),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
}


class _TogglePill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool value;
  final void Function(bool) onChanged;

  const _TogglePill({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryTextColor.withValues(alpha: 0.6), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                color: AppColors.primaryTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.accent,
            activeTrackColor: AppColors.accent.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.grey.withValues(alpha: 0.6),
            inactiveTrackColor: Colors.grey.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}


class _SettingsPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingsPill({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryTextColor.withValues(alpha: 0.6), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.dmSans(
                  color: AppColors.primaryTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.primaryTextColor.withValues(alpha: 0.35), size: 15),
          ],
        ),
      ),
    );
  }
}

class _DebugClearButton extends StatelessWidget {
  final void Function(int)? onNavigate;
  const _DebugClearButton({this.onNavigate});

  Future<void> _clearAll(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear all records?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'This deletes all check-ins, exercises, assessments, plan history, and AI chat count.\n\nYour profile and preferences are kept. This cannot be undone.',
          style: GoogleFonts.dmSans(fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: GoogleFonts.dmSans(
                    color: AppColors.primaryTextColor,
                    fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Clear all',
                style: GoogleFonts.dmSans(
                    color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await HiveService.checkInsBox.clear();
    await HiveService.exerciseLogsBox.clear();
    await HiveService.assessmentsBox.clear();
    await HiveService.planEnrollmentsBox.clear();
    HiveService.chatCount = 0;
    HiveService.assessmentCount = 0;

    if (!context.mounted) return;

    context.read<ExerciseProvider>().setInProgress(null);
    context.read<ProgressProvider>().refresh();
    context.read<AssessmentProvider>().refresh();
    context.read<PlanProvider>().refresh();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All records cleared.',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.primaryTextColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    onNavigate?.call(0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _clearAll(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.error.withValues(alpha: 0.07),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(Icons.delete_sweep_rounded,
                color: AppColors.error.withValues(alpha: 0.8), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Clear all records',
                style: GoogleFonts.dmSans(
                  color: AppColors.error,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              'DEBUG',
              style: GoogleFonts.dmSans(
                color: AppColors.error.withValues(alpha: 0.55),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _DisclaimerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.aiSugesstionCard.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.aiSugesstionCard.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              color: AppColors.primaryTextColor.withValues(alpha: 0.5), size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              S.disclaimer,
              style: GoogleFonts.dmSans(
                color: AppColors.primaryTextColor.withValues(alpha: 0.55),
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}