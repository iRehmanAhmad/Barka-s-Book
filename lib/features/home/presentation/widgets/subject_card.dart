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

  const SubjectCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.heroLetters,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
    this.isUrdu = false,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onPressed: onTap,
      minHeight: 140,
      minWidth: double.infinity,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            // Icon & Hero Symbol Container
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                heroLetters,
                style: TextStyle(
                  fontSize: isUrdu ? 30 : 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: isUrdu ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isUrdu ? 26 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 22),
          ],
        ),
      ),
    );
  }
}
