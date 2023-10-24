import 'package:flutter/material.dart';

class SlideFadeTransition extends StatelessWidget {
  const SlideFadeTransition({
    super.key,
    required this.position,
    required this.direction,
    required this.child,
    required this.animationController,
    required this.index,
  });

  final double position;
  final int direction;
  final Widget child;
  final AnimationController animationController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      maintainState: true,
      visible: index < 4 || position > 0.3,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        )),
        child: FadeTransition(
          opacity: Tween<double>(
            begin: index < 4 ? 1.0 : 0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animationController,
            curve: Curves.easeInOut,
          )),
          child: child,
        ),
      ),
    );
  }
}
