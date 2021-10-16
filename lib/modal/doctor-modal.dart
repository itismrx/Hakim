import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Education {
  String university;
  String graduationYear;
  String documentUrl = "";

  Education(
    this.university,
    this.graduationYear,
    this.documentUrl,
  );
  setDocument(String docUrl) {
    this.documentUrl = docUrl;
  }
}

class Address {
  final String country;
  final String state;
  final String city;

  Address(this.country, this.state, this.city);
}

class DoctorModal {
  String uid;
  String email;
  String fullName;
  String userName;
  String phoneNumber;
  String gender;
  DateTime dateOfBirth;
  String country;
  String state;
  String city;
  String bio;
  double yearOfExperiance = 0;
  String profilePictureUrl;
  String speciality;
  String workPlace;
  String ugUnviName;
  String ugGcYear;
  String ugDocUrl;
  String pgUnviName;
  String pgGcYear;
  String pgDocUrl;
  String idPicUrl;
  List<String> languages;
  bool isVerified;
  DateTime joinedDate;

  DoctorModal(
      {this.uid,
      this.email,
      this.fullName,
      this.userName,
      this.phoneNumber,
      this.gender,
      this.dateOfBirth,
      this.country,
      this.state,
      this.city,
      this.bio,
      this.yearOfExperiance,
      this.profilePictureUrl,
      this.speciality,
      this.workPlace,
      this.ugUnviName,
      this.ugGcYear,
      this.ugDocUrl,
      this.pgUnviName,
      this.pgGcYear,
      this.pgDocUrl,
      this.idPicUrl,
      this.languages,
      this.isVerified,
      this.joinedDate});

  factory DoctorModal.fromDocument(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    Timestamp dob = data['dateOfBirth'];
    List lans = data['languages'];

    String uid = data['uid'];
    String email = data['email'];
    String fullName = data['fullName'];
    String userName = data['userName'];
    String phoneNumber = data['phoneNumber'];
    String gender = data['gender'];
    DateTime dateOfBirth = DateTime.parse(dob.toDate().toString());
    String country = data['country'];
    String state = data['state'];
    String city = data['city'];
    String bio = data['bio'];
    double yearOfExperiance = data['yearOfExperiance'];
    String profilePictureUrl = data['profilePictureUrl'];
    String speciality = data['speciality'];
    String workPlace = data['workPlace'];
    String ugUnviName = data['ugUnviName'];
    String ugGcYear = data['ugGCyear'];
    String ugDocUrl = data['ugDocUrl'];
    String pgUnviName = data['pgUnviName'];
    String pgGcYear = data['pgGcYear'];
    String pgDocUrl = data['pgDocUrl'];
    String idPicUrl = data['idPicUrl'];
    List<String> languages = lans.cast<String>();
    bool isVerified = data['isVerified'];
    DateTime joinedDate =
        DateTime.parse(data['joinedDate'].toDate().toString());

    return DoctorModal(
        uid: uid,
        email: email,
        fullName: fullName,
        userName: userName,
        phoneNumber: phoneNumber,
        gender: gender,
        dateOfBirth: dateOfBirth,
        country: country,
        state: state,
        city: city,
        bio: bio,
        yearOfExperiance: yearOfExperiance,
        profilePictureUrl: profilePictureUrl,
        speciality: speciality,
        workPlace: workPlace,
        ugUnviName: ugUnviName,
        ugGcYear: ugGcYear,
        ugDocUrl: ugDocUrl,
        pgUnviName: pgUnviName,
        pgGcYear: pgGcYear,
        pgDocUrl: pgDocUrl,
        idPicUrl: idPicUrl,
        languages: languages,
        isVerified: isVerified,
        joinedDate: joinedDate);
  }

  factory DoctorModal.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String uid = data['uid'];
    String email = data['email'];
    String fullName = data['fullName'];
    String userName = data['userName'];
    String phoneNumber = data['phoneNumber'];
    String gender = data['gender'];
    DateTime dateOfBirth = data['dateOfBirth'];
    String country = data['country'];
    String state = data['state'];
    String city = data['city'];
    String bio = data['bio'];
    double yearOfExperiance = data['yearOfExperiance'];
    String profilePictureUrl = data['profilePictureUrl'];
    String speciality = data['speciality'];
    String workPlace = data['workPlace'];
    String ugUnviName = data['ugUnviName'];
    String ugGcYear = data['ugGCyear'];
    String ugDocUrl = data['ugDocUrl'];
    String pgUnviName = data['pgUnviName'];
    String pgGcYear = data['pgGcYear'];
    String pgDocUrl = data['pgDocUrl'];
    String idPicUrl = data['idPicUrl'];
    List<String> languages = data['languages'];
    bool isVerified = data['isVerified'];
    DateTime joinedDate =
        DateTime.parse(data['joinedDate'].toDate().toString());

    return DoctorModal(
      uid: uid,
      email: email,
      fullName: fullName,
      userName: userName,
      phoneNumber: phoneNumber,
      gender: gender,
      dateOfBirth: dateOfBirth,
      country: country,
      state: state,
      city: city,
      bio: bio,
      yearOfExperiance: yearOfExperiance,
      profilePictureUrl: profilePictureUrl,
      speciality: speciality,
      workPlace: workPlace,
      ugUnviName: ugUnviName,
      ugGcYear: ugGcYear,
      ugDocUrl: ugDocUrl,
      pgUnviName: pgUnviName,
      pgGcYear: pgGcYear,
      pgDocUrl: pgDocUrl,
      idPicUrl: idPicUrl,
      languages: languages,
      isVerified: isVerified,
      joinedDate: joinedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'country': country,
      'state': state,
      'city': city,
      'bio': bio,
      'idPicUrl': idPicUrl,
      'yearOfExperiance': yearOfExperiance,
      'profilePictureUrl': profilePictureUrl,
      'speciality': speciality,
      'workPlace': workPlace,
      'ugUnviName': ugUnviName,
      'ugGcYear': ugGcYear,
      'ugDocUrl': ugDocUrl,
      'pgUnviName': pgUnviName,
      'pgGcYear': pgGcYear,
      'pgDocUrl': pgDocUrl,
      'languages': languages,
      'isVerified': isVerified,
      'joinedDate': joinedDate,
    };
  }
}
