import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/constant.dart';
import 'package:image_picker/image_picker.dart';

buildPictureSelector(context) async {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  final val = await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          height: height * 0.35,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white10),
          child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upload',
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        icon: Icon(FontAwesomeIcons.times),
                        onPressed: () => Navigator.pop(context))
                  ],
                ),
                SizedBox(height: kPadding),
                ListTile(
                  leading: Icon(FontAwesomeIcons.image),
                  title: Text('Gallery'),
                  onTap: () {
                    {
                      fromGallery().then((pickedFile) {
                        if (pickedFile != null) {
                          print('>>>>>>>>>> ${pickedFile.name}');
                          // return File(pickedFile.path);
                          Navigator.pop(context, File(pickedFile.path));
                        }
                      });
                    }
                  },
                ),
                SizedBox(
                  height: kPadding,
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.camera),
                  title: Text('Camera'),
                  onTap: () async {
                    XFile pickedFile = await takePhoto();
                    if (pickedFile != null) {
                      Navigator.pop(context, File(pickedFile.path));
                    }
                  },
                )
              ],
            ),
          ),
        );
      });
  return val;
}
//   import 'package:flutter/material.dart';

Future<XFile> takePhoto() async {
  final picker = ImagePicker();
  XFile pickedFile = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 75,
    maxHeight: 400,
    maxWidth: 400,
  );

  if (pickedFile != null) {
    return Future.value(pickedFile);
  }
  return Future.value(null);
}

Future<XFile> fromGallery() async {
  final picker = ImagePicker();
  XFile pickedFile = await picker.pickImage(
    source: ImageSource.gallery,
  );
  if (pickedFile != null) {
    return Future.value(pickedFile);
  }
  return Future.value(null);
}
