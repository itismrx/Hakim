import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final bool isCircular;
  const ShimmerWidget.rectangular(
      {this.width = double.infinity,
      @required this.height,
      this.isCircular = false});

  const ShimmerWidget.circular(
      {@required this.width, @required this.height, this.isCircular = true});
  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      child: Container(
        height: this.height,
        width: this.width,
        decoration: !isCircular
            ? BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15))
            : BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
      ),
      baseColor: Colors.grey[400],
      highlightColor: Colors.grey[300]);
}
