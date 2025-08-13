import 'package:flutter/material.dart';

class FullscreenDialogWrapper extends StatefulWidget {
  final Widget child;
  const FullscreenDialogWrapper({super.key, required this.child});

  @override
  _FullscreenDialogWrapperState createState() => _FullscreenDialogWrapperState();
}

class _FullscreenDialogWrapperState extends State<FullscreenDialogWrapper> with SingleTickerProviderStateMixin {
  double _rawDrag = 0.0;
  double _displayOffset = 0.0;
  late AnimationController _resetController;
  late Animation<double> _resetAnimation;

  static const double startDragThreshold = 70; // dead zone trước khi bắt đầu dịch chuyển
  static const double dismissThresholdPercent = 0.3; // % chiều cao để dismiss
  static const double velocityThreshold = 1000;

  double get _dismissThreshold {
    final h = MediaQuery.of(context).size.height;
    return h * dismissThresholdPercent;
  }

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _resetAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOut),
    );
    _resetController.addListener(() {
      setState(() {
        _displayOffset = _resetAnimation.value;
      });
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _rawDrag += details.delta.dy;
    if (_rawDrag.abs() > startDragThreshold) {
      final effective = _rawDrag.sign * (_rawDrag.abs() - startDragThreshold);
      setState(() {
        _displayOffset = effective;
      });
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    final double velocity = details.primaryVelocity ?? 0.0;
    if (_displayOffset.abs() > _dismissThreshold ||
        velocity.abs() > velocityThreshold) {
      Navigator.of(context).maybePop();
    } else {
      _resetAnimation = Tween<double>(begin: _displayOffset, end: 0.0).animate(
        CurvedAnimation(parent: _resetController, curve: Curves.easeOut),
      );
      _resetController
        ..value = 0
        ..forward();
      _rawDrag = 0.0;
    }
  }

  double get _opacity {
    final d = _displayOffset.abs();
    final t = (d / 300).clamp(0.0, 1.0);
    return 1.0 - t * 0.5;
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: AnimatedBuilder(
        animation: _resetController,
        builder: (context, _) {
          return Transform.translate(
            offset: Offset(0, _displayOffset),
            child: Opacity(
              opacity: _opacity,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: widget.child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
