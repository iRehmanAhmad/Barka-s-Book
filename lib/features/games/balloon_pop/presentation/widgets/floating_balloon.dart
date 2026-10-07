import 'package:flutter/material.dart';

class FloatingBalloon extends StatefulWidget {
  final String symbol;
  final Color color;
  final VoidCallback onTap;
  final double size;

  const FloatingBalloon({
    super.key,
    required this.symbol,
    required this.color,
    required this.onTap,
    this.size = 100.0,
  });

  @override
  State<FloatingBalloon> createState() => _FloatingBalloonState();
}

class _FloatingBalloonState extends State<FloatingBalloon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _popAnimation;
  bool _isPopped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _popAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isPopped) return;
    setState(() {
      _isPopped = true;
    });
    _controller.forward().then((_) {
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isPopped) {
      return SizedBox(width: widget.size, height: widget.size * 1.3);
    }

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _popAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _popAnimation.value,
            child: Opacity(
              opacity: _isPopped ? 0.0 : 1.0,
              child: SizedBox(
                width: widget.size,
                height: widget.size * 1.3,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Balloon Body
                    Container(
                      width: widget.size,
                      height: widget.size * 1.15,
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(widget.size, widget.size * 1.15),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.symbol,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Knot and String
                    Positioned(
                      bottom: 0,
                      child: Column(
                        children: [
                          Container(
                            width: 10,
                            height: 6,
                            decoration: BoxDecoration(
                              color: widget.color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 12,
                            color: Colors.grey.shade400,
                          ),
                        ],
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
