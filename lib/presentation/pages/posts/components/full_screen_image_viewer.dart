import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/presentation/widget/show_image_with_url.dart';
import 'package:handoff_vdb_2025/presentation/widget/show_video_with_url.dart';

class FullScreenImageViewer extends StatefulWidget {
  final String mediaFile;
  final String tag;

  const FullScreenImageViewer({
    super.key,
    required this.mediaFile,
    required this.tag,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> with TickerProviderStateMixin {
  late final TransformationController _transformationController;
  Animation<Matrix4>? _animation;
  late final AnimationController _zoomController;

  late final AnimationController _dragResetController;
  Animation<double>? _dragResetAnimation;
  final ValueNotifier<double> _verticalDrag = ValueNotifier(0.0);

  final double _minScale = 0.989;
  final double _maxScale = 4.0;
  final double _dismissThreshold = 130.0;
  final double _verticalDragThreshold = 5.0;

  Offset? _doubleTapLocalPosition;

  bool get _isZoomed => _transformationController.value.getMaxScaleOnAxis() > _minScale + 0.01;

  bool get _isZoomAnimating => _zoomController.isAnimating;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();

    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {
      if (_animation != null) {
        _transformationController.value = _animation!.value;
      }
    });

    _dragResetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {
      if (_dragResetAnimation != null) {
        _verticalDrag.value = _dragResetAnimation!.value;
      }
    });
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _dragResetController.dispose();
    _transformationController.dispose();
    _verticalDrag.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (_isZoomAnimating) return;
    final currentMatrix = _transformationController.value;
    final double currentScale = currentMatrix.getMaxScaleOnAxis();

    final bool atMax = currentScale >= _maxScale - 0.01;
    final double targetScale = atMax ? _minScale : _maxScale;

    Matrix4 end;

    if (targetScale == _minScale) {
      end = Matrix4.identity()..scale(_minScale);
    } else {
      final focal = _doubleTapLocalPosition ?? (MediaQuery.of(context).size.center(Offset.zero));
      final sceneFocal = _transformationController.toScene(focal);
      end =
          Matrix4.identity()
            ..translate(focal.dx, focal.dy)
            ..scale(targetScale)
            ..translate(-sceneFocal.dx, -sceneFocal.dy);
    }

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: end,
    ).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeOutCubic),
    );
    _zoomController.forward(from: 0);
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_isZoomed || _isZoomAnimating) return;
    if (_verticalDrag.value.abs() < _verticalDragThreshold &&
        details.delta.dy.abs() < _verticalDragThreshold) {
      _verticalDrag.value += details.delta.dy;
      return;
    }
    _verticalDrag.value += details.delta.dy;
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_isZoomed || _isZoomAnimating) return;
    if (_verticalDrag.value.abs() > _dismissThreshold) {
      _closeViewer();
      return;
    }
    _dragResetAnimation = Tween<double>(
      begin: _verticalDrag.value,
      end: 0.0,
    ).animate(
      CurvedAnimation(parent: _dragResetController, curve: Curves.easeOut),
    );
    _dragResetController.forward(from: 0);
  }

  Future<void> _closeViewer() async {
    if (_isZoomed) {
      _transformationController.value = Matrix4.identity();
    }
    context.pop();
  }

  Widget _buildContent() {
    if (widget.mediaFile.isVideoFile) {
      return ShowVideoWithUrl(videoUrl: widget.mediaFile);
    } else {
      return ShowImageWithUrl(imageUrl: widget.mediaFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder<double>(
          valueListenable: _verticalDrag,
          builder: (context, dragOffset, _) {
            final opacity = 1 - (dragOffset.abs() / 400).clamp(0.0, 0.6);
            return Transform.translate(
              offset: Offset(0, dragOffset),
              child: Opacity(
                opacity: opacity,
                child: Stack(
                  children: [
                    Center(
                      child: Hero(
                        tag: widget.tag,
                        child:
                            widget.mediaFile.isVideoFile
                                ? _buildContent()
                                : InteractiveViewer(
                                  transformationController:
                                      _transformationController,
                                  panEnabled: true,
                                  scaleEnabled: true,
                                  minScale: _minScale,
                                  maxScale: _maxScale,
                                  constrained: true,
                                  boundaryMargin: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  onInteractionEnd: (_) {
                                    // nothing extra
                                  },
                                  child: _buildContent(),
                                ),
                      ),
                    ),
                    if (!widget.mediaFile.isVideoFile)
                      !_isZoomed
                          ? Positioned.fill(
                            child: GestureDetector(
                              onDoubleTapDown: (details) {
                                _doubleTapLocalPosition = details.localPosition;
                              },
                              onDoubleTap: _handleDoubleTap,
                              onVerticalDragUpdate: _onVerticalDragUpdate,
                              onVerticalDragEnd: _onVerticalDragEnd,
                              behavior: HitTestBehavior.translucent,
                            ),
                          )
                          : Positioned.fill(
                            child: GestureDetector(
                              onDoubleTapDown: (details) => _handleDoubleTap(),
                              behavior: HitTestBehavior.translucent,
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
