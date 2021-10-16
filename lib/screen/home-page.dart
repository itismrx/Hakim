import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hakim_app/screen/chat/users-page.dart';
import 'package:hakim_app/widgets/customeSnackbar.dart';
import 'package:hakim_app/widgets/follow_button.dart';
import '../utility.dart';
import '/constant.dart';
import '/modal/case_modal.dart';
import '/modal/doctor-modal.dart';
import '/provider/AuthProvider.dart';
import '/provider/doctor-provider.dart';
import '/screen/profile-screen.dart';
import '/screen/search_screen.dart';
import '/screen/shimmer-case-widget.dart';
import '/services/firestore_database.dart';
import '/widgets/post-card.dart';
import '/widgets/profile-picture.dart';
import '/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String screenName = '/home-page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  // _buildHomeAppBart(DoctorModal doctorModal) {
  //   return ;
  // }

  StreamBuilder buildUsersToFollow(DoctorModal doctorModal) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('doctors')
            .orderBy('joinedDate', descending: true)
            .limit(30)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DoctorModal> _doctors = [];

            snapshot.data.docs.forEach((doc) {
              if (AuthProvider().getCurrentUser().uid != doc.data()['uid'])
                _doctors.add(DoctorModal.fromDocument(doc.data()));
            });

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: _doctors.length,
                      itemBuilder: (context, idx) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ProfileScreen(_doctors[idx].uid);
                            }));
                          },
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: Container(
                              margin: const EdgeInsets.all(kPadding * .25),
                              padding:
                                  const EdgeInsets.only(top: kPadding * .75),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  // color: Theme.of(context).primaryColor,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      spreadRadius: 2,
                                      color: Colors.black26,
                                      offset: Offset(
                                        2,
                                        2,
                                      ),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  ProfilePicture(
                                    url: _doctors[idx].profilePictureUrl,
                                    fullName: _doctors[idx].fullName,
                                    radius: kPadding,
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          toTitle(_doctors[idx].fullName),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(
                                          width: kPadding * 0.2,
                                        ),
                                        if (_doctors[idx].isVerified)
                                          Icon(
                                            Icons.verified,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: kPadding * .5,
                                          ),
                                      ]),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(_doctors[idx].speciality),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  FollowButton(
                                      onPressed: () => setState(() {}),
                                      userId: _doctors[idx].uid),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: kPadding,
                  ),
                  SizedBox(
                    height: 700,
                    child: ListView.builder(
                      itemCount: _doctors.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, idx) {
                        return FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('cases')
                                .doc(_doctors[idx].uid)
                                .collection('cases')
                                .where(
                                  'tag',
                                  isEqualTo: doctorModal.speciality,
                                )
                                .limit(2)
                                .get(),
                            builder: (context,
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              if (snapshot.data != null) {
                                if (snapshot.data.docs.isNotEmpty) {
                                  CaseModal caseModal = CaseModal.fromDocument(
                                      snapshot.data.docs.first.data());

                                  return PostCard(
                                    caseModal: caseModal,
                                  );
                                }
                              }
                              return Container(
                                  // color: Colors.red,
                                  );
                            });
                        //PostCard(caseModal: _cases[idx]);
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ShimmerCaseWidget();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DoctorModal doctorModal = Provider.of<DoctorProvider>(context).doctorModal;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: doctorModal.fullName == null
              ? ShimmerWidget.circular(
                  width: kPpOnPost * 2, height: kPpOAppBar * 2)
              : ProfilePicture(
                  fullName: doctorModal.fullName,
                  url: doctorModal.profilePictureUrl,
                  radius: kPpOAppBar,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(AuthProvider().getCurrentUser().uid),
                    ),
                  ),
                ),
        ),
        title: Text(
          "Hakim",
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
                  Navigator.pushNamed(context, UsersPage.screenName);
                }),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(
          top: kPadding * 0.5,
          // left: kPadding,
        ),
        child: StreamBuilder(
          stream: FirestoreDatabase(uid: AuthProvider().getCurrentUser().uid)
              .casesFeedStream(AuthProvider().getCurrentUser().uid),
          builder: (context, AsyncSnapshot<List<CaseModal>> snapshot) {
            if (snapshot.hasData && snapshot.data.isEmpty) {
              return SingleChildScrollView(
                child: buildUsersToFollow(doctorModal),
              );
            }
            if (snapshot.hasData) {
              List<CaseModal> _listOfCaseModal = snapshot.data;
              _listOfCaseModal.sort((a, b) {
                return b.postedTime.compareTo(a.postedTime);
              });
              return RefreshIndicator(
                  onRefresh: _onRefresh,
                  backgroundColor: Colors.white.withOpacity(.85),
                  color: Colors.blue,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: kPadding * 0.5,
                      // left: kPadding,
                    ),
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _listOfCaseModal.length,
                        itemBuilder: (context, idx) {
                          return PostCard(
                            caseModal: _listOfCaseModal[idx],
                          );
                        },
                      ),
                    ),
                  ));
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return ShimmerCaseWidget();
          },
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {});
    return;
  }
}
