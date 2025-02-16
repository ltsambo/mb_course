// widgets/video_player_widget.dart
import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _showControls = true;
  bool _showVolumeSlider = false;
  double _volume = 0.5;
  bool _isCompleted = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        setState(() {
          _hasError = true;
        });
      });;
    _controller.setVolume(_volume);

    _controller.addListener(() {
      if (_controller.value.hasError) {
        setState(() {
          _hasError = true;
        });
      }
      if (_controller.value.position >= _controller.value.duration && !_isCompleted) {
        setState(() {
          _isCompleted = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _adjustVolume(double newVolume) {
    setState(() {
      _volume = newVolume.clamp(0.0, 1.0);
      _controller.setVolume(_volume);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : ''}$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _hasError 
      ? Image.asset(noVideoImagePath)
      :Padding(
        padding: const EdgeInsets.all(10.0), // Add padding around the player
        child: _controller.value.isInitialized
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16), // Rounded border radius
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      GestureDetector(
                        onTap: _toggleControls,
                        child: VideoPlayer(_controller),
                      ),
                      if (_showControls)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black45.withOpacity(0.7),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Progress Bar with Timestamps
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        _formatDuration(_controller.value.position),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      child: VideoProgressIndicator(
                                        _controller,
                                        allowScrubbing: true,
                                        colors: VideoProgressColors(
                                          playedColor: Colors.red,
                                          bufferedColor: Colors.grey,
                                          backgroundColor: Colors.black26,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        _formatDuration(_controller.value.duration),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.replay_10, color: Colors.white),
                                          onPressed: () {
                                            final position = _controller.value.position;
                                            _controller.seekTo(position - Duration(seconds: 10));
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            _isCompleted
                                                ? Icons.replay
                                                : _controller.value.isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (_isCompleted) {
                                                _controller.seekTo(Duration.zero);
                                                _controller.play();
                                                _isCompleted = false;
                                              } else {
                                                _controller.value.isPlaying
                                                    ? _controller.pause()
                                                    : _controller.play();
                                              }
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.forward_10, color: Colors.white),
                                          onPressed: () {
                                            final position = _controller.value.position;
                                            _controller.seekTo(position + Duration(seconds: 10));
                                          },
                                        ),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                _volume == 0
                                                    ? Icons.volume_off
                                                    : Icons.volume_up,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _showVolumeSlider = !_showVolumeSlider;
                                                });
                                              },
                                            ),
                                            if (_showVolumeSlider)
                                              Positioned(
                                                bottom: 40,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.volume_mute,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      Slider(
                                                        value: _volume,
                                                        min: 0,
                                                        max: 1,
                                                        onChanged: (value) {
                                                          _adjustVolume(value);
                                                        },
                                                      ),
                                                      Icon(
                                                        Icons.volume_up,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.settings, color: Colors.white),
                                          onPressed: () {
                                            // Open settings (placeholder)
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.fullscreen, color: Colors.white),
                                          onPressed: () {
                                            // Toggle fullscreen (placeholder)
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
