import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hakim_app/modal/case_modal.dart';
import '/modal/notification_modal.dart';
import '/provider/AuthProvider.dart';
import '/screen/Post/post_detail_screen.dart';
import '/screen/profile-screen.dart';
import '/services/firestore_database.dart';
import '/utility.dart';
import '/widgets/profile-picture.dart';

import '../constant.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  notificationLabel(NotificationType type, String userName) {
    switch (type) {
      case NotificationType.CaseFollowing:
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'The case you followed get a new comment',
                  style: TextStyle(color: Colors.black)),
            ],
          ),
        );
      case NotificationType.UserFollowing:
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "@$userName",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: ' started following you',
                  style: TextStyle(color: Colors.black)),
            ],
          ),
        );
      case NotificationType.Comment:
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "@$userName",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: ' commented on your case',
                  style: TextStyle(color: Colors.black)),
            ],
          ),
        );
    }
  }

  Widget _buildIcon(NotificationType type, userName, pp) {
    switch (type) {
      case NotificationType.Comment:
        return Icon(
          FontAwesomeIcons.comment,
          size: 15,
        );
      case NotificationType.UserFollowing:
        return ProfilePicture(
            fullName: userName, url: pp, radius: kPadding, onTap: () {});
      case NotificationType.CaseFollowing:
        return Icon(
          FontAwesomeIcons.bolt,
          size: 15,
        );
    }
  }

  _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: StreamBuilder(
          // stream: FirestoreDatabase(uid: AuthProvider().getCurrentUser().uid)
          //     .notificationStream(AuthProvider().getCurrentUser().uid),
          stream: FirebaseFirestore.instance
              .collection('feeds')
              .doc(AuthProvider().getCurrentUser().uid)
              .collection('feedItems')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              // snapshot.
              return Center(
                child: Text('Something goes wrong ${snapshot.error}'),
              );
            }
            if (snapshot.hasData) {
              List<NotificationModal> _notifications = [];
              snapshot.data.docs.forEach((doc) {
                _notifications.add(NotificationModal.fromDocument(doc));
              });
              if (_notifications.isEmpty) {
                return Center(
                  child: Text("No Notification"),
                );
              }
              return ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, idx) {
                  NotificationModal notification = _notifications[idx];
                  return Dismissible(
                    key: ValueKey(DateTime.now().toIso8601String()),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                      child: Padding(
                        padding: const EdgeInsets.only(right: kPadding),
                        child: Icon(
                          Icons.delete,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Theme.of(context).accentColor.withOpacity(0.4),
                    ),
                    onDismissed: (dir) {
                      FirestoreDatabase(
                              uid: AuthProvider().getCurrentUser().uid)
                          .removeFeed(AuthProvider().getCurrentUser().uid,
                              snapshot.data.docs[idx].id);
                    },
                    confirmDismiss: (direction) async {
                      bool isConfirmed = false;
                      await showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Row(
                                children: [
                                  Text('Delete Notification'),
                                ],
                              ),
                              content: Text(
                                  'Are you sure you want to delete this notification it is not recovarable?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      isConfirmed = false;
                                      Navigator.pop(ctx);
                                    },
                                    child: Text(
                                      'CANCEL',
                                      style: TextStyle(color: Colors.blue),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      isConfirmed = true;
                                      Navigator.pop(ctx);
                                    },
                                    child: Text(
                                      'DELETE NOTIFICATION',
                                      style: TextStyle(color: Colors.red),
                                    ))
                              ],
                            );
                          });
                      return isConfirmed;
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 20,
                          child: _buildIcon(
                              notification.type,
                              notification.userName,
                              notification.userProfileUrl)),
                      title: notificationLabel(
                          notification.type, notification.userName),
                      subtitle: notification.commentData != null
                          ? Text(notification.commentData.length > 120
                              ? notification.commentData.substring(0, 120) +
                                  '...'
                              : notification.commentData)
                          : null,
                      trailing: Text(calculateTimeDifferenceBetween(
                          notification.timestamp, DateTime.now())),
                      onTap: () {
                        if (notification.type ==
                            NotificationType.UserFollowing) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ProfileScreen(notification.uid);
                          }));
                        } else {
                          // FirestoreDatabase(
                          //         uid: AuthProvider().getCurrentUser().uid)
                          //     .getACase(
                          //         ownerId: notification.uid,
                          //         caseId: notification.postId)
                          FirebaseFirestore.instance
                              .collection('cases')
                              .doc(notification.uid)
                              .collection('cases')
                              .doc(notification.postId)
                              .get()
                              .then((value) {
                            if (value.exists) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return PostDetailScreen(
                                      caseModal: CaseModal.fromDocument(
                                        value.data(),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } // print(value.exists);
                          });
                        }
                      },
                    ),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notification',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        child: _buildBody(),
      ),
    );
  }
}
