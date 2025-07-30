import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SetUpVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final File? fileVideo;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isAsset;
  final bool autoPlay;
  final bool looping;

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
  });

  @override
  State<SetUpVideoPlayer> createState() => _SetUpVideoPlayerState();
}

class _SetUpVideoPlayerState extends State<SetUpVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _showControls = false;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();

    if (widget.fileVideo != null) {
      _controller = VideoPlayerController.file(widget.fileVideo!); //  File
    } else if (widget.isAsset) {
      _controller = VideoPlayerController.asset(widget.videoUrl); //  Asset
    } else {
      _controller = VideoPlayerController.network(widget.videoUrl); //  Network
    }

    _controller
      ..setLooping(widget.looping)
      ..initialize().then((_) {
        if (widget.autoPlay) _controller.play();
        setState(() => _initialized = true);
      });

    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {});
  }

  void _onTapVideo() {
    setState(() {
      _showControls = true;
    });

    _togglePlayPause();

    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 2), () {
      setState(() => _showControls = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: _onTapVideo,
      child: SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            FittedBox(
              fit: widget.fit ?? BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: Center(child: VideoPlayer(_controller)),
              ),
            ),
            _buildControls(context),
            if (_showControls)
              Center(
                child: IconButton(
                  icon: Icon(
                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white.withOpacity(0.8),
                    size: 40,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ),
          ],
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
          value: position.inMilliseconds.toDouble().clamp(0, duration.inMilliseconds.toDouble()),
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
