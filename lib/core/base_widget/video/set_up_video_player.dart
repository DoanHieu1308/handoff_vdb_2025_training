import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../config/routes/route_path/auth_routers.dart';

class VideoPlayerHandle {
  late _SetUpVideoPlayerState _state;
  bool _attached = false;

  void _attach(_SetUpVideoPlayerState state) {
    _state = state;
    _attached = true;
  }

  void play() {
    if (_attached) _state._play();
  }

  void pause() {
    if (_attached) _state._pause();
  }

  void seekTo(Duration position) {
    if (_attached) _state._seekTo(position);
  }

  bool get isPlaying => _attached && _state._controller.value.isPlaying;
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
    this.startPaused = false,
    this.handle,
  });

  @override
  State<SetUpVideoPlayer> createState() => _SetUpVideoPlayerState();
}

class _SetUpVideoPlayerState extends State<SetUpVideoPlayer>
    with SingleTickerProviderStateMixin, RouteAware, AutomaticKeepAliveClientMixin {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _showControls = false;
  Timer? _hideControlsTimer;
  bool _muted = true;
  bool _disposed = false;

  void _videoListener() {
    if (mounted && !_disposed) setState(() {});
  }

  @override
  void initState() {
    super.initState();

    if (widget.fileVideo != null) {
      _controller = VideoPlayerController.file(widget.fileVideo!);
    } else if (widget.isAsset) {
      _controller = VideoPlayerController.asset(widget.videoUrl);
    } else {
      _controller = VideoPlayerController.network(widget.videoUrl);
    }

    _controller.setLooping(widget.looping);
    _controller.setVolume(0.0);
    _controller.initialize().then((_) {
      if (!mounted) return;
      if (widget.autoPlay && !widget.startPaused) {
        _controller.play();
      }
      setState(() => _initialized = true);
    });

    _controller.addListener(_videoListener);

    // gắn handle nếu có
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.handle?._attach(this);
    });
  }

  @override
  bool get wantKeepAlive => true;

  // exposed helpers cho handle
  void _play() {
    if (_initialized && !_controller.value.isPlaying && !_disposed) {
      _controller.play();
      if (mounted) setState(() {});
    }
  }

  void _pause() {
    if (_initialized && _controller.value.isPlaying && !_disposed) {
      _controller.pause();
      if (mounted) setState(() {});
    }
  }

  void _seekTo(Duration pos) {
    if (_initialized && !_disposed) {
      _controller.seekTo(pos);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    routeObserver.unsubscribe(this);
    _hideControlsTimer?.cancel();
    
    try {
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
      _controller.removeListener(_videoListener);
      _controller.dispose();
    } catch (e) {
      print('Error disposing video controller: $e');
    }
    
    super.dispose();
  }

  // RouteAware callbacks
  @override
  void didPushNext() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    }
  }

  @override
  void didPopNext() {
    if (widget.autoPlay && !_controller.value.isPlaying) {
      _controller.play();
    }
  }

  void _togglePlayPause() {
    if (!_disposed) {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      if (mounted) setState(() {});
    }
  }

  void _toggleMute() {
    if (!_initialized) return;
    setState(() {
      _muted = !_muted;
      _controller.setVolume(_muted ? 0.0 : 1.0);
    });
  }

  void _onTapVideo() {
    setState(() {
      _showControls = true;
    });

    _togglePlayPause();

    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_initialized) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: _onTapVideo,
      child: FittedBox(
        fit: widget.fit ?? BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(_controller),
              _buildControls(context),
                Center(
                  child: IconButton(
                    icon: Icon(
                      _controller.value.isPlaying ? (_showControls ? Icons.pause : null) : Icons.play_arrow,
                      color: Colors.white.withOpacity(0.8),
                      size: 60,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 20,
                    icon: Icon(
                      _muted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: _toggleMute,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    final duration = _controller.value.duration;
    final position = _controller.value.position;

    return Container(
      height: 25,
      color: Colors.black12,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 2,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 3),
        ),
        child: Slider(
          value: position.inMilliseconds
              .toDouble()
              .clamp(0, duration.inMilliseconds.toDouble()),
          max: duration.inMilliseconds.toDouble(),
          onChanged: (value) {
            _controller.seekTo(Duration(milliseconds: value.toInt()));
          },
          activeColor: Colors.red,
          inactiveColor: Colors.white54,
        ),
      ),
    );
  }
}
