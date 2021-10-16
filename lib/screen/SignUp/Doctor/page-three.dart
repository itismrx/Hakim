import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hakim_app/screen/SignUp/Doctor/updated-page-four.dart';
import '/provider/DoctorProvider.dart';
import '/provider/doctor-provider.dart';
import '/screen/SignUp/Doctor/page-four.dart';
import '/widgets/custome-appbar.dart';
import '/widgets/custome-bottombar.dart';
import '/widgets/customeSnackbar.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/line_scale_indicator.dart';
import 'package:loading/loading.dart';
import 'package:provider/provider.dart';

import '../../../constant.dart';

class PageThree extends StatefulWidget {
  static const String screenName = "/doctor-signup-three";
  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 3;
  String _selectedSpecality = Speciality[3];

  formSubmit(DoctorProvider doctor) {
    if (_selectedSpecality.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar("Please select your specality", context));
      return;
    }
    doctor.setSpecality(this._selectedSpecality);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LastPage(
        fromSignUp: true,
      );
    }));
    // Navigator.pushNamed(context, LastPage.screenName);
  }

  @override
  Widget build(BuildContext context) {
    DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context);
    return Scaffold(
      appBar: buildAppBar(context, "Sign Up", 3),
      bottomNavigationBar: CustomBottomBar(() => formSubmit(doctorProvider)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding),
        child: ListView.builder(
            itemCount: Speciality.length,
            itemBuilder: (context, idx) {
              return Card(
                child: ListTile(
                  title: Text(Speciality[idx]),
                  trailing: _selectedIndex == idx
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 25,
                        )
                      : Icon(
                          Icons.circle,
                          size: 1,
                        ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = idx;
                      _selectedSpecality = Speciality[idx];
                    });
                  },
                ),
              );
            }),
      ),
    );
  }
}
