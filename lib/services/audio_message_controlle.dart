import 'dart:async';
import 'package:chatapp/widgets/wave_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioMessageBubble extends StatefulWidget {
  final String audioUrl , voiceMessageTime ;
  
  AudioMessageBubble({required this.audioUrl , required this.voiceMessageTime });

  @override
  _AudioMessageBubbleState createState() => _AudioMessageBubbleState();
}

class _AudioMessageBubbleState extends State<AudioMessageBubble> {
  bool isPlaying = false;
  late AudioPlayer _audioPlayer;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String messageTimeCount = '00:00'; 
  bool showTimer = false; 

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();


    _audioPlayer.onPlayerComplete.listen((event) {
      stopTimer();
        resetTimer();
      setState(() {
        
        isPlaying = false;
      });
    });
  }

    Future<void> togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
      stopTimer(); 
    }    
    else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
      startTimerCounting();
      }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        messageTimeCount = _formatDuration(_stopwatch.elapsed);
      });
    });
  }

    String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

    void startTimerCounting() {
      setState(() {
        showTimer = true;
      });
    _stopwatch.start();
    startTimer();
  }


  void stopTimer() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  Duration parseTime(String time) {
  List<String> parts = time.split(":");
  int minutes = int.parse(parts[0]);
  int hours = int.parse(parts[1]);
  return Duration(minutes : minutes, hours: hours);
}


   void resetTimer() {
    _stopwatch.reset();
    setState(() {
     showTimer = false;
     messageTimeCount = "00:00";
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
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
                  size: 30,
                ),
                onPressed: togglePlayPause,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              Flexible(
                child: isPlaying
                    ? const MovingSoundWaves(
                        waveColor: Colors.black, height: 40, width: 100)
                    : AudioWaveform(waveColor: Colors.black, width: 14),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text( showTimer ? messageTimeCount : widget.voiceMessageTime,
                    style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.w600)),
              )
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
      children: List.generate(widget.width, (index) {
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
