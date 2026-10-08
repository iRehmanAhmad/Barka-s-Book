import 'package:flutter/material.dart';
import '../../../../core/widgets/bouncy_button.dart';

class SubjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String heroLetters;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final bool isUrdu;
  final String? imageAsset;

  const SubjectCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.heroLetters,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
    this.isUrdu = false,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onPressed: onTap,
      minHeight: 148,
      minWidth: double.infinity,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(32),
      gradientColors: gradientColors,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            // Character / Image Badge
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: imageAsset != null
                  ? Image.asset(
                      imageAsset!,
                      fit: BoxFit.contain,
                      errorBuilder: (ctx, err, stack) => _buildFallbackBadge(),
                    )
                  : _buildFallbackBadge(),
            ),
            const SizedBox(width: 18),
            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: isUrdu ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: isUrdu ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.28),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          heroLetters,
                          style: TextStyle(
                            fontSize: isUrdu ? 16 : 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isUrdu ? 26 : 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                      shadows: const [
                        Shadow(
                          color: Color(0x33000000),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Play Button Arrow Pill
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackBadge() {
    return Center(
      child: Text(
        heroLetters,
        style: TextStyle(
          fontSize: isUrdu ? 28 : 24,
          fontWeight: FontWeight.w900,
          color: gradientColors.first,
          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
        ),
      ),
    );
  }
}
