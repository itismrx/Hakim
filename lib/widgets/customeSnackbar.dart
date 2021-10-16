import 'package:flutter/material.dart';
import '/constant.dart';

SnackBar buildSnackBarWithAction(
    String label, String actionLabel, Function action, context) {
  return SnackBar(
    content: Text(label),
    action: SnackBarAction(
      label: actionLabel,
      textColor: Colors.white,
      onPressed: action,
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  );
}

SnackBar buildCloseableSnackBar(String label, context) {
  return SnackBar(
    duration: Duration(seconds: 5),
    action: SnackBarAction(
        label: 'X',
        textColor: Colors.white,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
    padding: const EdgeInsets.symmetric(
        vertical: kPadding * 0.5, horizontal: kPadding * 0.5),
    content: Padding(
      padding: const EdgeInsets.only(left: kPadding),
      child: Text(label),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
}

SnackBar buildSnackBar(String label, context) {
  return SnackBar(
    duration: Duration(seconds: 5),
    padding: const EdgeInsets.symmetric(
        vertical: kPadding * 0.5, horizontal: kPadding * 0.5),
    content: Padding(
      padding: const EdgeInsets.only(left: kPadding),
      child: Text(label),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
}
