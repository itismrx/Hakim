import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hakim_app/screen/SignUp/Doctor/updated-page-four.dart';
import 'package:hakim_app/screen/change_password.dart';
import 'package:hakim_app/screen/edit_profile.dart';
import 'package:hakim_app/screen/profile-screen.dart';
import 'package:photo_view/photo_view.dart';
import '../utility.dart';
import '/constant.dart';
import '/modal/doctor-modal.dart';
import '/provider/AuthProvider.dart';
import '/provider/doctor-provider.dart';
import '/screen/intro-screen.dart';
import '/screen/signin_screen.dart';
import '/widgets/profile-picture.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

class Settings extends StatefulWidget {
  static const screenName = '/settings';
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  User user = FirebaseAuth.instance.currentUser;
  verifyUser() async {
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      FirebaseAuth.instance.userChanges().listen((User newUser) {
        setState(() {
          user = newUser;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // verifyUser();
  }

  @override
  Widget build(BuildContext context) {
    // DoctorProvider doctorProvider =
    DoctorModal doctor = Provider.of<DoctorProvider>(context).doctorModal;
    double containerSize = kPpOnProfilePage * 2.2;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        // margin: const EdgeInsets.only(
        //   top: kPadding,
        // ),
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).viewInsets.bottom -
            MediaQuery.of(context).viewInsets.top,
        child: SingleChildScrollView(
          child: Column(
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
                                    MaterialPageRoute(builder: (context) {
                                  return Scaffold(
                                      backgroundColor:
                                          Colors.white.withOpacity(0.85),
                                      body: SafeArea(
                                        child: Stack(children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: PhotoView(
                                              imageProvider: NetworkImage(
                                                  doctor.profilePictureUrl),
                                            ),
                                          ),
                                          Positioned(
                                              left: 0,
                                              top: 0,
                                              child: IconButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                color: Colors.white,
                                                icon: Icon(Icons.arrow_back),
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
                height: kPadding * .5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Logged as '),
                  Text(
                    toTitle(doctor.fullName),
                    style: kNameTextStyle,
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
              ),
              SizedBox(
                height: kPadding * .5,
              ),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(FontAwesomeIcons.user),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Text('Account Settings'),
                  subtitle: Text('Personal information,email...'),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return EditProfile(doctor, () {});
                  })),
                ),
              ),
              SizedBox(
                height: kPadding * .5,
              ),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(FontAwesomeIcons.lock),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Text('Security'),
                  subtitle: Text('Change password...'),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onTap: () =>
                      Navigator.pushNamed(context, ChangePassword.screenName),
                ),
              ),
              SizedBox(
                height: kPadding * .5,
              ),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(FontAwesomeIcons.userShield),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Text('Requrest for Verifiction'),
                  subtitle: Text('send your institutional ID card...'),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return LastPage(
                      fromSignUp: false,
                    );
                  })),
                ),
              ),
              SizedBox(
                height: kPadding * .5,
              ),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(FontAwesomeIcons.language),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Text('Language'),
                  subtitle: Text('change language,English,...'),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              SizedBox(
                height: kPadding * .5,
              ),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(FontAwesomeIcons.heart),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Text('Apperance'),
                  subtitle: Text('Dard and Light mode,Font...'),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              SizedBox(
                height: kPadding * .5,
              ),
              Card(
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(FontAwesomeIcons.powerOff),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    title: Text('Log out'),
                    subtitle: Text('Personal information,email...'),
                    trailing: Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      AuthProvider().signOut().whenComplete(() =>
                          Navigator.pushReplacementNamed(
                              context, SignInScreen.screenName));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
