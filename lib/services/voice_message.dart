import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceMessage extends StatefulWidget {

  const VoiceMessage({ super.key , required this.sender , required this.receiver ,required this.isGroupMessage,required this.groupeId});

  final String sender ;
  final List receiver ;
  final bool isGroupMessage;
  final String groupeId ;

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
        await _audioRecorder.start(RecordConfig(), path: '${tempDir.path}/audio_message.m4a');
         
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
      setState(() {
        _isRecording = false;
      });
      if (path != null) {
        await _uploadAudio(File(path) ,widget.sender,  widget.receiver , widget.isGroupMessage , widget.groupeId );
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

    Future<void> _uploadAudio(File audioFile , String sender , List receiver ,bool isGroupMessage,String groupeId )async {
    try {
      String fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      Reference ref = FirebaseStorage.instance.ref().child('audio_messages/$fileName');
      UploadTask uploadTask = ref.putFile(audioFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('messages').add({
        'type': 'audio',
        'text': downloadUrl,
        'time': FieldValue.serverTimestamp(),
        'sender': sender,
        'receiver' : receiver ,//user id 
        'isGroupMessage' : isGroupMessage ,
        'groupeId' : groupeId,     
      });

      print('Audio message sent successfully');
    } catch (e) {
      print('Error uploading audio: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return IconButton(
             icon: Icon(_isRecording ? Icons.stop : Icons.mic_none_rounded ,
                         color: Colors.black,
                         size: 30,),
             onPressed: () {
                 if (_isRecording) {
                   _stopRecording();
                 } else {
                   _startRecording();
                 }
               },);
  }
}