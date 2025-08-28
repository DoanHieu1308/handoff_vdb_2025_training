import 'package:flutter/material.dart';

Future<T?> showAppAnimatedModalBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  Duration duration = const Duration(milliseconds: 300),
  Curve curve = Curves.easeOut,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    transitionAnimationController: AnimationController(
      vsync: Navigator.of(context),
      duration: duration,
      reverseDuration: duration,
    ),
    builder: (_) {
      return AnimatedContainer(
        duration: duration,
        curve: curve,
        child: child,
      );
    },
  );
}
