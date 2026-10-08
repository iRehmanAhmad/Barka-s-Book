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
            backgroundColor: currentPage > 1 ? const Color(0xFF06D6A0) : Colors.grey.shade200,
            minWidth: 60,
            minHeight: 60,
            borderRadius: BorderRadius.circular(30),
            padding: EdgeInsets.zero,
            child: Icon(
              prevIcon,
              color: currentPage > 1 ? Colors.white : Colors.grey.shade400,
              size: 32,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xFFFF85A1), width: 2.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1FFF5D8F),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('📖 ', style: TextStyle(fontSize: 16)),
                Text(
                  '$currentPage / $totalPages',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.deepNavy,
                  ),
                ),
              ],
            ),
          ),
          BouncyButton(
            onPressed: currentPage < totalPages ? onNext : () {},
            backgroundColor: currentPage < totalPages ? const Color(0xFFFF8C42) : Colors.grey.shade200,
            minWidth: 60,
            minHeight: 60,
            borderRadius: BorderRadius.circular(30),
            padding: EdgeInsets.zero,
            child: Icon(
              nextIcon,
              color: currentPage < totalPages ? Colors.white : Colors.grey.shade400,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
