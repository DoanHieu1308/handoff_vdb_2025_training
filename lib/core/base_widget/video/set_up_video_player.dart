import 'dart:async';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Web-specific imports
import 'web_video_controller.dart' if (dart.library.io) 'web_video_controller_stub.dart';

import '../../../config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';

class VideoPlayerHandle {
  late _SetUpVideoPlayerState _state;
  bool _attached = false;

  void _attach(_SetUpVideoPlayerState state) {
    _state = state;
    _attached = true;
  }

  void play() => _attached ? _state._play() : null;
  void pause() => _attached ? _state._pause() : null;
  bool get isPlaying =>
      _attached && _state._controller?.value.isPlaying == true;
}

class SetUpVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final File? fileVideo;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isAsset;
  final bool autoPlay;
  final bool looping;
  final bool startPaused;
  final VideoPlayerHandle? handle;

  const SetUpVideoPlayer({
    super.key,
    required this.videoUrl,
    this.fileVideo,
    this.width,
    this.height,
    this.fit,
    this.isAsset = false,
    this.autoPlay = false,
    this.looping = false,
    this.startPaused = true,
    this.handle,
  });

  @override
  State<SetUpVideoPlayer> createState() => _SetUpVideoPlayerState();
}

class _SetUpVideoPlayerState extends State<SetUpVideoPlayer>
    with RouteAware, AutomaticKeepAliveClientMixin {
  VideoPlayerController? _controller;
  WebViewController? _ytController;
  bool _initialized = false;
  bool _disposed = false;
  bool _isVisible = true;
  bool _isInViewport = true;

  Timer? _visibilityDebounceTimer;
  static const Duration _visibilityDebounceDelay =
  Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();

    if (kIsWeb) return; // web sẽ render HtmlWidget trong build()

    if (widget.videoUrl.isYoutubeUrl) {
      _ytController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) {
              if (widget.autoPlay && !widget.startPaused && !_disposed) {
                _ytController?.runJavaScript("""
                  var video = document.querySelector('video');
                  if(video && video.paused){ video.muted = true; video.play(); }
                """);
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(
            "${widget.videoUrl.youtubeEmbedUrl}?autoplay=1&mute=1&playsinline=1&controls=0&rel=0&modestbranding=1"));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _initializeVideoController();
      });
    }
  }

  Future<void> _initializeVideoController() async {
    if (_disposed) return;

    try {
      _controller?.dispose();

      if (widget.fileVideo != null) {
        _controller = VideoPlayerController.file(widget.fileVideo!);
      } else if (widget.isAsset) {
        _controller = VideoPlayerController.asset(widget.videoUrl);
      } else {
        _controller =
            VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      }

      _controller!.setLooping(widget.looping);
      _controller!.setVolume(0.0);

      await _controller!.initialize();
      if (!mounted || _disposed) return;

      setState(() => _initialized = true);
      widget.handle?._attach(this);

      if (!_disposed) {
        Timer(const Duration(milliseconds: 100), _checkAndPlay);
      }
    } catch (e) {
      print('Error initializing video: $e');
      _controller?.dispose();
      _controller = null;
    }
  }

  void _play() {
    if (!_disposed && _initialized && _isVisible && _isInViewport) {
      final wasPlaying = _controller?.value.isPlaying ?? false;
      _controller?.play();
      if (!wasPlaying) setState(() {});
    }
  }

  void _pause() {
    if (!_disposed && _controller?.value.isPlaying == true) {
      _controller?.pause();
      setState(() {});
    }
  }

  void _checkAndPlay() {
    if (_disposed) return;
    _visibilityDebounceTimer?.cancel();
    _visibilityDebounceTimer =
        Timer(_visibilityDebounceDelay, _performPlayPause);
  }

  void _performPlayPause() {
    if (_disposed) return;

    if (kIsWeb) {
      if (widget.videoUrl.isYoutubeUrl) {
        if (_isVisible && _isInViewport) {
          WebVideoController.playYoutubeVideo();
        } else {
          WebVideoController.pauseYoutubeVideo();
        }
      } else {
        if (_isVisible && _isInViewport && widget.autoPlay && !widget.startPaused) {
          WebVideoController.playCustomVideo();
        } else {
          WebVideoController.pauseCustomVideo();
        }
      }
      return;
    }

    // --- Mobile logic giữ nguyên ---
    if (widget.videoUrl.isYoutubeUrl) {
      if (_isVisible && _isInViewport && widget.autoPlay && !widget.startPaused) {
        _ytController?.runJavaScript("""
        var video = document.querySelector('video');
        if(video && video.paused){ video.muted = true; video.play(); }
      """);
      } else {
        _ytController?.runJavaScript("""
        var video = document.querySelector('video');
        if(video && !video.paused){ video.pause(); }
      """);
      }
    } else {
      if (_initialized &&
          _isVisible &&
          _isInViewport &&
          widget.autoPlay &&
          !widget.startPaused) {
        if (!_controller!.value.isPlaying) _controller!.play();
      } else {
        if (_controller?.value.isPlaying == true) _controller?.pause();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _visibilityDebounceTimer?.cancel();
    _visibilityDebounceTimer = null;
    routeObserver.unsubscribe(this);
    try {
      _controller?.pause();
      _controller?.dispose();
      _controller = null;
      _ytController = null;
    } catch (_) {}
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) routeObserver.subscribe(this, modalRoute);
  }

  @override
  void didPushNext() => _pause();
  @override
  void didPopNext() => _checkAndPlay();

  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // --- WEB MODE ---
    if (kIsWeb) {
      return VisibilityDetector(
        key: ValueKey(widget.videoUrl),
        onVisibilityChanged: (info) {
          final visibleFraction = info.visibleFraction;
          final newVisible = visibleFraction > 0.6;
          final newInViewport = visibleFraction > 0.6;
          if (_isVisible != newVisible || _isInViewport != newInViewport) {
            setState(() {
              _isVisible = newVisible;
              _isInViewport = newInViewport;
            });
          }
        },
        child: !_isVisible
            ? SizedBox(
          width: widget.width ?? 300,
          height: widget.height ?? 200,
          child: const Center(child: Text("Video paused")),
        )
            : HtmlWidget(
          widget.videoUrl.isYoutubeUrl
              ? """
              <iframe id="ytplayer"
                width="${widget.width ?? 300}" height="${widget.height ?? 200}"
                src="${widget.videoUrl.youtubeEmbedUrl}?enablejsapi=1&autoplay=${widget.autoPlay ? 1 : 0}&mute=1&playsinline=1&loop=${widget.looping ? 1 : 0}&rel=0&modestbranding=1"
                frameborder="0"
                allow="autoplay; encrypted-media"
                allowfullscreen>
              </iframe>
            """
              : """
              <video id="customVideo"
                src="${widget.videoUrl}"
                width="${widget.width ?? 300}"
                height="${widget.height ?? 200}"
                ${widget.autoPlay ? "autoplay" : ""}
                ${widget.looping ? "loop" : ""}
                ${widget.startPaused ? "" : "controls"}
                muted playsinline>
              </video>
            """,
        ),
      );
    }

    // --- MOBILE MODE (giữ nguyên logic cũ) ---
    if (widget.videoUrl.isYoutubeUrl) {
      return VisibilityDetector(
        key: ValueKey(widget.videoUrl),
        onVisibilityChanged: (info) {
          final visibleFraction = info.visibleFraction;
          final newVisible = visibleFraction > 0.8;
          final newInViewport = visibleFraction > 0.8;
          if (_isVisible != newVisible || _isInViewport != newInViewport) {
            _isVisible = newVisible;
            _isInViewport = newInViewport;
            _checkAndPlay();
          }
        },
        child: SizedBox(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 200,
          child: WebViewWidget(controller: _ytController!),
        ),
      );
    }

    if (!_initialized || _controller == null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return VisibilityDetector(
      key: ValueKey(widget.videoUrl),
      onVisibilityChanged: (info) {
        final visibleFraction = info.visibleFraction;
        final newVisible = visibleFraction > 0.4;
        final newInViewport = visibleFraction > 0.4;
        if (_isVisible != newVisible || _isInViewport != newInViewport) {
          _isVisible = newVisible;
          _isInViewport = newInViewport;
          _checkAndPlay();
        }
      },
      child: FittedBox(
        fit: widget.fit ?? BoxFit.cover,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }
}
