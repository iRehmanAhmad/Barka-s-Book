import 'package:flutter/material.dart';
import '../../data/models/hotspot_item.dart';

class AnimatedHotspot extends StatefulWidget {
  final HotspotItem item;
  final VoidCallback? onTap;
  final double size;

  const AnimatedHotspot({
    super.key,
    required this.item,
    this.onTap,
    this.size = 200.0,
  });

  @override
  State<AnimatedHotspot> createState() => _AnimatedHotspotState();
}

class _AnimatedHotspotState extends State<AnimatedHotspot> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25).chain(CurveTween(curve: Curves.easeOutBack)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 1.0).chain(CurveTween(curve: Curves.bounceOut)), weight: 50),
    ]).animate(_animController);

    _rotateAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.08), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -0.08, end: 0.08), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.08, end: 0.0), weight: 25),
    ]).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _triggerAnimation() {
    _animController.forward(from: 0.0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = widget.item.fallbackImage ?? widget.item.assetPath;
    final hasImage = imagePath.isNotEmpty && (imagePath.endsWith('.png') || imagePath.endsWith('.jpg'));

    return GestureDetector(
      onTap: _triggerAnimation,
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotateAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFFFF0F5),
                      Color(0xFFFFE3EC),
                    ],
                    stops: [0.6, 0.85, 1.0],
                  ),
                  border: Border.all(
                    color: const Color(0xFFFF85A1),
                    width: 5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x38FF5D8F),
                      blurRadius: 22,
                      offset: Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glossy highlight curve
                      Positioned(
                        top: 0,
                        left: 20,
                        right: 20,
                        height: widget.size * 0.35,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(0.55),
                                Colors.white.withOpacity(0.0),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),

                      // Real Illustration Image or Fallback
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: hasImage
                            ? Image.asset(
                                imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (ctx, err, stack) => _buildFallbackIcon(),
                              )
                            : _buildFallbackIcon(),
                      ),

                      // Sweet "Tap Me! ✨" pill badge at bottom
                      Positioned(
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD166),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x28000000),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Tap! ✨',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E1B4B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.touch_app_rounded,
          size: widget.size * 0.45,
          color: const Color(0xFFFF5D8F),
        ),
        const SizedBox(height: 4),
        const Text(
          'Tap to Play!',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1B4B),
          ),
        ),
      ],
    );
  }
}
