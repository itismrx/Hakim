import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/constant.dart';

class CustomBottomBar extends StatelessWidget {
  final Function onPressed;

  CustomBottomBar(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          margin: const EdgeInsets.only(
              left: kPadding, right: kPadding, bottom: kPadding * 0.5),
          width: kPadding * 5,
          height: kPadding * 2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 3),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  spreadRadius: 2,
                  color: Colors.black26,
                  offset: Offset(
                    2,
                    2,
                  ),
                ),
              ]
              // color: Theme.of(context).primaryColor,
              ),
          child: Icon(
            FontAwesomeIcons.chevronRight,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    ]);
  }
}
