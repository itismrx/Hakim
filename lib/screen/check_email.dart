import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '/constant.dart';
import '/screen/forget_password-screen.dart';
import '/screen/signin_screen.dart';
import '/widgets/custome-appbar.dart';
import '/widgets/custome_button.dart';
import 'package:open_mail_app/open_mail_app.dart';

class CheckEmail extends StatelessWidget {
  static const String screenName = '/check-email';

  showMailAppDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Open Mail App'),
            content: Text('No mail app installed'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(context, '', 0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            // width: size.width * 1 / 3,
            height: size.width * 1 / 3,
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage('assets/images/email.png')),
            ),
          ),
          SizedBox(
            height: kPadding,
          ),
          Text(
            'Check your mail',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: kPadding),
          Text(
            'We have sent a password recover',
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPadding),
            child: Text(
              'insturctions to your email.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            height: kPadding * 2,
          ),
          CustomeButton(
            // backgourndColor: Theme.of(context).primaryColor,
            backgourndColor: Color(0XFF6c63ff),
            label: Text(
              'Open email app',
              style: TextStyle(color: Colors.white),
            ),
            height: kPadding * 2,
            width: size.width * 1 / 3,
            onTap: () async {
              var result = await OpenMailApp.openMailApp();
              if (!result.didOpen && !result.canOpen) {
                showMailAppDialog(context);
              } else if (!result.didOpen && result.canOpen) {
                showDialog(
                    context: context,
                    builder: (_) {
                      return MailAppPickerDialog(mailApps: result.options);
                    });
              } else if (result.didOpen) {
                Navigator.pushReplacementNamed(
                    context, SignInScreen.screenName);
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: kPadding * 4,
            child: Column(
              children: [
                Text(
                  'Did not receive the email? Check your spam filter,\n',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  softWrap: true,
                ),
                RichText(
                  softWrap: true,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'or ', style: TextStyle(color: Colors.black)),
                    TextSpan(
                        text: 'try another email address',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(
                                context, ForgetScreen.screenName);
                          })
                  ]),
                ),
              ],
            ),
          )),
    );
  }
}
