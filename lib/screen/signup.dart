import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/modal/user-modal.dart';
import '/provider/AuthProvider.dart';
import '/screen/choose_role_screen.dart';
import 'settings.dart';
import '/screen/signin_screen.dart';
import '/services/firestore_database.dart';
import '/widgets/customeSnackbar.dart';
import 'package:loading/indicator/line_scale_indicator.dart';
import 'package:loading/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/social_media_icons_cars.dart';
import '../constant.dart';
import 'SignUp/Doctor/page-one.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class SignUpScreen extends StatefulWidget {
  static const String screenName = '/signup';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  bool _showPassword = true;
  bool _showConfirmPassword = true;
  bool _isChecked = false;
  String _role;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final _form = GlobalKey<FormState>();
  // SharedPreferences pref = await _pref;
  @override
  void initState() {
    super.initState();

    setState(() {
      // _role = pref.getString('role');
    });
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleConfrimShowPassword() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
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
                  padding: const EdgeInsets.only(bottom: kPadding),
                  child: Text(
                    'Let\'s create you an account.',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                        fontWeight: FontWeight.w900, color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: kPadding * 0.25,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: _emailController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return '* Required field';
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
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return '* Required field';
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
                  height: kPadding,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _showConfirmPassword,
                  controller: _confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value.isEmpty) {
                      return '* Required field';
                    }
                    if (value.length < 6) {
                      return 'Password too short';
                    }
                    if (value != _passwordController.value.text) {
                      return 'Password doesn\'t match';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kPadding * 0.5),
                        child: _showConfirmPassword
                            ? IconButton(
                                icon: Icon(Icons.remove_red_eye_rounded),
                                onPressed: _toggleConfrimShowPassword,
                              )
                            : IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.eyeSlash,
                                  size: 20,
                                ),
                                onPressed: _toggleConfrimShowPassword,
                              )),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    hintText: 'Confirm Password',
                    contentPadding: const EdgeInsets.all(kPadding),
                  ),
                ),
                SizedBox(
                  height: kPadding * 0.5,
                ),
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Or',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    )),
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
                //         if (_form.currentState.validate()) {
                //           if (!_isChecked) {
                //             ScaffoldMessenger.of(context).showSnackBar(
                //                 buildCloseableSnackBar(
                //                     'Can not procced unless you agree to the terms and conditions',
                //                     context));
                //             return;
                //           }
                //         }
                //         try {
                //           UserModal user =
                //               await authProvider.signInWithGoogle();
                //           await FirestoreDatabase(uid: user.uid).setUser(user);
                //           await FirebaseChatCore.instance.createUserInFirestore(
                //             types.User(
                //               firstName: user.displayName.split(' ').first,
                //               id: user.uid,
                //               role: _role == 'DOCTOR'
                //                   ? types.Role.doctor
                //                   : types.Role.patient,
                //               imageUrl: user.photoURL.isEmpty
                //                   ? 'https://i.pravatar.cc/300?u=${user.email}' // TODO : Remove this line
                //                   : user.photoURL,
                //               lastName: user.displayName.split(' ').last,
                //               createdAt: DateTime.now().millisecondsSinceEpoch,
                //             ),
                //           );
                //           Navigator.pushNamed(context, PageOne.screenName,
                //               arguments: {'uid': user.uid});
                //         } catch (e) {
                //           ScaffoldMessenger.of(context).showSnackBar(
                //               buildCloseableSnackBar(e.toString(), context));
                //         }
                //       },
                //     ),
                //     SocialMeidaIconsCard(
                //         icon: FontAwesomeIcons.facebook,
                //         onPressed: () {
                //           print('facebook');
                //         })
                //   ],
                // ),
                // SizedBox(
                //   height: kPadding * 0.5,
                // ),
                Container(
                  margin: const EdgeInsets.only(bottom: kPadding),
                  child: Column(
                    children: [
                      CheckboxListTile(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        title: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'I agree to the',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  //TODO: Add Terms and Conditions
                                },
                              text: ' Terms and Conditions\n',
                              style: kLinkTextStyle,
                            ),
                            TextSpan(
                                text: ' and ',
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  //TODO: Add Privacy Policy
                                },
                              text: 'Privacy Policy',
                              style: kLinkTextStyle,
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: kPadding * 0.15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, SignInScreen.screenName);
                              },
                              child: Text(
                                'Sign in',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: kPadding * 0.5,
                      ),
                      GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          if (_form.currentState.validate()) {
                            if (!_isChecked) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  buildSnackBar(
                                      'Can not procced unless you agree to the terms and conditions.',
                                      context));
                              return;
                            }
                            try {
                              UserModal user = await authProvider
                                  .registerWithEmailAndPassword(
                                      _emailController.text,
                                      _passwordController.text);
                              await FirestoreDatabase(uid: user.uid)
                                  .setUser(user);

                              Navigator.pushNamed(context, PageOne.screenName,
                                  arguments: {'uid': user.uid});
                            } on FirebaseAuthException catch (e) {
                              String code = '';
                              if (e.code == 'weak-password') {
                                code = "Weak Password";
                              } else if (e.code == 'email-already-in-use') {
                                code = "Email already in use";
                              } else {
                                code = "Something goes wrong";
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  buildCloseableSnackBar(code, context));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  buildCloseableSnackBar(
                                      e.toString(), context));
                            }

                            // add the user to /users

                          }
                        },
                        child: Container(
                          height: kPadding * 2.75,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  end: Alignment.topLeft,
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).accentColor
                                  ]),
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: kPadding,
                              ),
                              Container(
                                height: 15,
                                width: 15,
                                child: authProvider.status == Status.Registering
                                    // ? CircularProgressIndicator(
                                    //     backgroundColor: Colors.white,
                                    //   )
                                    ? Loading(
                                        indicator: LineScaleIndicator(),
                                        size: 25,
                                      )
                                    : Container(),
                              )
                            ],
                          ),
                        ),
                      )
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
