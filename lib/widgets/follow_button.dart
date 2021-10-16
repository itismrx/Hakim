import 'package:flutter/material.dart';
import '/constant.dart';
import '/modal/doctor-modal.dart';
import '/modal/notification_modal.dart';
import '/provider/AuthProvider.dart';
import '/provider/doctor-provider.dart';
import '/services/firestore_database.dart';
import 'package:provider/provider.dart';

class FollowButton extends StatefulWidget {
  final String userId;
  final Function onPressed;
  FollowButton({this.userId, this.onPressed});
  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isFollowing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _intializedFollwingStatus();
  }

  void _intializedFollwingStatus() async {
    FirestoreDatabase(uid: widget.userId)
        .isFollowing(widget.userId)
        .then((result) => setState(() {
              isFollowing = result;
            }));
  }

  Future<void> _follow(followedUserId, DoctorModal doctorModal) async {
    setState(() {
      isFollowing = true;
    });
    await FirestoreDatabase(uid: AuthProvider().getCurrentUser().uid)
        .follow(followedUserId);
    widget.onPressed();
//  Uuid uuid = Uuid

    FirestoreDatabase(uid: widget.userId)
        .addFeed(
          notificationModal: NotificationModal.fromMap(
            {
              'type': NotificationType.UserFollowing,
              'userName': doctorModal.userName,
              'uid': doctorModal.uid,
              'postId': null,
              'mediaUrl': null,
              'commentContent': null,
              'userProfileUrl': doctorModal.profilePictureUrl,
              'timestamp': DateTime.now(),
            },
          ),
          userId: widget.userId,
        )
        .whenComplete(() => Future.delayed(Duration(milliseconds: 10)));
  }

  Future<void> _unfollow(followedUserId) async {
    await FirestoreDatabase(uid: AuthProvider().getCurrentUser().uid)
        .unfollow(followedUserId)
        .whenComplete(() {
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() {
        setState(() {
          isFollowing = false;
        });
        widget.onPressed();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DoctorModal doctorModal = Provider.of<DoctorProvider>(context).doctorModal;
    return GestureDetector(
      onTap: () => isFollowing
          ? _unfollow(widget.userId)
          : _follow(widget.userId, doctorModal),
      child: Container(
          width: (kPadding * 5.5),
          height: 25,
          margin: const EdgeInsets.only(bottom: kPadding),
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isFollowing ? 'Unfollow' : 'Follow',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          )),
    );
  }
}
