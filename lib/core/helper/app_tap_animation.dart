import 'package:flutter/material.dart';

class AppTapAnimation extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? highlightColor;

  const AppTapAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.borderRadius,
    this.splashColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          onLongPress: enabled ? onLongPress : null,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          splashColor: splashColor ?? Colors.grey.withValues(alpha: 0.2),
          highlightColor: highlightColor ?? Colors.grey.withValues(alpha: 0.1),
          child: child,
        ),
      ),
    );
  }
}
