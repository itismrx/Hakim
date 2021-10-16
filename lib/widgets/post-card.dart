import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hakim_app/widgets/profile-picture.dart';
import '/modal/case_modal.dart';
import '/modal/doctor-modal.dart';
import '/provider/AuthProvider.dart';
import '/screen/Post/edit_post_screen.dart';
import '/screen/Post/post_detail_screen.dart';
import '/screen/profile-screen.dart';
import '/services/firestore_database.dart';
import '/utility.dart';
import '/widgets/report-dialog.dart';
import '/widgets/shimmer_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_number/sliding_number.dart';

import '../constant.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key key, this.caseModal, this.isFullCase = false})
      : super(key: key);

  final CaseModal caseModal;
  final bool isFullCase;

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  // DoctorModal doctor;
  bool isFollowing = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if (widget.caseModal.followers
          .containsKey(FirebaseAuth.instance.currentUser.uid))
        isFollowing =
            widget.caseModal.followers[FirebaseAuth.instance.currentUser.uid];
    });
    // fetchDoctor();
  }

  FutureBuilder<DoctorModal> buildPostHeader() {
    return FutureBuilder(
        future: FirestoreDatabase(uid: FirebaseAuth.instance.currentUser.uid)
            .getADoctor(uid: widget.caseModal.ownerId),
        builder: (context, AsyncSnapshot<DoctorModal> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        widget.caseModal.ownerId))),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: ProfilePicture(
                                url: snapshot.data.profilePictureUrl,
                                fullName: snapshot.data.fullName,
                                radius: kPpOnPost * .75,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: kPadding * 0.2,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      toTitle(snapshot.data.fullName),
                                      style: kNameTextStyle,
                                    ),
                                    SizedBox(
                                      width: kPadding * 0.2,
                                    ),
                                    if (snapshot.data.isVerified)
                                      Icon(
                                        Icons.verified,
                                        color: Theme.of(context).primaryColor,
                                        size: kPadding,
                                      ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.circle,
                                      size: 2,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      calculateTimeDifferenceBetween(
                                        widget.caseModal.postedTime,
                                        DateTime.now(),
                                      ),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: kPadding * 0.25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  // child: Text('General Doctor'),
                                  child: Text(snapshot.data.speciality),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (AuthProvider().getCurrentUser().uid ==
                          widget.caseModal.ownerId)
                        PopupMenuButton(
                          icon: Icon(
                            Icons.edit,
                            size: kPadding,
                          ),
                          enableFeedback: true,
                          onSelected: (value) {
                            if (value == 0) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EditPostScreen(
                                  caseModal: widget.caseModal,
                                );
                              }));
                            }
                            if (value == 1) {
                              FirestoreDatabase(
                                      uid: AuthProvider().getCurrentUser().uid)
                                  .deleteCase(widget.caseModal);
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
                        ),
                      if (AuthProvider().getCurrentUser().uid !=
                          widget.caseModal.ownerId)
                        IconButton(
                          icon: Icon(
                            Icons.report,
                            color: Colors.black,
                          ),
                          onPressed: () =>
                              buildReportSheet(context, widget.caseModal),
                        )
                    ],
                  ),
                ],
              ),
            );
          }

          return ShimmerPostHeader();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPostHeader(),
          if (widget.caseModal.images.isEmpty)
            Chip(
              label: Text(widget.caseModal.tag),
              labelStyle: TextStyle(fontSize: 10),
            ),
          SelectableText(
            widget.caseModal.caseTitle,
            style: kTitleTextStyle,
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PostDetailScreen(caseModal: widget.caseModal);
                  },
                ),
              );
            },
            child: Container(
              child: Text(
                !widget.isFullCase
                    ? widget.caseModal.caseDescription.length > 120
                        ? widget.caseModal.caseDescription.substring(0, 120) +
                            ' ...'
                        : widget.caseModal.caseDescription
                    : widget.caseModal.caseDescription,
                style: kPostTextStyle,
              ),
            ),
          ),
          SizedBox(height: kPadding),
          if (widget.caseModal.images.isNotEmpty)
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SafeArea(
                    child: Scaffold(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      body: Container(
                        color: Colors.transparent,
                        child: Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white.withOpacity(.85),
                              child: PhotoViewGallery.builder(
                                scrollPhysics: const BouncingScrollPhysics(),
                                builder: (BuildContext context, int index) {
                                  return PhotoViewGalleryPageOptions(
                                    imageProvider: CachedNetworkImageProvider(
                                        widget.caseModal.images[index]),
                                    initialScale:
                                        PhotoViewComputedScale.contained * 0.8,
                                    heroAttributes: PhotoViewHeroAttributes(
                                        tag: widget.caseModal.caseTitle),
                                  );
                                },
                                itemCount: widget.caseModal.images.length,
                                loadingBuilder: (context, event) => Center(
                                  child: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      value: event == null
                                          ? 0
                                          : event.cumulativeBytesLoaded /
                                              event.expectedTotalBytes,
                                    ),
                                  ),
                                ),
                                backgroundDecoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.85)),
                                pageController: PageController(),
                                onPageChanged: (value) {},
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * 3 / 4,
                              left: 0,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 1 / 4,
                                width: 300,
                                child: ListView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kPadding),
                                      child: Text(
                                        widget.caseModal.caseTitle,
                                      ),
                                    ),
                                    SizedBox(
                                      height: kPadding,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kPadding),
                                      // width: MediaQuery.of(context).size.width *
                                      //     0.75,
                                      child: Text(
                                        widget.caseModal.caseDescription,
                                        softWrap: true,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }));
              },
              child: Stack(children: [
                Container(
                  alignment: Alignment.center,
                  height: 300,
                  // width: 400,

                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      imageUrl: widget.caseModal.images.first,
                      placeholderFadeInDuration: Duration(milliseconds: 100),
                      placeholder: (context, str) {
                        return ShimmerWidget.rectangular(height: 300);
                      }),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Chip(
                    label: Text(widget.caseModal.tag),
                    backgroundColor: Colors.black54,
                    labelStyle: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
                if (widget.caseModal.images.length > 1)
                  Positioned(
                    right: 5,
                    top: 15,
                    child: Container(
                      alignment: Alignment.center,
                      height: kPadding * 1.25,
                      width: kPadding * 1.25,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black54),
                      child: Icon(Icons.copy,
                          size: kPadding * .75, color: Colors.white),
                    ),
                  )
              ]),
            ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
                Container(
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.bolt,
                            color: isFollowing
                                ? Theme.of(context).accentColor
                                : Colors.grey,
                            // color: Theme.of(context).accentColor,
                          ),
                          onPressed: widget.caseModal.ownerId ==
                                  AuthProvider().getCurrentUser().uid
                              ? () {}
                              : () {
                                  if (isFollowing) {
                                    setState(() {
                                      isFollowing = false;
                                    });
                                    FirestoreDatabase(
                                            uid: AuthProvider()
                                                .getCurrentUser()
                                                .uid)
                                        .unFollowCase(widget.caseModal);
                                  } else {
                                    setState(() {
                                      isFollowing = true;
                                    });
                                    FirestoreDatabase(
                                            uid: AuthProvider()
                                                .getCurrentUser()
                                                .uid)
                                        .followCase(widget.caseModal);
                                  }
                                }),
                      SlidingNumber(
                        number: widget.caseModal.followers.values
                            .where((element) => element == true)
                            .toList()
                            .length,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOutQuint,
                      ),
                    ],
                  ),
                ),

                Container(
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.comment,
                          color: Colors.grey,
                          // color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PostDetailScreen(
                                    caseModal: widget.caseModal);
                              },
                            ),
                          );
                        },
                      ),
                      FutureBuilder(
                          future: FirestoreDatabase(
                                  uid: FirebaseAuth.instance.currentUser.uid)
                              .numberOfComments(widget.caseModal.caseId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              return SlidingNumber(
                                number: snapshot.data,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeOutQuint,
                              );
                            }
                            return Text(
                              '0',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            );
                          })
                    ],
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.grey,
                      // color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {
                      final box = context.findRenderObject() as RenderBox;
                      await Share.share(
                          widget.caseModal.images.isNotEmpty
                              ? '${widget.caseModal.caseTitle}\n\n ${widget.caseModal.caseDescription}\n ${widget.caseModal.images.first}'
                              : '${widget.caseModal.caseTitle}\n\n ${widget.caseModal.caseDescription}',
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    }),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

class ShimmerPostHeader extends StatelessWidget {
  const ShimmerPostHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ShimmerWidget.circular(
                    width: kPadding * 3,
                    height: kPadding * 3,
                  ),
                  SizedBox(
                    width: kPadding * 0.25,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ShimmerWidget.rectangular(
                              height: kPadding,
                              width: 175,
                            ),
                            SizedBox(
                              width: kPadding * 0.25,
                            ),
                            // if (doctor.isVerified)
                          ],
                        ),
                        SizedBox(
                          height: kPadding * 0.25,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ShimmerWidget.rectangular(
                            height: kPadding,
                            width: 100,
                          ),
                          // child: Text(doctor.speciality),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
