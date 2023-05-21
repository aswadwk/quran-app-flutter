import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  AudioPlayerWidget({required this.audioUrl});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }

      if (event == PlayerState.stopped) {
        setState(() {
          _isPlaying = false;
        });
      }

      if (event == PlayerState.playing) {
        setState(() {
          _isPlaying = true;
        });
      }

      if (event == PlayerState.paused) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _audioPlayer.onPlayerStateChanged.listen(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_isPlaying) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.play(UrlSource(widget.audioUrl));
        }
      },
      child: Icon(
        _isPlaying ? Icons.pause : Icons.play_arrow,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
