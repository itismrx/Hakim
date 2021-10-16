import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constant.dart';

class SocialMeidaIconsCard extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  SocialMeidaIconsCard({this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        width: width * 0.4,
        height: kPadding * 2.5,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        child: FaIcon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
    );
  }
}
