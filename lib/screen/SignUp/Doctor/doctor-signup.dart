// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import package:hakim_app/modal/Hospitals.dart';
// import package:hakim_app/modal/University.dart';
// import package:hakim_app/modal/provider/Doctor.dart';
// import package:hakim_app/screen/SignUp/Doctor/page-four.dart';
// import package:hakim_app/screen/SignUp/Doctor/page-one.dart';
// import package:hakim_app/screen/SignUp/Doctor/page-three.dart';
// import package:hakim_app/screen/SignUp/Doctor/page-two.dart';
// import package:hakim_app/screen/home-screen.dart';
// import package:hakim_app/widgets/custome-appbar.dart';
// import package:hakim_app/widgets/language-chip.dart';
// import package:hakim_app/widgets/school-info-card.dart';
// import 'package:intl/intl.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import package:hakim_app/constant.dart';
// import package:hakim_app/widgets/custom_input_field.dart';
// import 'package:csc_picker/csc_picker.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'package:provider/provider.dart';

// class DoctorSignup extends StatefulWidget {
//   static const screenName = '/signup-doctor';

//   @override
//   _DoctorSignupState createState() => _DoctorSignupState();
// }

// class _DoctorSignupState extends State<DoctorSignup> {
//   PageController _pageController = PageController();

//   int _pageNumber = 0;
//   PageOne _pageOne;
//   PageTwo _pageTwo;
//   PageThree _pageThree;
//   PageFour _pageFour;
//   List _pages;
//   Doctor doctor;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     _pageOne = PageOne();
//     _pageTwo = PageTwo();
//     _pageThree = PageThree();
//     _pageFour = PageFour();
//     _pages = [_pageOne, _pageTwo, _pageThree, _pageFour];
//   }

//   void nextPage() {
//     _pageController.animateToPage(_pageController.page.toInt() + 1,
//         duration: Duration(microseconds: 400), curve: Curves.easeIn);
//   }

//   void homePage() {
//     Navigator.pushReplacementNamed(context, HomeScreen.screenName);
//   }

//   void previousPage() {
//     _pageController.animateToPage(_pageController.page.toInt() - 1,
//         duration: Duration(microseconds: 400), curve: Curves.easeIn);
//   }

//   _onPageChanged(int page) {
//     setState(() {
//       _pageNumber = page;
//     });
//     setState(() {
//       if (page == 1) {
//         _pageOne.onFormSubmit(doctor);
//       } else if (page == 2) {
//         _pageTwo.onFormSubmit(doctor);
//       } else if (page == 3) {
//         _pageThree.onFormSubmit(doctor);
//       } else {
//         _pageFour.onFormSubmit(doctor);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     doctor = Provider.of<Doctor>(context, listen: true);
//     return Scaffold(
//       appBar: buildAppBar(context, 'SignUp', 0),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: kPadding),
//         child: PageView(
//           physics: NeverScrollableScrollPhysics(),
//           controller: _pageController,
//           onPageChanged: (page) => _onPageChanged(page),
//           children: [
//             PageOne(),
//             PageTwo(),
//             PageThree(),
//             PageFour(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: previousPage,
//             child: Container(
//                 margin: const EdgeInsets.only(
//                     left: kPadding, right: kPadding, bottom: kPadding * 0.5),
//                 width: kPadding * 5,
//                 height: kPadding * 2,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.transparent, width: 3),
//                   borderRadius: BorderRadius.circular(15),
//                   color: Colors.transparent,
//                 ),
//                 child: Icon(
//                   FontAwesomeIcons.chevronLeft,
//                   color: Theme.of(context).primaryColor,
//                 )),
//           ),
//           GestureDetector(
//             onTap: _pageNumber == 3 ? homePage : nextPage,
//             child: Container(
//               margin: const EdgeInsets.only(
//                   left: kPadding, right: kPadding, bottom: kPadding * 0.5),
//               width: kPadding * 5,
//               height: kPadding * 2,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.transparent, width: 3),
//                 borderRadius: BorderRadius.circular(15),
//                 color: Colors.transparent,
//               ),
//               child: Icon(
//                 FontAwesomeIcons.chevronRight,
//                 color: Colors.blue,
//               ),
//               // child: Text(
//               //   'Next',
//               //   style: TextStyle(color: Colors.white),
//               // ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
