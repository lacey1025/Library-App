import 'package:flutter/material.dart';

class SheetImageAnimation extends StatefulWidget {
  const SheetImageAnimation({super.key});

  @override
  State<SheetImageAnimation> createState() => _SheetImageAnimationState();
}

class _SheetImageAnimationState extends State<SheetImageAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _offsetAnimation = Tween<double>(
      begin: 0.0,
      end: -900.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth;
        final containerHeight = 60.0;

        return ClipRect(
          child: SizedBox(
            width: containerWidth,
            height: containerHeight,
            child: AnimatedBuilder(
              animation: _offsetAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_offsetAnimation.value, 0),
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/img/sheet_header.png',
                      fit: BoxFit.contain,
                      height: containerHeight,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
