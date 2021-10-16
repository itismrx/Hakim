import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hakim_app/widgets/custome_button.dart';
import '../constant.dart';
import '/modal/comment-modal.dart';
import '/modal/doctor-modal.dart';
import '/provider/AuthProvider.dart';
import '/provider/doctor-provider.dart';
import '/screen/profile-screen.dart';
import '/services/firestore_database.dart';
import '/utility.dart';
import '/widgets/profile-picture.dart';
import '/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';

class CommentTile extends StatelessWidget {
  final CommentModal comment;
  TextEditingController _controller = TextEditingController();
  final bool byCreator;
  CommentTile(this.comment, this.byCreator);

  buildHeader() {
    return FutureBuilder(
      future: FirestoreDatabase(uid: AuthProvider().getCurrentUser().uid)
          .getADoctor(uid: comment.ownerId),
      builder: (context, AsyncSnapshot<DoctorModal> snapsot) {
        if (snapsot.hasError) {
          return Text('Something went wrong');
        }
        if (snapsot.connectionState == ConnectionState.done &&
            snapsot.hasData) {
          return ListTile(
            horizontalTitleGap: 0,
            leading: ProfilePicture(
              fullName: snapsot.data.fullName,
              url: snapsot.data.profilePictureUrl,
              radius: kPpOAppBar,
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProfileScreen(snapsot.data.uid);
              })),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${snapsot.data.fullName}',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '@${snapsot.data.userName}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.circle,
                        size: 5,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '${calculateTimeDifferenceBetween(comment.timestamp, DateTime.now())}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),

                ///
              ],
            ),
            trailing: AuthProvider().getCurrentUser().uid == comment.ownerId
                ? PopupMenuButton(
                    icon: Icon(
                      Icons.edit,
                      size: kPadding,
                    ),
                    enableFeedback: true,
                    onSelected: (value) {
                      if (value == 0) {
                        _controller.text = comment.content;
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        2 /
                                        5,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: kPadding),
                                    child: ListView(
                                      children: [
                                        TextField(
                                          controller: _controller,
                                        ),
                                        SizedBox(
                                          height: kPadding,
                                        ),
                                        CustomeButton(
                                          label: Text('Update'),
                                          width: kPadding * 7,
                                          height: kPadding * 3,
                                          backgourndColor:
                                              Theme.of(context).primaryColor,
                                          textColor: Colors.white,
                                          onTap: () {
                                            FirestoreDatabase(
                                                    uid: AuthProvider()
                                                        .getCurrentUser()
                                                        .uid)
                                                .addComment(
                                              CommentModal(
                                                caseId: comment.caseId,
                                                content: _controller.text,
                                                postOwnerId:
                                                    comment.postOwnerId,
                                                commentId: comment.commentId,
                                                timestamp: comment.timestamp,
                                                ownerId: comment.ownerId,
                                              ),
                                              comment.postOwnerId,
                                            );
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    )),
                              );
                            });
                      }
                      if (value == 1) {
                        FirestoreDatabase(
                                uid: AuthProvider().getCurrentUser().uid)
                            .deleteComment(comment);
                        // print('\n>>> \nCase Deleted\n');
                      }
                    },
                    itemBuilder: (ctx) {
                      return [
                        PopupMenuItem(
                          value: 0,
                          child: ListTile(
                            title: Text('Edit'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            title: Text('Delete'),
                          ),
                        ),
                      ];
                    },
                  )
                : null,
            subtitle: byCreator
                ? Row(
                    children: [
                      Icon(FontAwesomeIcons.user,
                          size: 10, color: Theme.of(context).accentColor),
                      SizedBox(
                        width: 3,
                      ),
                      Text('creator',
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                    ],
                  )
                : null,
          );
        }
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
      },
    );
  }

  buildContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35),
      child: Text(comment.content),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),
          SizedBox(
            height: 15,
          ),
          buildContent(),
          Divider(
            indent: 35,
          )
        ],
      ),
    );
  }
}
