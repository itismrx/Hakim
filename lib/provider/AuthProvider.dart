import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../modal/user-modal.dart';
import '../provider/DoctorProvider.dart';
import '../provider/doctor-provider.dart';
import '../widgets/customeSnackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  Uninitalized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Registering
}

class AuthProvider extends ChangeNotifier {
  FirebaseAuth _auth;
  SharedPreferences _pref;

  Status _status = Status.Uninitalized;

  Status get status => _status;

  Stream<UserModal> get user => _auth.authStateChanges().map(_userFromFirebase);

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen(authStateChanged);
    SharedPreferences.getInstance().then((value) => _pref = value);
  }

  UserModal _userFromFirebase(User user) {
    if (user == null) {
      return null;
    } else {
      return UserModal(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        phoneNumber: user.phoneNumber,
        photoURL: user.photoURL,
        // userType: _pref.getString('userType'),
      );
    }
  }

  Future<void> authStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _userFromFirebase(firebaseUser);
      _status = Status.Authenticated;
      // await DoctorProvider().init();
    }
    notifyListeners();
  }

  Future<UserModal> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      _status = Status.Registering;
      notifyListeners();
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return _userFromFirebase(result.user);
    } catch (e) {
      print('Error on the new user registration ${e.toString()}');
      _status = Status.Unauthenticated;
      notifyListeners();
      throw e;
    }
  }

  User getCurrentUser() {
    return _auth.currentUser;
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = Status.Authenticating;
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value != null) {
          DoctorProvider().init();
        }
      });
      _status = Status.Authenticated;
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      throw e;
    }
  }

  Future<void> phoneAutentication() async {
    print('Phone Autentication');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+251 9451 316 92',
      verificationCompleted: (PhoneAuthCredential credential) {
        print('Autenticated');
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Auntentication Failed');
      },
      codeSent: (String verificationId, int resendToken) {
        print(verificationId);
        print(resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserModal> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final userCredentail = await FirebaseAuth.instance
        .signInWithCredential(credential)
        .whenComplete(() => DoctorProvider().init());
    return _userFromFirebase(userCredentail.user);
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}
