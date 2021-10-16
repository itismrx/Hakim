import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/constant.dart';
import '/modal/case_modal.dart';
import '/modal/comment-modal.dart';
import '/modal/doctor-modal.dart';
import '/modal/notification_modal.dart';
import '/provider/AuthProvider.dart';
import '/provider/doctor-provider.dart';
import '/services/firestore_database.dart';
import '/widgets/comment-tile.dart';
import '/widgets/customeSnackbar.dart';
import '/widgets/post-card.dart';
import '/widgets/profile-picture.dart';
import '/widgets/shimmer_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

class PostDetailScreen extends StatefulWidget {
  final CaseModal caseModal;
  PostDetailScreen({this.caseModal});

  static const screenName = '/post-detail-screen';

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  TextEditingController _commentController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _commentController.dispose();
  }

  buildCommentSection() {
    return StreamBuilder(
      stream: FirestoreDatabase(uid: AuthProvider().getCurrentUser().uid)
          .featchComment(widget.caseModal.caseId),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            leading: ShimmerWidget.circular(
              width: kPadding * 2,
              height: kPadding * 2,
            ),
            title: Container(
              width: 100,
              child: ShimmerWidget.rectangular(
                height: 10,
                width: 75,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                ShimmerWidget.rectangular(
                  height: 10,
                  width: 155,
                ),
                SizedBox(
                  height: 5,
                ),
                ShimmerWidget.rectangular(
                  height: 10,
                  width: 100,
                ),
              ],
            ),
          );
        }

        if (snapshot.data.docs.isEmpty) {
          return Container(
              height: 150,
              child: Center(child: Text('Be the first one to comment')));
        }

        List<CommentModal> comments = [];
        snapshot.data.docs.forEach((doc) {
          CommentModal comment = CommentModal.fromDocument(doc);
          comments.add(comment);
        });
        comments.sort((a, b) {
          return b.timestamp.compareTo(a.timestamp);
        });

        return Container(
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, idx) {
              return CommentTile(
                comments[idx],
                widget.caseModal.ownerId == comments[idx].ownerId,
              );
            },
            itemCount: comments.length,
          ),
        );
      },
    );
  }

  addComment(DoctorModal doctorModal) {
    CommentModal comment = CommentModal(
        ownerId: doctorModal.uid,
        content: _commentController.text,
        caseId: widget.caseModal.caseId,
        commentId: Uuid().v4(),
        postOwnerId: widget.caseModal.ownerId,
        timestamp: DateTime.now());
    FirestoreDatabase(
      uid: AuthProvider().getCurrentUser().uid,
    ).addComment(comment, widget.caseModal.caseId).whenComplete(() async {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(buildCloseableSnackBar('Adding Comment', context));
      FirestoreDatabase(
        uid: AuthProvider().getCurrentUser().uid,
      ).addFeed(
          notificationModal: NotificationModal.fromMap(
            {
              'type': NotificationType.Comment,
              'commentData': comment.content,
              'userName': doctorModal.userName,
              'uid': widget.caseModal.ownerId,
              'userProfileUrl': doctorModal.profilePictureUrl,
              'postId': widget.caseModal.caseId,
              'mediaUrl': widget.caseModal.images.isNotEmpty
                  ? widget.caseModal.images.first
                  : null,
              'timestamp': DateTime.now(),
            },
          ),
          userId: widget.caseModal.ownerId);
      widget.caseModal.followers.forEach((key, value) {
        if (value == true) {
          // print('\n:KEey Value>>>>$key $value\n');
          FirestoreDatabase(
            uid: AuthProvider().getCurrentUser().uid,
          ).addFeed(
              notificationModal: NotificationModal.fromMap(
                {
                  'type': NotificationType.CaseFollowing,
                  'commentData': comment.content,
                  'userName': doctorModal.userName,
                  'uid': widget.caseModal.ownerId,
                  'userProfileUrl': doctorModal.profilePictureUrl,
                  'postId': widget.caseModal.caseId,
                  'mediaUrl': widget.caseModal.images.isNotEmpty
                      ? widget.caseModal.images.first
                      : null,
                  'timestamp': DateTime.now(),
                },
              ),
              userId: key);
        }
      });
    });

    _commentController.clear();
  }

  buildCommentTextBox(DoctorProvider doctorProvider) {
    DoctorModal doctorModal = doctorProvider.doctorModal;

    return Container(
      padding: const EdgeInsets.only(
        left: kPadding * .25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfilePicture(
            url: doctorModal.profilePictureUrl,
            fullName: doctorModal.fullName,
            radius: kPadding * .75,
            onTap: () {},
          ),
          Expanded(
            child: TextFormField(
              focusNode: _focusNode,
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'What is your opinion?.',
                contentPadding: const EdgeInsets.all(kPadding),
              ),
            ),
          ),
          IconButton(
            onPressed: () => addComment(doctorProvider.doctorModal),
            icon: Icon(
              Icons.send,
              color: Theme.of(context).accentColor,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height -
                175 -
                MediaQuery.of(context).viewInsets.top -
                MediaQuery.of(context).viewInsets.bottom,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: kPadding * .5,
                  right: kPadding * .5,
                ),
                child: Column(
                  children: [
                    PostCard(
                      caseModal: widget.caseModal,
                      isFullCase: true,
                    ),
                    SizedBox(
                      height: kPadding,
                    ),
                    buildCommentSection(),
                    SizedBox(
                      height: kPadding,
                    ),
                  ],
                ),
              ),
            ),
          ),
          buildCommentTextBox(doctorProvider),
        ],
      ),
    );
  }
}
