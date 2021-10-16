import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:hakim_app/screen/SignUp/Doctor/updated-page-four.dart';
import 'package:hakim_app/screen/change_password.dart';
import '/provider/AuthProvider.dart';
import '/provider/doctor-provider.dart';
import '/screen/Post/post-screen.dart';
import '/screen/Post/post_detail_screen.dart';
import '/screen/SignUp/Doctor/page-four.dart';
import '/screen/SignUp/Doctor/page-one.dart';
import '/screen/SignUp/Doctor/page-three.dart';
import '/screen/SignUp/Doctor/page-two.dart';
import '/screen/chat/chat-page.dart';
import '/screen/chat/rooms-page.dart';
import '/screen/chat/users-page.dart';
import '/screen/check_email.dart';
import '/screen/choose_role_screen.dart';
import '/screen/forget_password-screen.dart';
import '/screen/home-page.dart';
import 'screen/settings.dart';
import '/screen/intro-screen.dart';
import '/screen/rhome.screen.dart';
import '/screen/home-page.dart';
import '/screen/post-create-screen.dart';
import '/screen/signup.dart';
import '/services/notification_services.dart';
import 'package:provider/provider.dart';

import './screen/signin_screen.dart';
import 'provider/DoctorProvider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import './screen/chat/chat-page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await NotificationService().init();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runZonedGuarded(() {
    runApp(MyApp());
  }, FirebaseCrashlytics.instance.recordError);

  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DoctorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Hakim',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // primarySwatch: Colors.blue,
          primaryColor: Color(0XFF6c63ff),
          accentColor: Colors.purple,
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => IntroScreen(),
          SignInScreen.screenName: (ctx) => SignInScreen(),
          SignUpScreen.screenName: (ctx) => SignUpScreen(),
          PageOne.screenName: (ctx) => PageOne(),
          PageTwo.screenName: (ctx) => PageTwo(),
          PageThree.screenName: (ctx) => PageThree(),
          // PageFour.screenName: (ctx) => PageFour(),
          LastPage.screenName: (ctx) => LastPage(),

          Settings.screenName: (ctx) => Settings(),
          ForgetScreen.screenName: (ctx) => ForgetScreen(),
          CheckEmail.screenName: (ctx) => CheckEmail(),
          ChangePassword.screenName: (ctx) => ChangePassword(),
          ChooseRoleScreen.screenName: (ctx) => ChooseRoleScreen(),
          HomePage.screenName: (ctx) => HomePage(),
          // ChatScreen.screenName: (ctx) => ChatScreen(),
          // MessageScreen.screenName: (ctx) => MessageScreen(),
          // ProfileScreen.screenName: (ctx) => ProfileScreen(),
          PostScreen.screenName: (ctx) => PostScreen(),
          ChatPage.screenName: (ctx) => ChatPage(),
          Rooms.screenName: (ctx) => Rooms(),
          RealHomeScreen.screenName: (ctx) => RealHomeScreen(),
          UsersPage.screenName: (ctx) => UsersPage(),
          WritePostScreen.screenName: (ctx) => WritePostScreen(),
        },
      ),
    );
  }
}
