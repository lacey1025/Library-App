import 'package:flutter/material.dart';

class FlashingLogo extends StatefulWidget {
  const FlashingLogo({super.key, this.message});
  final String? message;

  @override
  State<FlashingLogo> createState() => _FlashingLogoState();
}

class _FlashingLogoState extends State<FlashingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.red[600],
      end: Colors.red[900],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return Image.asset(
                'assets/img/redbull.png',
                height: 200,
                color: _colorAnimation.value,
              );
            },
          ),
        ),
        if (widget.message != null)
          Padding(
            padding: EdgeInsets.fromLTRB(16, 32, 16, 0),
            child: Text(widget.message!, textAlign: TextAlign.center),
          ),
      ],
    );
  }
}
