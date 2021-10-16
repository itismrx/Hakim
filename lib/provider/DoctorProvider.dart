// import 'dart:io';

// import 'package:flutter/widgets.dart';
// import '../modal/doctor-modal.dart';

// class Education {
//   String university;
//   String graduationYear;
//   String documentUrl = "";

//   Education(
//     this.university,
//     this.graduationYear,
//     this.documentUrl,
//   );
//   setDocument(String docUrl) {
//     this.documentUrl = docUrl;
//   }
// }

// class Address {
//   final String country;
//   final String state;
//   final String city;

//   Address(this.country, this.state, this.city);
// }

// class Doctor extends ChangeNotifier {
//   String uid;
//   String email;
//   String fullName;
//   String userName;
//   String phoneNumber;
//   String gender;
//   DateTime dateOfBirth;
//   Address homeAddress;
//   String bio;
//   double yearOfExperiance = 0;
//   String profilePictureUrl;
//   String speciality;
//   String workPlace;
//   Education undergrad;
//   Education postgrad;
//   String medicalLicenseUrl;
//   String licenseNumber;
//   String issuingCountry;
//   List<String> languages;
//   DateTime joinedDate;

//   Doctor({
//     this.uid,
//     this.email,
//     this.fullName,
//     this.userName,
//     this.phoneNumber,
//     this.gender,
//     this.dateOfBirth,
//     this.homeAddress,
//     this.bio,
//     this.yearOfExperiance,
//     this.profilePictureUrl,
//     this.speciality,
//     this.workPlace,
//     this.undergrad,
//     this.postgrad,
//     this.medicalLicenseUrl,
//     this.licenseNumber,
//     this.issuingCountry,
//     this.languages,
//     this.joinedDate,
//   });

//   registerNewDoctor(Doctor doctor) {
//     // send to the server

//     notifyListeners();
//   }

//   signUpFirstPage(
//       {String uid,
//       String fullName,
//       String userName,
//       String phoneNumber,
//       String email,
//       DateTime dob,
//       String gender,
//       String profilePictureUrl,
//       String country,
//       String state,
//       String city,
//       DateTime joinedDate}) {
//     this.uid = uid;
//     this.userName = userName;
//     this.fullName = fullName;
//     this.phoneNumber = phoneNumber;
//     this.dateOfBirth = dob;
//     this.gender = gender;
//     this.homeAddress = Address(country, state, city);
//     this.email = email;
//     this.profilePictureUrl = profilePictureUrl;
//     this.joinedDate = joinedDate;
//     notifyListeners();
//   }

//   signUpSecondPage(
//       {List<String> languages,
//       String workPlace,
//       String ugSchool,
//       String ugGcYear,
//       String pgSchool,
//       String pgGcYear,
//       double yearOfExperiance}) {
//     this.workPlace = workPlace;
//     this.undergrad = Education(ugSchool, ugGcYear, null);
//     this.postgrad =
//         pgSchool == null ? null : Education(pgSchool, pgGcYear, null);
//     this.yearOfExperiance = yearOfExperiance;
//     this.languages = languages;
//     notifyListeners();
//   }

//   setSpecality(String speciality) {
//     this.speciality = speciality;

//     notifyListeners();
//   }

//   String uploadFile(File fileUrl, String folder) {
//     return fileUrl.path;
//   }

//   setDocument(File ugDocUrl, File pgDocUrl, File idDocUrl) {
//     this.undergrad.setDocument(
//         ugDocUrl == null ? "" : uploadFile(ugDocUrl, '/undergrad-doc'));
//     if (this.postgrad != null) {
//       this.postgrad.setDocument(
//           pgDocUrl == null ? "" : uploadFile(pgDocUrl, '/postgrad-doc'));
//     }

//     this.medicalLicenseUrl =
//         ugDocUrl == null ? "" : uploadFile(idDocUrl, '/id-card');

//     notifyListeners();
//   }

//   DoctorModal toDoctorModal() {
//     return DoctorModal(
//       uid: this.uid,
//       workPlace: this.workPlace,
//       email: this.email,
//       fullName: this.fullName,
//       userName: this.userName,
//       phoneNumber: this.phoneNumber,
//       gender: this.gender,
//       dateOfBirth: this.dateOfBirth,
//       country: this.homeAddress.country,
//       state: this.homeAddress.state,
//       city: this.homeAddress.city,
//       ugDocUrl: this.undergrad.documentUrl,
//       ugUnviName: this.undergrad.university,
//       ugGcYear: this.undergrad.graduationYear,
//       pgDocUrl: this.postgrad.documentUrl,
//       pgUnviName: this.undergrad.university,
//       pgGcYear: this.undergrad.graduationYear,
//       idPicUrl: this.medicalLicenseUrl,
//       languages: this.languages,
//       yearOfExperiance: this.yearOfExperiance,
//       bio: this.bio,
//       profilePictureUrl: this.profilePictureUrl,
//       speciality: this.speciality,
//       isVerified: false,
//       joinedDate: this.joinedDate,
//     );
//   }

//   Doctor featchDoctorById(String id) {
//     // featch user by ID
//     notifyListeners();
//   }
// }
