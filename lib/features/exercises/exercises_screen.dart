import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:physioai/core/theme/app_colors.dart';
import 'package:physioai/features/exercises/library_category_screen.dart';
import 'package:physioai/features/exercises/plans_browse_view.dart';
import 'package:physioai/providers/library_provider.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  int _tab = 0;

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
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _TopBar(
                selectedTab: _tab,
                onTabChanged: (t) => setState(() => _tab = t),
              ),
              const Divider(color: AppColors.divider, height: 1, thickness: 1),
              Expanded(
                child: _tab == 0
                    ? const _ExercisesGrid()
                    : const PlansBrowseView(),
              ),
              SizedBox(height: 100.w),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Top Bar ─────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int selectedTab;
  final void Function(int) onTabChanged;

  const _TopBar({required this.selectedTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      child: Container(
        height: 52.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            _TabPill(
              label: 'Exercises',
              selected: selectedTab == 0,
              onTap: () => onTabChanged(0),
            ),
            _TabPill(
              label: 'Plans',
              selected: selectedTab == 1,
              onTap: () => onTabChanged(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryTextColor : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              color: selected
                  ? Colors.white
                  : AppColors.primaryTextColor.withValues(alpha: 0.5),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Exercises Grid ───────────────────────────────────────────────

class _ExercisesGrid extends StatelessWidget {
  const _ExercisesGrid();

  static const _colors = [
    AppColors.recentSessionCard,
    AppColors.aiSugesstionCard,
    AppColors.dailyAssessment,
    AppColors.socialCard,
  ];

  static const _icons = <String, IconData>{
    'neck': Icons.accessibility_new_rounded,
    'shoulders': Icons.accessibility_rounded,
    'chest': Icons.sports_gymnastics_rounded,
    'abdominals': Icons.self_improvement_rounded,
    'lower back': Icons.airline_seat_recline_extra_rounded,
    'middle back': Icons.airline_seat_recline_extra_rounded,
    'lats': Icons.accessibility_rounded,
    'traps': Icons.accessibility_new_rounded,
    'quadriceps': Icons.directions_run_rounded,
    'hamstrings': Icons.directions_run_rounded,
    'calves': Icons.directions_walk_rounded,
    'glutes': Icons.self_improvement_rounded,
    'biceps': Icons.fitness_center_rounded,
    'triceps': Icons.fitness_center_rounded,
    'forearms': Icons.fitness_center_rounded,
    'abductors': Icons.directions_walk_rounded,
    'adductors': Icons.directions_walk_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LibraryProvider>();

    if (provider.isLoading) return _buildShimmer();

    if (provider.error != null) {
      return Center(
        child: Text(
          'Failed to load exercises',
          style: GoogleFonts.dmSans(
              color: AppColors.primaryTextColor.withValues(alpha: 0.5)),
        ),
      );
    }

    final bodyParts = provider.bodyParts;

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 120.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.99,
      ),
      itemCount: bodyParts.length,
      itemBuilder: (context, i) {
        final part = bodyParts[i];
        final exercises = provider.byBodyPart(part);
        return _CategoryCard(
          label: part,
          icon: _icons[part.toLowerCase()] ?? Icons.fitness_center_rounded,
          color: _colors[i % _colors.length],
          count: exercises.length,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LibraryCategoryScreen(
                bodyPart: part,
                exercises: exercises,
                color: _colors[i % _colors.length],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmer() {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.99,
      ),
      itemCount: 8,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.white.withValues(alpha: 0.15),
        highlightColor: Colors.white.withValues(alpha: 0.35),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}

// ── Category Card ────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final int count;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayLabel =
        label.isEmpty ? label : label[0].toUpperCase() + label.substring(1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              right: -10,
              child: Icon(
                icon,
                size: 100.sp,
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0.h, 12.w, 26.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon,
                        size: 22.sp, color: AppColors.primaryTextColor),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    displayLabel,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryTextColor,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$count exercise${count == 1 ? '' : 's'}',
                      style: GoogleFonts.dmSans(
                        color: AppColors.primaryTextColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
