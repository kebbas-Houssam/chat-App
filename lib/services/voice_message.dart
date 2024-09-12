import 'dart:io';
import 'dart:math';
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
 
 
  late AudioRecorder _audioRecorder;
  String? _recordingFilePath;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
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
      });

      print('Audio message sent successfully');
    } catch (e) {
      print('Error uploading audio: $e');
    }
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
                      // alignment: Alignment.centerLeft,
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
                      },
                    ),
                    const Expanded(
                        child:  MovingSoundWaves(
                                waveColor: Colors.white,
                                height: 20,
                                width: 50,
                              )
                            ),

                    const Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        '1:35',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )
                  ],
                ),
              )
            : IconButton(
                onPressed: () {
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
