import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/constant.dart';
import '/provider/DoctorProvider.dart';
import '/provider/doctor-provider.dart';
import '/screen/SignUp/Doctor/page-three.dart';
import '../../settings.dart';
import '/screen/rhome.screen.dart';
import '/services/firestore_database.dart';
import '/widgets/custome-appbar.dart';
import '/widgets/custome-bottombar.dart';
import '/widgets/customeSnackbar.dart';
import '/widgets/image-upload.dart';
import '/widgets/upload-card.dart';
import 'package:provider/provider.dart';

class LastPage extends StatefulWidget {
  static const String screenName = "/last-page";
  final bool fromSignUp;

  const LastPage({Key key, this.fromSignUp}) : super(key: key);
  @override
  _LastPageState createState() => _LastPageState();
}

// Doctor _doctor;

class _LastPageState extends State<LastPage> {
  File idFile;
  bool isFileSelected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // verifyUser();
  }

  handleId() async {
    try {
      final val = await buildPictureSelector(context);
      if (val != null) {
        setState(() {
          idFile = val;
          isFileSelected = true;
          // print('>isFileSelected $isFileSelected');
        });
      }
    } catch (error) {
      ScaffoldMessengerState()
          .showSnackBar(buildSnackBar("something goes wrong", context));
    }
  }

  submitForm(DoctorProvider doctor) {
    if (!isFileSelected) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                        'If you don\'t provide your ID you will not be a verified user.'),
                    Text(
                        'As unverified user there are some features you will not be able to access.'),
                    SizedBox(
                      height: kPadding,
                    ),
                    Text(
                      'Are you sure you want to continue as unverfied user?',
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: kPadding),
              actions: [
                TextButton(
                    onPressed: () {
                      // TODO : CHECK IT
                      doctor.uploadId(idFile).whenComplete(() {
                        doctor.registerUser().whenComplete(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                              buildCloseableSnackBar(
                                  "We have received your request we will review and let you know your request result in few days",
                                  context));
                          Future.delayed(
                            Duration(milliseconds: 100),
                            () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RealHomeScreen(),
                              ),
                            ),
                          );
                        });
                        // idFile = null;
                      });
                    },
                    child: Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RealHomeScreen(),
                        ),
                      );
                    },
                    child: Text('No'))
              ],
            );
          },
          barrierDismissible: false);
    } else {
      if (isFileSelected) {
        doctor.uploadId(idFile).whenComplete(() {
          // idFile = null;
          ScaffoldMessenger.of(context).showSnackBar(buildCloseableSnackBar(
              "We have received your request we will review and let you know your request result in few days",
              context));
          Future.delayed(Duration(milliseconds: 100), () {
            doctor.registerUser().whenComplete(() => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RealHomeScreen())));
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context);

    return Scaffold(
      appBar: buildAppBar(
          context, widget.fromSignUp ? 'SignUp' : 'Request Verification', 0),
      bottomNavigationBar: CustomBottomBar(() => submitForm(doctorProvider)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kPadding, vertical: kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Instutional ID card',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: kPadding,
              ),
              UploadCard(
                iconUrl: isFileSelected
                    ? idFile.path
                    : "assets/images/image-upload.png",
                onPressed: handleId,
                onDelte: () {
                  setState(() {
                    isFileSelected = false;
                  });
                },
                isSelected: isFileSelected,
                isAsset: !isFileSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
