import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserWidgetShimmer extends StatelessWidget {
  const UserWidgetShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Sckelton2(raduis: 50,),
        SizedBox(width: 12,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Sckelton(height: 14,width: 100,),
             SizedBox(height: 12,),
             Sckelton(height: 14,width: 150,),
          ]
          
        )
      ],
    );
  }
}

class Sckelton2 extends StatelessWidget {
  const Sckelton2({
    super.key,
    this.raduis,
  });
  final double? raduis;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black.withOpacity(1),
      highlightColor: Colors.black.withOpacity(0.3),
      child: Container(
        height: raduis,
        width: raduis,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color : Colors.black.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class Sckelton extends StatelessWidget {
  const Sckelton({
    super.key,
    this.height,
    this.width
  });
  final double? width , height;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black.withOpacity(1),
      highlightColor: Colors.black.withOpacity(0.3),
      child: Container(
        height: height,
        width: width,
        padding: const  EdgeInsets.all(8),
        decoration: BoxDecoration(
          color : Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.all(const Radius.circular(4))
        ),
      ),
    );
  }
}