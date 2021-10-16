import 'package:flutter/material.dart';
import '/provider/DoctorProvider.dart';
import '/provider/doctor-provider.dart';
import '/screen/SignUp/Doctor/page-three.dart';
import '/widgets/custome-appbar.dart';
import '/widgets/custome-bottombar.dart';
import '/widgets/customeSnackbar.dart';
import '/widgets/custom-chip.dart';
import '/widgets/school-info-card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../constant.dart';

class PageTwo extends StatefulWidget {
  static const String screenName = "/doctor-signup-two";
  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  final _formKey = new GlobalKey<FormState>();

  TextEditingController _hospitalInputController = TextEditingController();
  TextEditingController _ugSchoolNameController = TextEditingController();
  TextEditingController _ugGCDateController = TextEditingController();
  TextEditingController _pgSchoolNameController = TextEditingController();
  TextEditingController _pgGCDateController = TextEditingController();

  FocusNode _hospitalFocusNode = FocusNode();
  FocusNode _uGGCFocusNode = FocusNode();

  double _yearOfExperiance = 0;
  bool hasText = false;
  List<String> languages = [];

  submitForm(DoctorProvider doctor) {
    bool isValid = _formKey.currentState.validate();
    if (languages.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar('Please, select at least one language', context));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();

      doctor.signUpSecondPage(
        languages: languages,
        workPlace: _hospitalInputController.text,
        ugSchool: _ugSchoolNameController.text,
        ugGcYear: _ugGCDateController.text,
        pgSchool: _pgSchoolNameController.text,
        pgGcYear: _pgGCDateController.text,
        yearOfExperiance: _yearOfExperiance,
      );
      Navigator.pushNamed(context, PageThree.screenName);
    }
  }

  @override
  Widget build(BuildContext context) {
    DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context);
    return Scaffold(
      appBar: buildAppBar(context, 'Sign Up', 2),
      bottomNavigationBar: CustomBottomBar(() => submitForm(doctorProvider)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding),
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Language"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: kPadding),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Languages.map(
                          (language) => CustomChip(
                              label: language,
                              onPressed: () {
                                setState(() {
                                  bool exist = languages.contains(language);
                                  if (exist) {
                                    languages
                                        .removeWhere((lan) => lan == language);
                                  } else {
                                    languages.add(language);
                                  }
                                });
                              }),
                        ).toList(),
                      ),
                    ),
                  ),
                  TypeAheadFormField(
                    hideOnEmpty: true,
                    textFieldConfiguration: TextFieldConfiguration(
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_uGGCFocusNode);
                      },
                      controller: _hospitalInputController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              _hospitalInputController.text = '';
                            }),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: "Work Place",
                      ),
                    ),
                    onSuggestionSelected: (text) {
                      setState(() {
                        _hospitalInputController.text = text;
                      });
                    },
                    itemBuilder: (context, suggesion) {
                      return ListTile(
                        title: Text(suggesion),
                      );
                    },
                    suggestionsCallback: (pattern) {
                      if (pattern.isNotEmpty) {
                        return getHospitals()
                            .where((hospital) => hospital.startsWith(
                                  RegExp('^$pattern', caseSensitive: false),
                                ))
                            .toList();
                      } else {
                        return [];
                      }
                    },
                    validator: (text) {
                      if (text.isEmpty) {
                        return '* Required Filed';
                      }
                      return null;
                    },
                    onSaved: (text) {
                      setState(() {
                        _hospitalInputController.text = text;
                      });
                    },
                  ),
                  SizedBox(
                    height: kPadding,
                  ),
                  Text('Under-Graduate'),
                  SizedBox(
                    height: kPadding,
                  ),
                  SchoolInfoCard(
                    schoolController: _ugSchoolNameController,
                    graduationDateController: _ugGCDateController,
                    type: 'ug',
                  ),
                  SizedBox(
                    height: kPadding,
                  ),
                  Text('Post-Graduate'),
                  SizedBox(
                    height: kPadding,
                  ),
                  SchoolInfoCard(
                    schoolController: _pgSchoolNameController,
                    graduationDateController: _pgGCDateController,
                  ),
                  SizedBox(
                    height: kPadding,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Year of Experiance'),
                      Text('${_yearOfExperiance.toStringAsFixed(0)} year')
                    ],
                  ),
                  SizedBox(
                    height: kPadding,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Slider.adaptive(
                          value: _yearOfExperiance,
                          min: 0,
                          max: _ugGCDateController.text.isNotEmpty
                              ? DateTime.now().year -
                                  double.parse(_ugGCDateController.text)
                              : 15,
                          onChanged: (value) {
                            setState(() {
                              _yearOfExperiance = value;
                            });
                          },
                          divisions: _ugGCDateController.text.isNotEmpty
                              ? DateTime.now().year -
                                  int.parse(_ugGCDateController.text)
                              : 15,
                          label: '${_yearOfExperiance.toStringAsFixed(0)}',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
