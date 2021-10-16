import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/provider/AuthProvider.dart';
import '/screen/choose_role_screen.dart';
import 'settings.dart';
import '/screen/rhome.screen.dart';
import '/screen/signin_screen.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

class IntroScreen extends StatelessWidget {
  static const String screenName = '/intro-screen';
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthProvider>(context, listen: true);
    return SplashScreen(
      navigateAfterSeconds: _auth.status == Status.Authenticated
          ? RealHomeScreen.screenName
          : SignInScreen.screenName,
      seconds: 5,

      image: Image.asset('assets/images/hakim.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 100,
      onClick: () {},
      // loaderColor: Theme.of(context).accentColor,
    );
  }
}
