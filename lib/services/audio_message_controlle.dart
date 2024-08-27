import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioMessageBubble extends StatefulWidget {
  final String audioUrl; // افترض أن لدينا رابط للملف الصوتي
  
  AudioMessageBubble({required this.audioUrl});

  @override
  _AudioMessageBubbleState createState() => _AudioMessageBubbleState();

}

class _AudioMessageBubbleState extends State<AudioMessageBubble> {
  @override
  void initState() {
    super.initState();
    
    _audioPlayer = AudioPlayer();
  }

   @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  bool isPlaying = false;
  late AudioPlayer _audioPlayer;

  Future<void> togglePlayPause() async {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      await  _audioPlayer.play(UrlSource(widget.audioUrl));
      print('Start playing audio: ${widget.audioUrl}');
    } else {
      await  _audioPlayer.pause();
      print('Pause audio');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth * 0.5,
          
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: togglePlayPause,
                ),
                SizedBox(width: 8),
                Expanded(child: AudioWaveform()),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AudioWaveform extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(10, (index) {
        return Container(
          width: 2,
          height: 5 + (index % 3) * 5.0,
          color: Colors.white,
        );
      }),
    );
  }
}