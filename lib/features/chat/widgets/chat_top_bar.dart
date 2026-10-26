import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioai/core/theme/app_colors.dart';

class ChatTopBar extends StatelessWidget {
  final VoidCallback onToggleAIMode;
  final bool useAIAPI;

  const ChatTopBar({
    super.key,
    required this.onToggleAIMode,
    required this.useAIAPI,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Icon(Icons.arrow_back_rounded,
                  color: AppColors.primaryTextColor, size: 20),
            ),
          ),
          const SizedBox(width: 12),

          // Title area
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTextColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.psychology_rounded,
                        color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Physio Assistant',
                    style: GoogleFonts.dmSans(
                      color: AppColors.primaryTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Mode toggle — tappable pill
          GestureDetector(
            onTap: onToggleAIMode,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    useAIAPI ? Icons.auto_awesome_rounded : Icons.wifi_off_rounded,
                    size: 14,
                    color: useAIAPI
                        ? AppColors.accent
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    useAIAPI ? 'AI' : 'Offline',
                    style: GoogleFonts.dmSans(
                      color: useAIAPI
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
