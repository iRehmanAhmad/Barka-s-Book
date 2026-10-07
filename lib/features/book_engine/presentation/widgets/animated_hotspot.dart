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
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F000000),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      size: widget.size * 0.45,
                      color: const Color(0xFFFFB703),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tap to Play!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF023047),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
