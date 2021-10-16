import 'package:flutter/material.dart';

import '../constant.dart';

class CustomeButton extends StatelessWidget {
  final Widget label;
  final double width;
  final double height;
  final Function onTap;
  Color backgourndColor = Colors.blue;
  Color textColor = Colors.white;

  CustomeButton({
    Key key,
    this.label,
    this.width,
    this.height,
    this.onTap,
    this.backgourndColor,
    this.textColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: backgourndColor,
          ),
          child: label),
    );
  }
}
