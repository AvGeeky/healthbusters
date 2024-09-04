import 'package:flutter/material.dart';

class RotatingCancelButton extends StatefulWidget {
  const RotatingCancelButton({super.key});

  @override
  State<RotatingCancelButton> createState() => _RotatingCancelButtonState();
}

class _RotatingCancelButtonState extends State<RotatingCancelButton> with SingleTickerProviderStateMixin {
  bool isHovered = true;
  late AnimationController _rotateanimationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotateanimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

     _rotationAnimation = Tween<double>(
            begin: 0.0, end: 0.7853981633974483 * 2) // 45 degrees in radians
        .animate(CurvedAnimation(
            parent: _rotateanimationController, curve: Curves.easeInOut));
  }

  void rotateButton() {
    setState(() {
      isHovered = !isHovered;
      if (isHovered) {
        _rotateanimationController.reverse();
      } else {
        _rotateanimationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _rotateanimationController.forward();
      },
      onExit: (_) {
        _rotateanimationController.reverse();
      },
      child: isHovered
          ? IconButton(
              icon: Icon(
                  isHovered
                      ? Icons.menu
                      : Icons.close,
                  color: Colors.white),
              onPressed: rotateButton,
            )
          : AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle:
                      _rotationAnimation.value,
                  child: IconButton(
                    icon: const Icon(
                        Icons.close,
                        color: Colors.white),
                    onPressed: rotateButton,
                  ),
                );
              },
            ),
    );
  }
}