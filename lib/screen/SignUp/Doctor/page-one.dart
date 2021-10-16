import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import '/constant.dart';
import '/modal/doctor-modal.dart';
import '/provider/DoctorProvider.dart';
import '/provider/doctor-provider.dart';
import '/screen/SignUp/Doctor/page-two.dart';
import '/services/firestorage_services.dart';
import '/utility.dart';
import '/widgets/custom_input_field.dart';
import '/widgets/custome-appbar.dart';
import '/widgets/custome-bottombar.dart';
import '/widgets/image-upload.dart';
import '/widgets/profile-picture.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class PageOne extends StatefulWidget {
  static const String screenName = "/doctor-signup-one";
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  final _form = GlobalKey<FormState>();
  User _user;
  PhoneNumber number = PhoneNumber(isoCode: 'ET');
  DateTime _selectedDate;
  String _selectedGender;
  String selectCountry = 'Ethiopia';
  String selectedState;
  String selectedCity;
  String _ppUrl;

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user.displayName != null) _nameController.text = _user.displayName;
    if (_user.phoneNumber != null)
      _phoneNumberController.text = _user.phoneNumber;
    if (_user.photoURL != null) _ppUrl = _user.photoURL;
  }

  submitForm(DoctorProvider doctor) async {
    bool isValid = _form.currentState.validate();

    if (isValid &&
        _selectedGender != null &&
        selectCountry != null &&
        selectedCity != null &&
        selectedState != null) {
      List<String> split = _dateController.text.split("-");
      if (_user.phoneNumber != null) {
        await _user.updateDisplayName(number.phoneNumber);
      }

      await FirebaseChatCore.instance.createUserInFirestore(types.User(
        firstName: toTitle(_nameController.text.split(' ')[0]),
        id: _user.uid,
        imageUrl: _ppUrl,
        lastName: toTitle(_nameController.text.split(' ').last),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ));

      doctor.signUpFirstPage(
        uid: _user.uid,
        fullName: toTitle(_nameController.text),
        userName: _userNameController.text,
        email: _user.email,
        profilePictureUrl: _ppUrl,
        phoneNumber: number.phoneNumber,
        dob: DateTime(
            int.parse(split[2]), int.parse(split[1]), int.parse(split[0])),
        gender: _selectedGender,
        country: selectCountry,
        state: selectedState,
        city: selectedCity,
        joinedDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
      );
      Navigator.pushNamed(context, PageTwo.screenName);
    }
  }

  @override
  Widget build(BuildContext context) {
    DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context);
    return Scaffold(
      appBar: buildAppBar(context, "SignUp", 1),
      bottomNavigationBar: CustomBottomBar(() => submitForm(doctorProvider)),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: kPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          height: kPpOnProfilePage * 2.2,
                          width: kPpOnProfilePage * 2.2,
                          child: Stack(
                            children: [
                              Container(
                                height: kPpOnProfilePage * 2.2,
                                width: kPpOnProfilePage * 2.2,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Theme.of(context).accentColor,
                                          Theme.of(context).primaryColor
                                        ])),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: ProfilePicture(
                                  url: _ppUrl,
                                  fullName: _nameController.text,
                                  radius: kPpOnProfilePage,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 9,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              final fileUrl =
                                  await buildPictureSelector(context);
                              FirestorageService.instances
                                  .uploadFile(
                                      path: 'profile-pictures/',
                                      filePath: fileUrl.path)
                                  .then((value) {
                                setState(() {
                                  _ppUrl = value;
                                });
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).accentColor,
                              ),
                              width: 20,
                              height: 20,
                              child: Icon(
                                Icons.add_a_photo_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: kPadding,
                  ),
                  CustomInputField(
                    // hintText: 'John Doe',
                    labelText: 'Full Name',
                    controller: _nameController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return '* Required Field';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: kPadding,
                  ),
                  CustomInputField(
                    // hintText: 'John Doe',
                    labelText: 'User Name',
                    controller: _userNameController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return '* Required Field';
                      }
                      if (value.length < 6) {
                        return 'User name must have at least 6 characters';
                      }
                      bool userNameValid = RegExp(
                              r"^(?=.{6,18}$)(?![_.])(?!.*[_]{2})[a-zA-Z0-9._]+(?<![_.])$")
                          .hasMatch(value);

                      if (!userNameValid) {
                        return 'Invalid format use instead John_doe or johndoe ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: kPadding,
                  ),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber _number) {
                      setState(() {
                        number = _number;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "* Required Field";
                      }
                      return null;
                    },
                    inputBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    inputDecoration: InputDecoration(
                      hintText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    ignoreBlank: true,
                    initialValue: number,
                    textFieldController: _phoneNumberController,
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      showFlags: true,
                    ),
                  ),
                  SizedBox(
                    height: kPadding,
                  ),
                  TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    textInputAction: TextInputAction.next,
                    controller: _dateController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "* Required Field";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: kPadding),
                          child: GestureDetector(
                            child: Icon(
                              Icons.calendar_today,
                              color: Theme.of(context).primaryColor,
                            ),
                            onTap: () async {
                              DateTime selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(1970),
                                  firstDate: DateTime(1970),
                                  lastDate: DateTime(2015));
                              setState(() {
                                _selectedDate = selectedDate;
                                _dateController.text =
                                    '${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}';
                              });
                            },
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Date of Birth',
                        hintText: 'yyyy-mm-dd',
                        contentPadding: const EdgeInsets.all(kPadding)),
                  ),
                  SizedBox(
                    height: kPadding,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: kPadding),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Gender'),
                        DropdownButton<String>(
                          value: _selectedGender,
                          focusColor: Colors.purple.shade500,
                          items: <String>['Male', 'Female']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            'Gender',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: kPadding,
                  ),
                  Text('Address'),
                  SizedBox(
                    height: kPadding,
                  ),
                  Container(
                    child: CSCPicker(
                      showCities: true,
                      showStates: true,
                      flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                      defaultCountry: DefaultCountry.Ethiopia,
                      dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),

                      disabledDropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.grey.shade300,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),
                      selectedItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      dropdownHeadingStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                      dropdownItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      dropdownDialogRadius: 5,
                      searchBarRadius: 10.0,
                      onCountryChanged: (value) {
                        setState(() {
                          ///store value in country variable
                          selectCountry = value;
                        });
                      },

                      ///triggers once state selected in dropdown
                      onStateChanged: (value) {
                        setState(() {
                          ///store value in state variable
                          selectedState = value;
                        });
                      },

                      ///triggers once city selected in dropdown
                      onCityChanged: (value) {
                        setState(() {
                          ///store value in city variable
                          selectedCity = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
