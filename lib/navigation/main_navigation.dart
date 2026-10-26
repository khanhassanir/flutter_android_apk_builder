import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../features/exercises/exercises_screen.dart';
import '../features/home/home_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/settings/settings_screen.dart';
import '../providers/progress_provider.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _navigate(int index) {
    if (index == 2) context.read<ProgressProvider>().refresh();
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBgEdge,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.2),
            radius: 1.2,
            colors: [AppColors.darkBgCenter, AppColors.darkBgEdge],
          ),
        ),
        child: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: [
                HomeScreen(onNavigate: _navigate),
                const ExercisesScreen(),
                const ProgressScreen(),
                SettingsScreen(onNavigate: _navigate),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomNavBar(
                selectedIndex: _selectedIndex,
                onTap: _navigate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Nav Bar ─────────────────────────────────────────────

class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  static const _icons = [
    Icons.home_outlined,
    Icons.fitness_center_rounded,
    Icons.bar_chart_rounded,
    Icons.person_outline_rounded,
  ];

  static const _svgAssets = <int, String>{
    0: 'assets/svg/home.svg',
  };

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(40.w, 8.h, 40.w, bottom + 16.h),
      child: Container(
        height: 72.h,
        decoration: BoxDecoration(
          color: const Color(0xFF0C0C0F),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _icons.length,
            (i) => _NavItem(
              index: i,
              selectedIndex: selectedIndex,
              icon: _icons[i],
              svgAsset: _svgAssets[i],
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final IconData icon;
  final String? svgAsset;
  final void Function(int) onTap;

  const _NavItem({
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.onTap,
    this.svgAsset,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    final color = isSelected ? Colors.black : Colors.white.withValues(alpha: 0.55);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: SizedBox(
        width: 70.h,
        height: 70.h,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: isSelected ? 68.h : 36.h,
            height: isSelected ? 66.h : 36.h,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: svgAsset != null
                  ? SvgPicture.asset(
                      svgAsset!,
                      width: isSelected ? 28.w : 22.w,
                      height: isSelected ? 28.w : 22.w,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    )
                  : Icon(icon, color: color, size: isSelected ? 40.w : 22),
            ),
          ),
        ),
      ),
    );
  }
}
