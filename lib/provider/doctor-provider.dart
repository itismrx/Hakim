import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../modal/doctor-modal.dart';
import '../provider/AuthProvider.dart';
import '../services/firestorage_services.dart';
import '../services/firestore_database.dart';

class DoctorProvider extends ChangeNotifier {
  DoctorModal _doctorModal = DoctorModal();

  DoctorProvider() {
    init();
  }

  DoctorModal get doctorModal => _doctorModal;

  Future<void> init() async {
    _doctorModal =
        await FirestoreDatabase(uid: FirebaseAuth.instance.currentUser.uid)
            .getADoctor(uid: FirebaseAuth.instance.currentUser.uid);
    notifyListeners();
  }

  // @override
  Future<void> disposeIt() async {
    // super.dispose();
    this._doctorModal = null;
    notifyListeners();
  }

  Future<void> update(
      {String bio,
      String city,
      String country,
      String state,
      String phoneNumber,
      String workPlace,
      String speciality,
      double yearOfExperiance,
      String userName,
      String fullName,
      String profilePictureUrl}) async {
    doctorModal.userName = userName;
    doctorModal.city = city;
    doctorModal.country = country;
    doctorModal.state = state;
    doctorModal.phoneNumber = phoneNumber;
    doctorModal.workPlace = workPlace;
    doctorModal.speciality = speciality;
    doctorModal.yearOfExperiance = yearOfExperiance;
    doctorModal.fullName = fullName;
    doctorModal.profilePictureUrl = profilePictureUrl;
    return await FirebaseFirestore.instance
        .collection('doctors')
        .doc(_doctorModal.uid)
        .update(
      {
        'bio': bio,
        'city': city,
        'country': country,
        'state': state,
        'phoneNumber': phoneNumber,
        'workPlace': workPlace,
        'speciality': speciality,
        'yearOfExperiance': yearOfExperiance,
        'userName': userName,
        'fullName': fullName,
        'profilePictureUrl': profilePictureUrl,
      },
    ).whenComplete(() {
      notifyListeners();
    });
  }

  signUpFirstPage(
      {String uid,
      String fullName,
      String userName,
      String phoneNumber,
      String email,
      DateTime dob,
      String gender,
      String profilePictureUrl,
      String country,
      String state,
      String city,
      DateTime joinedDate}) {
    this._doctorModal.uid = uid;
    this._doctorModal.userName = userName;
    this._doctorModal.fullName = fullName;
    this._doctorModal.phoneNumber = phoneNumber;
    this._doctorModal.dateOfBirth = dob;
    this._doctorModal.gender = gender;
    this._doctorModal.city = city;
    this._doctorModal.country = country;
    this._doctorModal.state = state;
    this._doctorModal.email = email;
    this._doctorModal.profilePictureUrl = profilePictureUrl;
    this._doctorModal.joinedDate = joinedDate;
    this._doctorModal.isVerified = false;
    notifyListeners();
  }

  signUpSecondPage(
      {List<String> languages,
      String workPlace,
      String ugSchool,
      String ugGcYear,
      String pgSchool,
      String pgGcYear,
      double yearOfExperiance}) {
    this._doctorModal.workPlace = workPlace;
    this._doctorModal.ugDocUrl = null;
    this._doctorModal.ugGcYear = ugGcYear;
    this._doctorModal.ugUnviName = ugSchool;

    this._doctorModal.pgDocUrl = null;
    this._doctorModal.pgGcYear = pgGcYear;
    this._doctorModal.pgUnviName = pgSchool;
    this._doctorModal.yearOfExperiance = yearOfExperiance;
    this._doctorModal.languages = languages;
    notifyListeners();
  }

  setSpecality(String speciality) {
    this._doctorModal.speciality = speciality;

    notifyListeners();
  }

  Future<void> registerUser() async {
    FirestoreDatabase(uid: this._doctorModal.uid)
        .setDoctor(this._doctorModal)
        .whenComplete(() {
      notifyListeners();
    });
  }

  Future<void> uploadId(File idDoc) async {
    if (idDoc != null) {
      FirestorageService.instances
          .uploadFile(path: 'id-cards/', filePath: idDoc.path)
          .then((String value) {
        this._doctorModal.idPicUrl = value;
        this.registerUser();
      });
    } else {
      this._doctorModal.idPicUrl = '';
    }
  }

  Future<void> setDocument(File ugDocUrl, File pgDocUrl, File idDocUrl) async {
    if (pgDocUrl != null) {
      List<String> fileUrls = await FirestorageService.instances
          .bulkUploadFile(filePath: [ugDocUrl, pgDocUrl, idDocUrl]);
      this._doctorModal.ugDocUrl = fileUrls[0];
      this._doctorModal.pgDocUrl = fileUrls[1];
      this._doctorModal.idPicUrl = fileUrls[2];
    } else {
      List<String> fileUrls = await FirestorageService.instances
          .bulkUploadFile(filePath: [ugDocUrl, idDocUrl]);
      this._doctorModal.ugDocUrl = fileUrls[0];
      this._doctorModal.idPicUrl = fileUrls[1];

      this._doctorModal.pgDocUrl = null;
    }

    notifyListeners();
  }
}
