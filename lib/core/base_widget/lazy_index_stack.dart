import 'package:flutter/material.dart';

/// A widget that displays a [IndexedStack] with truly lazy loaded children.
/// Widgets are only built when they are first accessed, improving memory usage.
class LazyIndexedStack extends StatefulWidget {
  /// {@macro lazy_indexed_stack}
  const LazyIndexedStack({
    super.key,
    this.index = 0,
    this.children = const [],
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
    this.preloadCount = 1, // Number of adjacent pages to preload
  });

  /// The index of the child to display.
  final int index;

  /// The list of children that can be displayed.
  final List<Widget> children;

  /// How to align the children in the stack.
  final AlignmentGeometry alignment;

  /// The direction to use for resolving [alignment].
  final TextDirection? textDirection;

  /// How to size the non-positioned children in the stack.
  final StackFit sizing;

  /// Number of adjacent pages to preload for better UX
  final int preloadCount;

  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  late final List<bool> _activatedChildren;
  late final List<Widget?> _builtChildren;

  @override
  void initState() {
    super.initState();
    _activatedChildren = List.generate(
      widget.children.length,
      (i) => false,
    );
    _builtChildren = List.generate(
      widget.children.length,
      (i) => null,
    );
    
    // Activate initial page and adjacent pages
    _activateInitialPages();
  }

  void _activateInitialPages() {
    final startIndex = (widget.index - widget.preloadCount).clamp(0, widget.children.length - 1);
    final endIndex = (widget.index + widget.preloadCount).clamp(0, widget.children.length - 1);
    
    for (int i = startIndex; i <= endIndex; i++) {
      _activateChild(i);
    }
  }

  @override
  void didUpdateWidget(LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _activateChild(widget.index);
      _activateAdjacentPages();
    }
  }

  void _activateChild(int? index) {
    if (index == null || index < 0 || index >= widget.children.length) return;
    if (!_activatedChildren[index]) {
      _activatedChildren[index] = true;
    }
  }

  void _activateAdjacentPages() {
    final startIndex = (widget.index - widget.preloadCount).clamp(0, widget.children.length - 1);
    final endIndex = (widget.index + widget.preloadCount).clamp(0, widget.children.length - 1);
    
    for (int i = startIndex; i <= endIndex; i++) {
      _activateChild(i);
    }
  }

  List<Widget> get children {
    return List.generate(
      widget.children.length,
      (i) {
        if (_activatedChildren[i]) {
          // Build widget if not already built
          if (_builtChildren[i] == null) {
            _builtChildren[i] = widget.children[i];
          }
          return _builtChildren[i]!;
        } else {
          // Return placeholder for non-activated children
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.sizing,
      index: widget.index,
      children: children,
    );
  }

  @override
  void dispose() {
    // Clear built children to free memory
    _builtChildren.clear();
    super.dispose();
  }
}
