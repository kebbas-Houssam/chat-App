import 'dart:async';
import 'package:flutter/material.dart';

class VoiceRecorder extends StatefulWidget {
  @override
  _VoiceRecorderState createState() => _VoiceRecorderState();
}

class _VoiceRecorderState extends State<VoiceRecorder> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String formattedTime = "00:00";

  // لتحديث الوقت كل ثانية
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        formattedTime = _formatDuration(_stopwatch.elapsed);
      });
    });
  }

  // لتنسيق عرض الوقت بالساعات والدقائق
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  // بدء التسجيل (تشغيل المؤقت)
  void startRecording() {
    _stopwatch.start();
    startTimer();
  }

  // إيقاف التسجيل (إيقاف المؤقت)
  void stopRecording() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  // إعادة تعيين المؤقت
  void resetRecording() {
    _stopwatch.reset();
    setState(() {
      formattedTime = "00:00";
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice Recorder"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formattedTime, // عرض الوقت المتغير
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: startRecording, // عند الضغط، يبدأ المؤقت
                  child: Text("Start"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: stopRecording, // عند الضغط، يتوقف المؤقت
                  child: Text("Stop"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: resetRecording, // عند الضغط، يتم إعادة المؤقت للصفر
                  child: Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
