import 'package:flutter/material.dart';

class AudioWaveform extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(10, (index) {
        return Container(
          width: 3,
          height: 10 + (index % 3) * 5,
          color: Colors.white,
        );
      }),
    );
  }
}