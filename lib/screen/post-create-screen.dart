import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/constant.dart';
import '/widgets/image-upload.dart';
import '/widgets/custom-chip.dart';

class WritePostScreen extends StatefulWidget {
  static const screenName = '/write-post';

  @override
  _WritePostScreenState createState() => _WritePostScreenState();
}

class _WritePostScreenState extends State<WritePostScreen> {
  bool _isVisible = false;
  var _focusNode;
  bool _isActive = false;
  TextEditingController _postController = TextEditingController();
  List<File> _pickedImages = [];

  @override
  void initState() {
    _focusNode = FocusNode();
    _postController.addListener(() {
      setState(() {
        _isActive = _postController.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo_rounded),
        onPressed: () async {
          final pickedImage = await buildPictureSelector(context);
          if (pickedImage != null)
            setState(() {
              _pickedImages.add(pickedImage);
            });
        },
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
            left: kPadding, right: kPadding, top: kPadding, bottom: kPadding),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(FontAwesomeIcons.times),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  GestureDetector(
                    onTap: _isActive
                        ? () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: Container(
                                      child: Column(
                                        children: [Text('Category')],
                                      ),
                                    ),
                                  );
                                });
                          }
                        : () {},
                    child: Container(
                      width: 85,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                          color: _isActive
                              ? Theme.of(context).primaryColor
                              : Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.4)),
                      child: Text(
                        'Post',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _focusNode.requestFocus();
                  },
                  child: Container(
                    height: _isVisible
                        ? _pickedImages.isEmpty
                            ? size.height * 2 / 5
                            : size.height * 1 / 4
                        : _pickedImages.isEmpty
                            ? size.height - 100
                            : size.height - 200,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: kPpOnPost,
                          backgroundImage: NetworkImage(
                              FirebaseAuth.instance.currentUser.photoURL),
                        ),
                        Container(
                          width: 250,
                          padding: const EdgeInsets.only(left: kPadding),
                          child: TextField(
                            autofocus: true,
                            maxLines: null,
                            focusNode: _focusNode,
                            controller: _postController,
                            decoration: InputDecoration(
                                hintText: 'What is on your mind?',
                                border: InputBorder.none),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_pickedImages.isNotEmpty)
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _pickedImages.length,
                    itemBuilder: (context, idx) {
                      return Container(
                        margin: const EdgeInsets.only(right: kPadding * .25),
                        child: Stack(children: [
                          Container(
                            height: 150,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                _pickedImages[(_pickedImages.length - 1) - idx],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _pickedImages.removeAt(idx);
                                  });
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.cancel_sharp,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ))
                        ]),
                      );
                    }),
              )
          ],
        ),
      ),
    );
  }
}
