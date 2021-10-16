import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hakim_app/provider/AuthProvider.dart';
import '/modal/doctor-modal.dart';
import '/provider/doctor-provider.dart';
import '/screen/chat/chat-page.dart';
import '/screen/chat/users-page.dart';
import '/screen/chat/util.dart';
import '/screen/profile-screen.dart';
import '/services/firestore_database.dart';
import '/utility.dart';
import '/widgets/chat-card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import '/constant.dart';
import '/widgets/customeSnackbar.dart';
import '/widgets/profile-picture.dart';
import '/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';

class Rooms extends StatefulWidget {
  static const String screenName = '/rooms-screen';

  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  User _firebaseUser = FirebaseAuth.instance.currentUser;
  types.User _user;

  @override
  void initState() {
    super.initState();
    initalizeUrs();
  }

  initalizeUrs() {
    fetchUser(_firebaseUser.uid, 'users').then((user) {
      setState(() {
        _user = toUser(user, user['id']);
      });
    });
  }

  _getOtherUser(types.Room room) {
    if (room.type == types.RoomType.direct) {
      try {
        return room.users.firstWhere(
          (u) => u.id != _firebaseUser.uid,
        );
      } catch (e) {
        // Do nothing if other user is not found
        return null;
      }
    }
  }

  // Widget _buildAvatar(types.Room room) {
  //   var color = Colors.white;

  //   if (room.type == types.RoomType.direct) {
  //     try {
  //       final otherUser = room.users.firstWhere(
  //         (u) => u.id != _firebaseUser.uid,
  //       );

  //       color = getUserAvatarNameColor(otherUser);
  //     } catch (e) {
  //       // Do nothing if other user is not found
  //     }
  //   }

  //   final hasImage = room.imageUrl != null;
  //   final name = room.name ?? '';

  //   return Container(
  //     margin: const EdgeInsets.only(right: 16),
  //     child: CircleAvatar(
  //       backgroundColor: color,
  //       backgroundImage: hasImage ? NetworkImage(room.imageUrl) : null,
  //       radius: 20,
  //       child: !hasImage
  //           ? Text(
  //               name.isEmpty ? '' : name[0].toUpperCase(),
  //               style: const TextStyle(color: Colors.white),
  //             )
  //           : null,
  //     ),
  //   );
  // }

  Widget _buildAvatar2(types.Room room) {
    var color = Colors.white;
    var otherUser;
    if (room.type == types.RoomType.direct) {
      try {
        otherUser = room.users.firstWhere(
          (u) => u.id != _firebaseUser.uid,
        );

        color = getUserAvatarNameColor(otherUser);
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
          return ProfilePicture(
            url: doctor.profilePictureUrl,
            fullName: doctor.fullName,
            radius: kPpOnPost * .75,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return ProfileScreen(otherUser.id);
              }));
            },
          );
        }
        return ShimmerWidget.circular(width: kPpOnPost, height: kPpOAppBar);
      },
    );
  }

  _buildChatShimmering() {
    return ListTile(
      leading:
          ShimmerWidget.circular(width: kPadding * 2, height: kPadding * 2),
      title: ShimmerWidget.rectangular(
        height: kPadding * 0.5,
        width: 25,
      ),
      subtitle: Container(
        width: 15,
        child: ShimmerWidget.rectangular(
          height: kPadding * 0.5,
          width: 15,
        ),
      ),
    );
  }

  _buildAppBar(DoctorModal doctorModal) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(12),
        child: ProfilePicture(
          fullName: doctorModal.fullName,
          url: doctorModal.profilePictureUrl,
          radius: kPpOAppBar,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => ProfileScreen(doctorModal.uid),
            ),
          ),
        ),
      ),
      title: Text(
        'Messages',
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: 'Roboto',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w800),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          child: IconButton(
              icon: Icon(Icons.search, color: Theme.of(context).primaryColor),
              onPressed: () {
                // navigate to users page
                Navigator.pushNamed(context, UsersPage.screenName);
              }),
        )
      ],
    );
  }

  _buildBody() {
    return StreamBuilder<List<types.Room>>(
      stream: FirebaseChatCore.instance.rooms(),
      initialData: const [],
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.data.isEmpty) {
          return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: Column(
                children: [
                  _buildChatShimmering(),
                  _buildChatShimmering(),
                  _buildChatShimmering(),
                  _buildChatShimmering(),
                ],
              ));
        }
        if (snapshot.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
              buildCloseableSnackBar(snapshot.error.toString(), context));
          return null;
        }
        if (snapshot.data.isEmpty) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              bottom: 200,
            ),
            child: Column(
              children: [
                _buildChatShimmering(),
                _buildChatShimmering(),
                _buildChatShimmering(),
                _buildChatShimmering(),
              ],
            ),
          );
        }
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final room = snapshot.data[index];
              final otherUser = _getOtherUser(room);

              return ChatCard(
                context: context,
                roomId: room.id,
                room: room,
                avater: _buildAvatar2(room),
                ppUrl: otherUser.imageUrl ?? "",
                lastMessages: room.lastMessages,
                lastSeen: otherUser.lastSeen ?? "",
                uid: otherUser.id,
                displayName: "${otherUser.firstName} ${otherUser.lastName}",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        room: room,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
        return Column(
          children: [
            _buildChatShimmering(),
            _buildChatShimmering(),
            _buildChatShimmering(),
            _buildChatShimmering(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DoctorModal doctorModal = Provider.of<DoctorProvider>(context).doctorModal;

    return Scaffold(
        appBar: _buildAppBar(doctorModal),
        body: Padding(
          padding: const EdgeInsets.only(
            left: kPadding,
          ),
          child: _buildBody(),
        ));
  }
}
