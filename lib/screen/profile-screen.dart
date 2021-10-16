import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/constant.dart';
import '/modal/doctor-modal.dart';
import '/provider/AuthProvider.dart';
import '/provider/doctor-provider.dart';
import '/screen/edit_profile.dart';
import '/services/firestore_database.dart';
import '/utility.dart';
import '/widgets/image-upload.dart';
import '/widgets/post-card.dart';
import '/widgets/profile-picture.dart';
import '/widgets/report-dialog.dart';
import '/widgets/shimmer_widget.dart';
import '/widgets/status-card.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'chat/chat-page.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  ProfileScreen(this.userId);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DoctorModal _doctorModal;
  void _goToChat(types.User otherUser, BuildContext context) async {
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

  _buildBodyHeader() {
    return FutureBuilder(
        future: FirestoreDatabase(uid: widget.userId)
            .getADoctor(uid: widget.userId),
        builder: (context, AsyncSnapshot<DoctorModal> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              '${snapshot.error.toString()}',
              style: TextStyle(color: Theme.of(context).errorColor),
            ));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            _doctorModal = snapshot.data;
            DoctorModal doctor = snapshot.data;
            double containerSize = kPpOnProfilePage * 2.2;
            return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPadding,
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: containerSize,
                                width: containerSize,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: containerSize,
                                      width: containerSize,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Theme.of(context).accentColor,
                                                Theme.of(context).primaryColor
                                              ])),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: ProfilePicture(
                                        url: doctor.profilePictureUrl,
                                        fullName: doctor.fullName,
                                        radius: kPpOnProfilePage,
                                        onTap: doctor.profilePictureUrl == null
                                            ? () {}
                                            : () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return Scaffold(
                                                      backgroundColor: Colors
                                                          .white
                                                          .withOpacity(0.85),
                                                      body: SafeArea(
                                                        child: Stack(children: [
                                                          Container(
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: PhotoView(
                                                              imageProvider:
                                                                  NetworkImage(
                                                                      doctor
                                                                          .profilePictureUrl),
                                                            ),
                                                          ),
                                                          Positioned(
                                                              left: 0,
                                                              top: 0,
                                                              child: IconButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                color: Colors
                                                                    .white,
                                                                icon: Icon(Icons
                                                                    .arrow_back),
                                                              ))
                                                        ]),
                                                      ));
                                                }));
                                              },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: kPadding * .75,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    toTitle(doctor.fullName),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                            // color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: kPadding * 0.25,
                                  ),
                                  doctor.isVerified
                                      ? Icon(
                                          Icons.verified,
                                          size: kPadding,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : Container(
                                          width: kPadding,
                                        ),
                                ],
                              ),
                              SizedBox(
                                height: kPadding * 0.5,
                              ),
                              Text(
                                '@${doctor.userName}',
                                style: TextStyle(
                                    // color: Colors.white,
                                    ),
                              ),
                              SizedBox(
                                height: kPadding * 0.5,
                              ),
                              Text(
                                doctor.speciality,
                              ),
                              SizedBox(
                                height: kPadding * .5,
                              ),
                              if (doctor.bio != null)
                                Text(
                                  doctor.bio,
                                ),
                              SizedBox(
                                height: kPadding * .5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.pin_drop,
                                      color: Theme.of(context).primaryColor),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("${doctor.country}, ${doctor.city}")
                                ],
                              ),
                              SizedBox(
                                height: kPadding * .5,
                              ),
                            ],
                          ),
                        ),
                        AuthProvider().getCurrentUser().uid != widget.userId
                            ? Positioned(
                                top: 30,
                                left: 35,
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.facebookMessenger,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () async {
                                    final otherUser =
                                        await fetchUser(widget.userId, 'users');
                                    _goToChat(toUser(otherUser, widget.userId),
                                        context);
                                  },
                                ),
                              )
                            : Container(),
                        AuthProvider().getCurrentUser().uid != widget.userId
                            ? Positioned(
                                top: 30,
                                right: 35,
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.phoneAlt,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => UrlLauncher.launch(
                                      'tel:${doctor.phoneNumber}'),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ));
          }
          double containerSize = kPpOnProfilePage * 2.2;
          return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kPadding,
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: containerSize,
                              width: containerSize,
                              child: Stack(
                                children: [
                                  Container(
                                    height: containerSize,
                                    width: containerSize,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Theme.of(context).accentColor,
                                              Theme.of(context).primaryColor
                                            ])),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: ShimmerWidget.circular(
                                      width: containerSize,
                                      height: containerSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: kPadding,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShimmerWidget.rectangular(
                                  height: kPadding,
                                  width: 175,
                                ),
                                SizedBox(
                                  width: kPadding * 0.25,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: kPadding * 0.5,
                            ),
                            ShimmerWidget.rectangular(
                              height: kPadding,
                              width: 100,
                            ),
                            SizedBox(
                              height: kPadding * 0.5,
                            ),
                            ShimmerWidget.rectangular(
                              height: kPadding,
                              width: kPadding * .75,
                            ),
                            SizedBox(
                              height: kPadding,
                            ),
                          ],
                        ),
                      ),
                      AuthProvider().getCurrentUser().uid != widget.userId
                          ? Positioned(
                              top: 30,
                              left: 35,
                              child: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.facebookMessenger,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () async {
                                  final otherUser =
                                      await fetchUser(widget.userId, 'users');
                                  _goToChat(toUser(otherUser, widget.userId),
                                      context);
                                },
                              ),
                            )
                          : Container(),
                      AuthProvider().getCurrentUser().uid != widget.userId
                          ? Positioned(
                              top: 30,
                              right: 35,
                              child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.phoneAlt,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {}),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ));
        });
  }

  _reload() {
    setState(() {});
  }

  _buildAppBar(context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      // title: Text(toTitle(usersName), style: TextStyle(color: Colors.black)),
      actions: [
        widget.userId == AuthProvider().getCurrentUser().uid
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding),
                child: Container(
                  alignment: Alignment.center,
                  height: kPadding + 9,
                  width: kPadding + 9,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColorLight),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EditProfile(_doctorModal, _reload);
                      }));
                    }, //TODO Navigate to the edit profile page
                    icon: Icon(
                      Icons.edit,
                      size: kPadding - 5,
                      color: Colors.black54,
                    ),
                  ),
                ),
              )
            : Container()
        // : Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: kPadding),
        //     child: IconButton(
        //       onPressed: () {
        //         buildReportSheet(context);
        //       },
        //       icon: Icon(
        //         Icons.report,
        //         size: kPadding + 9,
        //         color: Theme.of(context).primaryColorLight,
        //       ),
        //     ),
        //   )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          child: Column(
            children: [
              _buildBodyHeader(),
              StatusWidget(widget.userId),
              StreamBuilder(
                stream: FirestoreDatabase(uid: widget.userId)
                    .casesStream(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0) {
                      return Container(
                        margin: const EdgeInsets.only(top: kPadding * 5),
                        child: Text('This user has not posted any case yet'),
                      );
                    }
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, idx) {
                        return PostCard(
                          caseModal: snapshot.data[idx],
                        );
                      },
                    );
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
