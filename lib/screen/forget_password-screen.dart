import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/constant.dart';
import '/provider/AuthProvider.dart';
import '/screen/check_email.dart';
import '/widgets/custom_input_field.dart';
import '/widgets/custome-appbar.dart';
import '/widgets/customeSnackbar.dart';
import '/widgets/custome_button.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/indicator/line_scale_indicator.dart';
import 'package:loading/loading.dart';
import 'package:provider/provider.dart';

class ForgetScreen extends StatefulWidget {
  static const String screenName = '/forget-screen';

  @override
  _ForgetScreenState createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: buildAppBar(context, "Recover account", 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kPadding, vertical: kPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Enter the email associated with your account and we\'ll send an email with instructions to reset your password.',
                style: TextStyle(fontSize: 16, letterSpacing: 1.5),
              ),
              SizedBox(height: kPadding * 1.5),
              CustomInputField(
                keybordType: TextInputType.emailAddress,
                labelText: 'Email',
                controller: _emailController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return '';
                  }
                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);

                  if (!emailValid) {
                    return 'Invalid email format';
                  }
                },
              ),
              SizedBox(
                height: kPadding,
              ),
              Container(
                height: kPadding * 2,
                alignment: Alignment.bottomRight,
                child: CustomeButton(
                  height: kPadding * 3,
                  onTap: _isSending
                      ? () {}
                      : () async {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _isSending = true;
                            });
                            try {
                              await authProvider.sendPasswordResetEmail(
                                  _emailController.text);
                              setState(() {
                                _isSending = true;
                              });

                              Navigator.pushReplacementNamed(
                                  context, CheckEmail.screenName);
                            } on FirebaseAuthException catch (e) {
                              print("ERROR > $e");
                              String code = '';
                              if (e.code == 'user-not-found') {
                                code = 'Invalid email address';
                              } else {
                                code = 'Something went wrong';
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  buildCloseableSnackBar(code, context));
                            } catch (e) {
                              print("ERROR > $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                  buildCloseableSnackBar(
                                      e.toString(), context));
                            }
                          }
                        },
                  backgourndColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Send Instructions',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: kPadding),
                      _isSending
                          ? Loading(
                              indicator: BallSpinFadeLoaderIndicator(),
                              size: 15,
                            )
                          : Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
