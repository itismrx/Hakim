import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/constant.dart';
import '/modal/doctor-modal.dart';
import '/provider/doctor-provider.dart';
import '/services/firestorage_services.dart';
import '/widgets/custom_input_field.dart';
import '/widgets/image-upload.dart';
import '/widgets/profile-picture.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loading/indicator/line_scale_indicator.dart';
import 'package:loading/loading.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final DoctorModal doctorModal;
  final Function reload;
  EditProfile(this.doctorModal, this.reload);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _workPlaceController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _specialityController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _ppUrl;
  GlobalKey _formKey = GlobalKey<FormState>();

  String selectedCity = '';
  String selectedCountry = '';
  String selectedState = '';
  double _yearOfExperiance = 0.0;

  PhoneNumber number = PhoneNumber(isoCode: 'ET');

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.doctorModal.fullName;
    _userNameController.text = widget.doctorModal.userName;
    _workPlaceController.text = widget.doctorModal.workPlace;
    _specialityController.text = widget.doctorModal.speciality;
    _phoneNumberController.text = widget.doctorModal.phoneNumber;
    _bioController.text = widget.doctorModal.bio;
    selectedCity = widget.doctorModal.city;
    selectedCountry = widget.doctorModal.country;
    selectedState = widget.doctorModal.state;
    _yearOfExperiance = widget.doctorModal.yearOfExperiance;
    _ppUrl = widget.doctorModal.profilePictureUrl;
    // setState(() {

    // });
  }

  bool _isSending = false;

  _save(DoctorProvider _doctorProvider) async {
    setState(() {
      _isSending = true;
    });

    _doctorProvider
        .update(
            bio: _bioController.text,
            country: selectedCountry,
            state: selectedState,
            city: selectedCity,
            phoneNumber: _phoneNumberController.text,
            workPlace: _workPlaceController.text,
            speciality: _specialityController.text,
            yearOfExperiance: _yearOfExperiance,
            userName: _userNameController.text,
            fullName: _nameController.text,
            profilePictureUrl: _ppUrl)
        .whenComplete(() {
      setState(() {
        _isSending = false;
      });
      Navigator.pop(context);
      widget.reload();
      // FirebaseFirestore.instance.collection('users')
    });
  }

  @override
  Widget build(BuildContext context) {
    DoctorProvider doctorProvider =
        Provider.of<DoctorProvider>(context, listen: false);
    DoctorModal doctorModal = doctorProvider.doctorModal;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.times,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          GestureDetector(
            onTap: () => _save(doctorProvider),
            child: Container(
              width: 85,
              height: 35,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                  color: !_isSending
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withOpacity(0.4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isSending ? 'Saving' : 'Save',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  _isSending ? CircularProgressIndicator() : Container(),
                ],
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(
              left: kPadding,
              right: kPadding,
              top: kPadding * .25,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                              url: widget.doctorModal.profilePictureUrl,
                              fullName: widget.doctorModal.fullName,
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
                          final fileUrl = await buildPictureSelector(context);
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
                labelText: 'bio',
                controller: _bioController,
              ),
              SizedBox(
                height: kPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Year of expriance'),
                  Text('${_yearOfExperiance.toStringAsFixed(1)} yrs')
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Slider.adaptive(
                      value: _yearOfExperiance,
                      min: 0,
                      max: 100,
                      onChanged: (value) {
                        setState(() {
                          _yearOfExperiance = value;
                        });
                      },
                      divisions: 100,
                      label: _yearOfExperiance != null
                          ? '${_yearOfExperiance.toStringAsFixed(0)}'
                          : '0.0',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: kPadding,
              ),
              CustomInputField(
                labelText: 'Full Name',
                controller: _nameController,
              ),
              SizedBox(
                height: kPadding,
              ),
              CustomInputField(
                labelText: 'User Name',
                controller: _userNameController,
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
              TypeAheadFormField(
                hideOnEmpty: true,
                textFieldConfiguration: TextFieldConfiguration(
                  textInputAction: TextInputAction.next,
                  controller: _workPlaceController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          _workPlaceController.text = '';
                        }),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Work Place",
                  ),
                ),
                onSuggestionSelected: (text) {
                  setState(() {
                    _workPlaceController.text = text;
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
                    _workPlaceController.text = text;
                  });
                },
              ),
              SizedBox(
                height: kPadding,
              ),
              TypeAheadFormField(
                hideOnEmpty: true,
                textFieldConfiguration: TextFieldConfiguration(
                  textInputAction: TextInputAction.next,
                  controller: _specialityController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          _specialityController.text = '';
                        }),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Speciality",
                  ),
                ),
                onSuggestionSelected: (text) {
                  setState(() {
                    _specialityController.text = text;
                  });
                },
                itemBuilder: (context, suggesion) {
                  return ListTile(
                    title: Text(suggesion),
                  );
                },
                suggestionsCallback: (pattern) {
                  if (pattern.isNotEmpty) {
                    return Speciality.where((hospital) => hospital.startsWith(
                          RegExp('^$pattern', caseSensitive: false),
                        )).toList();
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
                    _specialityController.text = text;
                  });
                },
              ),
              SizedBox(
                height: kPadding,
              ),
              // SizedBox(
              //   height: kPadding,
              // ),

              // Padding(
              //   padding: EdgeInsets.only(
              //       bottom: MediaQuery.of(context).viewInsets.bottom),
              //   child: CustomInputField(
              //     labelText: 'Speciality',
              //     controller: _specialityController,
              //   ),
              // ),
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
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.grey.shade300,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),
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
                      selectedCountry = value;
                    });
                  },

                  ///triggers once state selected in dropdown
                  onStateChanged: (value) {
                    setState(() {
                      ///store value in state variable
                      selectedState = value ?? widget.doctorModal.state;
                    });
                  },

                  ///triggers once city selected in dropdown
                  onCityChanged: (value) {
                    setState(() {
                      selectedCity = value ?? widget.doctorModal.city;
                    });
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
