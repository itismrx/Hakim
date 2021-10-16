import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/modal/user-modal.dart';
import '/screen/signup.dart';
import '/services/firestore_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class ChooseRoleScreen extends StatelessWidget {
  static const String screenName = '/choose-role';
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context)),
          title: Text(
            'Choose Role',
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kPadding,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                RoleCard(
                  imageUrl: 'assets/images/doctor.png',
                  label: 'Doctor',
                  onPressed: () async {
                    SharedPreferences pref = await _pref;
                    await pref.setString('userType', 'DOCTOR');
                    Navigator.pushNamed(context, SignUpScreen.screenName);
                  },
                ),
                SizedBox(
                  height: kPadding * 1,
                ),
                RoleCard(
                  imageUrl: 'assets/images/patient.png',
                  label: 'Patient',
                  onPressed: () async {
                    SharedPreferences pref = await _pref;
                    await pref.setString('userType', 'PATIENT');
                    Navigator.pushNamed(context, SignUpScreen.screenName);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class RoleCard extends StatelessWidget {
  final String label;
  final String imageUrl;
  final Function onPressed;

  const RoleCard({Key key, this.label, this.imageUrl, this.onPressed})
      : super(key: key);

  ListTile buildListTile(String label, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 5,
              color: Colors.black54,
              offset: Offset(
                5,
                5,
              ),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              height: height * 0.375,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue,
                      Colors.pink.shade400,
                    ]),
                borderRadius: BorderRadius.circular(
                  15,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: width * 0.45,
                        width: width * 0.45,
                        margin: label.contains('Patient', 0)
                            ? EdgeInsets.only(left: 5, top: 5)
                            : EdgeInsets.only(),
                        child: Image.asset(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: kPadding * 2,
                  ),
                  Container(
                    height: kPadding * 2,
                    alignment: Alignment.center,
                    margin:
                        const EdgeInsets.symmetric(horizontal: kPadding * 1.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Join as $label ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Icon(FontAwesomeIcons.angleDoubleRight),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              left: 120,
              top: 20,
              child: Container(
                height: height * 0.25,
                width: width * 0.6,
                child: label.contains('Doctor', 0)
                    ? ListView(
                        children: [
                          buildListTile(
                            'chat with collegue',
                            FontAwesomeIcons.facebookMessenger,
                          ),
                          buildListTile(
                            'disccuss on a case',
                            FontAwesomeIcons.users,
                          ),
                          buildListTile(
                            'consult paitents',
                            FontAwesomeIcons.userMd,
                          ),
                        ],
                      )
                    : ListView(
                        children: [
                          buildListTile(
                            'Consult Doctor',
                            FontAwesomeIcons.userMd,
                          ),
                          buildListTile(
                            'Informed on you health',
                            FontAwesomeIcons.infoCircle,
                          )
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
