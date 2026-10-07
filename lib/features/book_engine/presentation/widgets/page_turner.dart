import 'package:flutter/material.dart';
import 'package:barka_book/core/widgets/bouncy_button.dart';
import 'package:barka_book/core/theme/app_colors.dart';

class PageTurner extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool isRtl;

  const PageTurner({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
    this.isRtl = false,
  });

  @override
  Widget build(BuildContext context) {
    final prevIcon = isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded;
    final nextIcon = isRtl ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BouncyButton(
            onPressed: currentPage > 1 ? onPrevious : () {},
            backgroundColor: currentPage > 1 ? AppColors.oceanTeal : Colors.grey.shade300,
            minWidth: 64,
            minHeight: 64,
            borderRadius: BorderRadius.circular(32),
            child: Icon(prevIcon, color: Colors.white, size: 32),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.cardBorder, width: 2),
            ),
            child: Text(
              '$currentPage / $totalPages',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.deepNavy,
              ),
            ),
          ),
          BouncyButton(
            onPressed: currentPage < totalPages ? onNext : () {},
            backgroundColor: currentPage < totalPages ? AppColors.sunOrange : Colors.grey.shade300,
            minWidth: 64,
            minHeight: 64,
            borderRadius: BorderRadius.circular(32),
            child: Icon(nextIcon, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}
