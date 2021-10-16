import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:hakim_app/modal/doctor-modal.dart';
import 'package:hakim_app/provider/AuthProvider.dart';
import 'package:hakim_app/services/firestore_database.dart';
import 'package:hakim_app/widgets/profile-picture.dart';
import 'package:hakim_app/widgets/shimmer_widget.dart';
import '/constant.dart';
import '/screen/chat/chat-page.dart';

import 'util.dart';

class UsersPage extends StatefulWidget {
  static const String screenName = '/users-screen';
  const UsersPage({Key key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool isTapped = false;
  void _handlePressed(types.User otherUser, BuildContext context) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    Navigator.of(context).pop();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
        ),
      ),
    );
  }

  Widget _buildAvatar(types.User user) {
    return FutureBuilder(
      future: FirestoreDatabase(uid: AuthProvider().getCurrentUser().uid)
          .getADoctor(uid: user.id),
      builder: (context, AsyncSnapshot<DoctorModal> snapshot) {
        if (snapshot.hasData) {
          DoctorModal doctor = snapshot.data;
          return ProfilePicture(
            url: doctor.profilePictureUrl,
            fullName: doctor.fullName,
            radius: kPpOnPost,
          );
        }
        return ShimmerWidget.circular(width: kPpOnPost, height: kPpOAppBar);
      },
    );
  }

  _buildAppBar(context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Users',
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: 'Roboto',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: StreamBuilder<List<types.User>>(
        stream: FirebaseChatCore.instance.users(),
        initialData: const [],
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: const Text('No users'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final user = snapshot.data[index];

              return Column(
                children: [
                  ListTile(
                    onTap: isTapped
                        ? () {}
                        : () {
                            setState(() {
                              isTapped = true;
                            });
                            _handlePressed(user, context);
                          },
                    leading: _buildAvatar(user),
                    title: Text(getUserName(
                        user)), // TODO: Add Verfied sign and subtile of the speciality
                  ),
                  SizedBox(
                    height: kPadding,
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
