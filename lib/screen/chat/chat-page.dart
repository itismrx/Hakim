import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hakim_app/modal/doctor-modal.dart';
import 'package:hakim_app/provider/AuthProvider.dart';
import 'package:hakim_app/services/firestore_database.dart';
import 'package:hakim_app/widgets/profile-picture.dart';
import 'package:hakim_app/widgets/shimmer_widget.dart';
import '../../utility.dart';
import '/screen/chat/util.dart';
import '/screen/profile-screen.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../constant.dart';

class ChatPage extends StatefulWidget {
  static const String screenName = '/chat-screen';
  const ChatPage({
    Key key,
    this.room,
  }) : super(key: key);

  final types.Room room;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;
  User _user = FirebaseAuth.instance.currentUser;

  @override
  Widget _buildAvatar(types.Room room) {
    var color = Colors.white;
    var otherUser;
    if (room.type == types.RoomType.direct) {
      try {
        otherUser = room.users.firstWhere(
          (u) => u.id != _user.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return ProfileScreen(otherUser.id);
            }));
          },
          child: CircleAvatar(
            backgroundColor: color,
            backgroundImage: hasImage ? NetworkImage(room.imageUrl) : null,
            radius: 20,
            child: !hasImage
                ? Text(
                    name.isEmpty ? '' : name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
          ),
        ),
        SizedBox(
          width: kPadding,
        ),
        Text(
          name,
          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildAvatar2(types.Room room) {
    var otherUser;
    if (room.type == types.RoomType.direct) {
      try {
        otherUser = room.users.firstWhere(
          (u) => u.id != _user.uid,
        );
      } catch (e) {
        // Do nothing if other user is not found
      }
    }

    return FutureBuilder(
      future: FirestoreDatabase(uid: AuthProvider().getCurrentUser().uid)
          .getADoctor(uid: otherUser.id),
      builder: (context, AsyncSnapshot<DoctorModal> snapshot) {
        if (snapshot.hasData) {
          DoctorModal doctor = snapshot.data;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfilePicture(
                url: doctor.profilePictureUrl,
                fullName: doctor.fullName,
                radius: kPpOnPost * .75,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return ProfileScreen(otherUser.id);
                  }));
                },
              ),
              SizedBox(
                width: kPadding,
              ),
              Text(
                toTitle(doctor.fullName),
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              SizedBox(
                width: kPadding * 0.2,
              ),
              if (doctor.isVerified)
                Icon(
                  Icons.verified,
                  color: Theme.of(context).primaryColor,
                  size: kPadding,
                ),
            ],
          );
        }
        return ShimmerWidget.circular(width: kPpOnPost, height: kPpOAppBar);
      },
    );
  }

  _buildAppBar() {
    return AppBar(
      // centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: _buildAvatar2(widget.room),
      actions: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: kPadding),
        //   child: IconButton(
        //       icon:
        //           Icon(Icons.more_vert, color: Theme.of(context).primaryColor),
        //       onPressed: () {}),
        // )
      ],
    );
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .35,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: kPadding,
                  ),
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
                    title: Text('Image'),
                    onTap: () {
                      Navigator.pop(context);
                      _handleImageSelection();
                    },
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //     _handleImageSelection();
                  //   },
                  //   child: const Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text('Photo'),
                  //   ),
                  // ),
                  ListTile(
                    leading: Icon(Icons.attach_file),
                    title: Text('File'),
                    onTap: () {
                      Navigator.pop(context);
                      _handleFileSelection();
                    },
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //     _handleFileSelection();
                  //   },
                  //   child: const Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text('File'),
                  //   ),
                  // ),
                  // TextButton(
                  //   onPressed: () => Navigator.pop(context),
                  //   child: const Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text('Cancel'),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path;
      final file = File(filePath ?? '');

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath ?? ''),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        print(e);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        print(e);
      }
    }
  }

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        final client = http.Client();
        final request = await client.get(Uri.parse(message.uri));
        final bytes = request.bodyBytes;
        final documentsDir = (await getApplicationDocumentsDirectory()).path;
        localPath = '$documentsDir/${message.name}';

        if (!File(localPath).existsSync()) {
          final file = File(localPath);
          await file.writeAsBytes(bytes);
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: StreamBuilder<types.Room>(
        initialData: widget.room,
        stream: FirebaseChatCore.instance.room(widget.room.id),
        builder: (context, snapshot) {
          return StreamBuilder<List<types.Message>>(
            initialData: const [],
            stream: FirebaseChatCore.instance.messages(snapshot.data),
            builder: (context, snapshot) {
              return Chat(
                showUserAvatars: true,
                showUserNames: true,
                isAttachmentUploading: _isAttachmentUploading,
                messages: snapshot.data ?? [],
                onAttachmentPressed: _handleAtachmentPressed,
                onMessageTap: _handleMessageTap,
                onPreviewDataFetched: _handlePreviewDataFetched,
                onSendPressed: _handleSendPressed,
                user: types.User(
                  id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
