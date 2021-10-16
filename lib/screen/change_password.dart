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

class ChangePassword extends StatefulWidget {
  static const String screenName = '/change-passwrod';

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isLoading = false;
  bool _showPassword = true;
  bool _showConfirmPassword = true;
  bool _showCurrentPassword = true;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

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

  void _toggleShowCurrentPassword() {
    setState(() {
      _showCurrentPassword = !_showCurrentPassword;
    });
  }

  void _toggleConfrimShowPassword() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  void changePassword(String currentPassword, String newPassword) async {
    toggleLoading();
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user.email, password: currentPassword);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        //Success, do something
        toggleLoading();
        ScaffoldMessenger.of(context).showSnackBar(
            buildCloseableSnackBar("Password Sucessfuly Updated", context));
        Navigator.pop(context);
      }).catchError((error) {
        toggleLoading();
        //Error, show something
        ScaffoldMessenger.of(context).showSnackBar(
            buildCloseableSnackBar("Incorrect Password", context));
      });
    }).catchError((err) {
      toggleLoading();
      ScaffoldMessenger.of(context)
          .showSnackBar(buildCloseableSnackBar("Incorrect Password", context));
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
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
                SizedBox(
                  height: kPadding * 2,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _showCurrentPassword,
                  controller: _currentPasswordController,
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
                                onPressed: _toggleShowCurrentPassword,
                              )
                            : IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.eyeSlash,
                                  size: 20,
                                ),
                                onPressed: _toggleShowCurrentPassword,
                              )),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    hintText: 'Current password',
                    contentPadding: const EdgeInsets.all(kPadding),
                  ),
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
                    hintText: 'New Password',
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
                  margin: const EdgeInsets.only(bottom: kPadding),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (_passwordController.text.isNotEmpty &&
                              _confirmPasswordController.text.isNotEmpty) {
                            if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  buildCloseableSnackBar(
                                      "Password Mismatch", context));
                            } else {
                              changePassword(_currentPasswordController.text,
                                  _passwordController.text);
                            }
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
                                _isLoading ? 'Saving...' : 'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: kPadding,
                              ),
                              Container(
                                height: 15,
                                width: 15,
                                child: _isLoading
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
