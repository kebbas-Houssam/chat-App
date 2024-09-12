import 'package:chatapp/widgets/wave_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioMessageBubble extends StatefulWidget {
  final String audioUrl;
  
  AudioMessageBubble({required this.audioUrl});

  @override
  _AudioMessageBubbleState createState() => _AudioMessageBubbleState();
}

class _AudioMessageBubbleState extends State<AudioMessageBubble> {
  bool isPlaying = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
      print('Pause audio');
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
      print('Start playing audio: ${widget.audioUrl}');
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.black,
                  size: 30 ,
                ),
                onPressed: togglePlayPause,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              
              Flexible(
                child: isPlaying ? const MovingSoundWaves(waveColor: Colors.black , height: 40, width: 100) 
                                 : AudioWaveform(waveColor: Colors.black ,width: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AudioWaveform extends StatefulWidget {

  final Color waveColor;
  // final double height;
  final int width; 
   AudioWaveform({
    Key? key,
    required this.waveColor,
    // required this.height,
    required this.width, // Default width of 120px
  });

  @override
  State<AudioWaveform> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveform> {

  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.width , (index) {
        return Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: widget.waveColor,
              ),
              width: 2.5,
              height: 9 + (index % 3) * 9,
              // color: Colors.white,
            ),
          ),
        );
      }),
    );
  }
}
