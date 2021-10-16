// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '/constant.dart';
// import '/provider/DoctorProvider.dart';
// import '/provider/doctor-provider.dart';
// import '/screen/SignUp/Doctor/page-three.dart';
// import '../../settings.dart';
// import '/screen/rhome.screen.dart';
// import '/services/firestore_database.dart';
// import '/widgets/custome-appbar.dart';
// import '/widgets/custome-bottombar.dart';
// import '/widgets/customeSnackbar.dart';
// import '/widgets/image-upload.dart';
// import '/widgets/upload-card.dart';
// import 'package:provider/provider.dart';

// class PageFour extends StatefulWidget {
//   static const String screenName = "/doctor-signup-four";
//   @override
//   _PageFourState createState() => _PageFourState();
// }

// File ugDocument;
// File pgDocument;
// File idFile;
// // Doctor _doctor;

// class _PageFourState extends State<PageFour> {
//   hanldeUGDocument() async {
//     FilePicker.platform.pickFiles(
//         type: FileType.custom, allowedExtensions: ['pdf']).then((value) {
//       setState(() {
//         ugDocument = File(value.files.first.path);
//       });
//     });
//   }

//   hanldePGDocument() async {
//     FilePicker.platform.pickFiles(
//         type: FileType.custom, allowedExtensions: ['pdf']).then((value) {
//       setState(() {
//         pgDocument = File(value.files.first.path);
//       });
//     });
//   }

//   handleId() async {
//     try {
//       final val = await buildPictureSelector(context);
//       if (val != null) {
//         setState(() {
//           idFile = val;
//         });
//       }
//     } catch (error) {
//       ScaffoldMessengerState()
//           .showSnackBar(buildSnackBar("something goes wrong", context));
//     }
//   }

//   submitForm(DoctorProvider doctor) {
//     bool agreed = false;
//     if (idFile == null || ugDocument == null) {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Confirmation'),
//               content: SingleChildScrollView(
//                 child: ListBody(
//                   children: const [
//                     Text(
//                         'If you don\'t provide your ID you will not be a verified user.'),
//                     Text(
//                         'As unverified user there are some features you will not be able to access.'),
//                     SizedBox(
//                       height: kPadding,
//                     ),
//                     Text(
//                       'Are you sure you want to continue as unverfied user?',
//                     ),
//                   ],
//                 ),
//               ),
//               actionsPadding: const EdgeInsets.symmetric(horizontal: kPadding),
//               actions: [
//                 TextButton(
//                     onPressed: () {
//                       doctor.setDocument(ugDocument, pgDocument, idFile);
//                     },
//                     child: Text('Yes')),
//                 TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text('No'))
//               ],
//             );
//           },
//           barrierDismissible: false);
//     } else {
//       doctor.setDocument(ugDocument, pgDocument, idFile);
//       doctor.registerUser().whenComplete(() =>
//           Navigator.pushReplacementNamed(context, RealHomeScreen.screenName));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context);

//     return Scaffold(
//       appBar: buildAppBar(context, 'SignUp', 4),
//       bottomNavigationBar: CustomBottomBar(() => submitForm(doctorProvider)),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: kPadding),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Text(
//               "Under-Graduate Documents",
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             SizedBox(
//               height: kPadding,
//             ),
//             UploadCard(
//               iconUrl: "assets/images/file-upload.png",
//               onPressed: hanldeUGDocument,
//               isSelected: ugDocument != null,
//             ),
//             SizedBox(
//               height: kPadding * .5,
//             ),
//             Text(
//               "Post-Graduate Documents",
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             SizedBox(
//               height: kPadding * .5,
//             ),
//             UploadCard(
//               iconUrl: "assets/images/file-upload.png",
//               onPressed: hanldePGDocument,
//               isSelected: pgDocument != null,
//             ),
//             SizedBox(
//               height: kPadding * .5,
//             ),
//             Text(
//               'ID Card',
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             SizedBox(
//               height: kPadding * .5,
//             ),
//             UploadCard(
//               iconUrl: "assets/images/image-upload.png",
//               onPressed: handleId,
//               isSelected: idFile != null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
