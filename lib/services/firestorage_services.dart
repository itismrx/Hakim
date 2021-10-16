import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import '/services/notification_services.dart';
import 'package:path/path.dart';

class FirestorageService {
  FirestorageService._();
  static final instances = FirestorageService._();

  firebase_storage.Reference ref;

  Future<String> uploadFile(
      {@required String path, @required String filePath}) async {
    File file = File(filePath);
    try {
      firebase_storage.UploadTask task =
          firebase_storage.FirebaseStorage.instance.ref(path).putFile(file);

      return await task.storage.ref(path).getDownloadURL();
    } on firebase_core.FirebaseException catch (e) {
      print('\n\n${e.code}\n\n');
      return null;
      // throw e;
    }
  }

  Future<List<String>> bulkUploadFile({@required List<File> filePath}) async {
    List<String> imgRef = [];
    NotificationService()
        .showNotification(filePath.hashCode, "Uploading Meida");

    for (var img in filePath) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('case/${basename(img.path)}');

      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef.add(value);
        });
      });
    }
    return imgRef;
  }
}
