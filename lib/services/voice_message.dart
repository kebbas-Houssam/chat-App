import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:chatapp/services/audio_message_controlle.dart';
import 'package:chatapp/widgets/wave_animation_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceMessage extends StatefulWidget {
  const VoiceMessage( 
      {super.key,
      required this.sender,
      required this.receiver,
      required this.isGroupMessage,
      required this.groupeId});

  final String sender;
  final List receiver;
  final bool isGroupMessage;
  final String groupeId;

  @override
  State<VoiceMessage> createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage> {
  bool _isRecording = false;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String formattedTime = "00:00";
  String? voiceMessageTime;
 
  late AudioRecorder _audioRecorder;
  String? _recordingFilePath;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
  }


   void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        formattedTime = _formatDuration(_stopwatch.elapsed);
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
    _stopwatch.start();
    startTimer();
  }
  
   void stopTimer() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  void resetTimer() {
    _stopwatch.reset();
    setState(() {
      voiceMessageTime = formattedTime;
      formattedTime = "00:00";
    });
  }

  
  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        Directory tempDir = await getTemporaryDirectory();
        await _audioRecorder.start(RecordConfig(),
            path: '${tempDir.path}/audio_message.m4a');

        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

     Future<void> _stopRecording() async {
    try {
     String? path = await _audioRecorder.stop();
      setState(()  {
        _isRecording = false;
      });
      if (path != null ) {
        await _uploadAudio(File(path), widget.sender, widget.receiver,
            widget.isGroupMessage, widget.groupeId);
      }
      else {print('user cancel sending ');}
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<void> _uploadAudio(File audioFile, String sender, List receiver,
      bool isGroupMessage, String groupeId) async {
    try {
      String fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      Reference ref =
          FirebaseStorage.instance.ref().child('audio_messages/$fileName');
      UploadTask uploadTask = ref.putFile(audioFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('messages').add({
        'type': 'audio',
        'text': downloadUrl,
        'time': FieldValue.serverTimestamp(),
        'sender': sender,
        'receiver': receiver, //user id
        'isGroupMessage': isGroupMessage,
        'groupeId': groupeId,
        'voiceMessageTime' : voiceMessageTime , 
      });

      print('Audio message sent successfully');
    } catch (e) {
      print('Error uploading audio: $e');
    }
  }
   @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _isRecording
            ? Container(
                width: (MediaQuery.of(context).size.width) * 0.6,
                height: 50,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Row(
                  children: [
                    
                    IconButton(
                      alignment: Alignment.centerLeft,
                      icon: _isRecording
                          ? const Icon(
                              Icons.stop_rounded,
                              color: Colors.white,
                              size: 30,
                            )
                          : const SizedBox.shrink(),
                      onPressed: () {
                        if (_isRecording) {
                          _stopRecording();
                        } else {
                          _startRecording();
                        }
                        stopTimer();
                        resetTimer();
                      },
                    ),
                    const Expanded(
                        child:  MovingSoundWaves(
                                waveColor: Colors.white,
                                height: 20,
                                width: 50,
                              )
                            ),

                     Padding(
                      padding:  const EdgeInsets.all(10),
                      child: Text(
                        formattedTime,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  ],
                ),
              )
            : IconButton(
                onPressed: () {
                  startTimerCounting();
                  if (_isRecording) {
                    _stopRecording();
                  } else {
                    _startRecording();
                  }
                },
                icon: const Icon(
                  Icons.mic_none_rounded,
                  color: Colors.black,
                  size: 30,
                ),
              )
      ],
    );
  }
}
