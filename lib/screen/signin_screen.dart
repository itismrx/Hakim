import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/modal/doctor-modal.dart';
import '/modal/user-modal.dart';
import '/provider/AuthProvider.dart';
import '/provider/doctor-provider.dart';
import '/screen/forget_password-screen.dart';
import '/screen/rhome.screen.dart';
import '/screen/signup.dart';
import '/widgets/customeSnackbar.dart';
import 'package:loading/indicator/line_scale_indicator.dart';
import 'package:loading/loading.dart';
import 'package:provider/provider.dart';

import '../widgets/social_media_icons_cars.dart';
import '../constant.dart';

class SignInScreen extends StatefulWidget {
  static const String screenName = '/sign-in';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;
  bool _showPassword = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();

  void _toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    DoctorProvider doctorProvider =
        Provider.of<DoctorProvider>(context, listen: true);
    DoctorModal doctorModal = doctorProvider.doctorModal;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kPadding,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: kPadding * 1.5),
                  child: Text(
                    'Let\'s sign you in.',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                        fontWeight: FontWeight.w900, color: Colors.black),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: kPadding - 10),
                  child: Text(
                    'Welcome back doc.',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ),
                Text(
                  'You\'ve been missed!',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                ),
                SizedBox(
                  height: kPadding * 1.5,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: _emailController,
                  onFieldSubmitted: (value) {
                    _form.currentState.validate();
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an email';
                    }
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);

                    if (!emailValid) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      hintText: 'Email',
                      contentPadding: const EdgeInsets.all(kPadding)),
                ),
                SizedBox(
                  height: kPadding,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _showPassword,
                  controller: _passwordController,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value.length < 6) {
                      return 'Password too short';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kPadding * 0.5),
                        child: _showPassword
                            ? IconButton(
                                icon: Icon(Icons.remove_red_eye_rounded),
                                onPressed: _toggleShowPassword,
                              )
                            : IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.eyeSlash,
                                  size: 20,
                                ),
                                onPressed: _toggleShowPassword,
                              )),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    hintText: 'Password',
                    contentPadding: const EdgeInsets.all(kPadding),
                  ),
                ),
                SizedBox(
                  height: kPadding * 0.5,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, ForgetScreen.screenName),
                    child: Text('Forget password?'),
                  ),
                ),

                SizedBox(
                  height: kPadding,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     SocialMeidaIconsCard(
                //       icon: FontAwesomeIcons.google,
                //       onPressed: () async {
                //         FocusScope.of(context).unfocus();
                //         try {
                //           UserModal user = await authProvider
                //               .signInWithGoogle()
                //               .whenComplete(() => doctorProvider.init());
                //           // add the user data to  pref

                //           Navigator.pushNamed(
                //               context, RealHomeScreen.screenName,
                //               arguments: {'uid': user.uid});
                //         } catch (e) {
                //           print(e);
                //           ScaffoldMessenger.of(context).showSnackBar(
                //               buildCloseableSnackBar(e.toString(), context));
                //         }
                //       },
                //     ),
                //     SocialMeidaIconsCard(
                //         icon: FontAwesomeIcons.facebook, onPressed: () {})
                //   ],
                // ),
                // SizedBox(height: kPadding),
                Container(
                  margin: const EdgeInsets.only(bottom: kPadding),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, SignUpScreen.screenName);
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                      GestureDetector(
                        onTap: authProvider.status == Status.Authenticating
                            ? () {}
                            : () async {
                                if (_form.currentState.validate()) {
                                  FocusScope.of(context).unfocus();

                                  try {
                                    bool status = await authProvider
                                        .signInWithEmailAndPassword(
                                            _emailController.text,
                                            _passwordController.text)
                                        .whenComplete(
                                            () => doctorProvider.init());
                                    if (status) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RealHomeScreen()));
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    print(e);
                                    if (e.code == 'user-not-found') {
                                      // code = 'Incorrect Email or Password';
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(buildCloseableSnackBar(
                                              'Incorrect Email or Password',
                                              context));
                                    }
                                    if (e.code.contains('user-not-found')) {
                                      // code = 'Incorrect Email or Password';
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(buildCloseableSnackBar(
                                              'Incorrect Email or Password',
                                              context));
                                    } else if (e.code == 'wrong-password') {
                                      // code = 'Incorrect Email or Password';
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(buildCloseableSnackBar(
                                              'Incorrect Email or Password',
                                              context));
                                    } else if (e.code ==
                                        'network-request-failed') {
                                      // code =
                                      // 'No connection, Please check your internet connection';
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(buildCloseableSnackBar(
                                              'No connection, Please check your internet connection',
                                              context));
                                    } else {
                                      // code = 'Something goes wrong ${e.message}';
                                      buildCloseableSnackBar(
                                          'Something goes wrong ${e.message}',
                                          context);
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        buildCloseableSnackBar(
                                            'Something goes wrong, please check your internet connection or retry again',
                                            context));
                                  }
                                }
                              },
                        child: Container(
                          height: kPadding * 2.75,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                authProvider.status == Status.Authenticating
                                    ? 'Signing in...'
                                    : 'Sign in',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: kPadding,
                              ),
                              Container(
                                height: 15,
                                width: 15,
                                child:
                                    authProvider.status == Status.Authenticating
                                        ? CircularProgressIndicator.adaptive(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          )
                                        // ? Loading(
                                        //     indicator: LineScaleIndicator(),
                                        //     size: 25,
                                        //   )
                                        : Container(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
