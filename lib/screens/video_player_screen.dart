import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:myapp/models/video.dart';
import 'dart:io';

class VideoPlayerScreen extends StatefulWidget {
  final Video video;
  final String? title;

  const VideoPlayerScreen({super.key, required this.video, this.title});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    final isNetworkOrWeb = kIsWeb ||
        widget.video.path.startsWith('http') ||
        widget.video.path.startsWith('surah/');

    if (isNetworkOrWeb) {
      _controller = VideoPlayerController.networkUrl(Uri.base.resolve(widget.video.path))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
            _controller.play();
          }
        });
    } else {
      _controller = VideoPlayerController.file(File(widget.video.path))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
            _controller.play();
          }
        });
    }
  }

  void _togglePlay() {
    setState(() {
      _controller.value.isPlaying
          ? _controller.pause()
          : _controller.play();
    });
  }

  void _forward() async {
    final pos = await _controller.position;
    if (pos != null) {
      _controller.seekTo(pos + const Duration(seconds: 10));
    }
  }

  void _rewind() async {
    final pos = await _controller.position;
    if (pos != null) {
      final newPos = pos - const Duration(seconds: 10);
      _controller.seekTo(newPos < Duration.zero ? Duration.zero : newPos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title ?? widget.video.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            // Support for TV remote 'OK' (select) and keyboard 'Enter'
            if (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter) {
              _togglePlay();
              return KeyEventResult.handled;
            }

            if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              _forward();
              return KeyEventResult.handled;
            }

            if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              _rewind();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : const CircularProgressIndicator(color: Colors.green),
        ),
      ),
      // 🔥 Restored the FloatingActionButton that you previously had
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlay,
        backgroundColor: Colors.green,
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
