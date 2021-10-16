import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../modal/notification_modal.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

String calculateTimeDifferenceBetween(DateTime startDate, DateTime endDate) {
  int seconds = endDate.difference(startDate).inSeconds;
  if (seconds < 60)
    return '${seconds}s';
  else if (seconds >= 60 && seconds < 3600)
    return '${startDate.difference(endDate).inMinutes.abs()}m';
  else if (seconds >= 3600 && seconds < 86400)
    return '${startDate.difference(endDate).inHours.abs()}h';
  else {
    int days = startDate.difference(endDate).inDays.abs();
    if (days > 7) {
      return '${DateFormat('MMMd').format(startDate)}';
    } else {
      return '${days}d';
    }
  }
}

String toTitle(String fullName) {
  String titleName = '';
  fullName.split(' ')
    ..forEach((name) {
      name = name[0].toUpperCase() + name.substring(1);
      titleName += name + ' ';
    });
  return titleName.trimRight();
}

enum Consent {
  Consent_Already_Obtained,
  Consent_Not_Required,
  This_Post_Has_No_Image,
  Consent_On_Hakim,
  Consent_Later
}

var httpClient = new HttpClient();
Future<File> downloadFile(String url, String filename) async {
  var request = await httpClient.getUrl(Uri.parse(url));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = new File('$dir/$filename');
  await file.writeAsBytes(bytes);
  return file;
}

DateTime toDateTime(Timestamp timestamp) {
  return DateTime.parse(timestamp.toDate().toString());
}

String consentToString(Consent consent) {
  switch (consent) {
    case Consent.Consent_Already_Obtained:
      return 'Consent Already Obtained';
    case Consent.Consent_Later:
      return 'Consent Later';
    case Consent.Consent_Not_Required:
      return 'Consent Not Required';
    case Consent.Consent_On_Hakim:
      return 'Consent On Hakim';
    case Consent.This_Post_Has_No_Image:
      return 'This Post Has No Image';
  }
}

types.User toUser(Map<String, dynamic> data, String id) {
  Timestamp createdAt = Timestamp.fromMicrosecondsSinceEpoch(data['createdAt']);
  Timestamp updatedAt = Timestamp.fromMicrosecondsSinceEpoch(data['updatedAt']);

  final json = {
    'createdAt': createdAt.microsecondsSinceEpoch,
    'firstName': data['firstName'],
    'id': id,
    'imageUrl': data['imageUrl'],
    'lastName': data['lastName'],
    'lastSeen': data['lastSeen'],
    'metadata': data['metadata'],
    'updatedAt': updatedAt.microsecondsSinceEpoch,
  };
  return types.User.fromJson(json);
}

String getMonthName(int M) {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  return months[M];
}
