import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

AppBar buildAppBar(BuildContext context, String title, int _pageNumber) {
  return AppBar(
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back_rounded,
        color: Colors.black,
      ),
      onPressed: () => Navigator.pop(context),
    ),
    centerTitle: true,
    title: Text(
      title,
      style: Theme.of(context)
          .textTheme
          .headline4
          .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    actions: [
      if (_pageNumber != 0)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularPercentIndicator(
            radius: 40,
            lineWidth: 4,
            percent: (_pageNumber) / 4.0,
            center: Text(
              '${((_pageNumber) / 4.0 * 100).toStringAsFixed(0)}%',
            ),
            progressColor: Theme.of(context).accentColor,
          ),
        )
    ],
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
