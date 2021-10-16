class UserModal {
  String uid;
  String displayName;
  String email;
  String phoneNumber;
  String photoURL;
  String userType;

  UserModal(
      {this.uid,
      this.displayName,
      this.email,
      this.phoneNumber,
      this.photoURL,
      this.userType});
  factory UserModal.fromMap(Map<String, dynamic> data, String documentId) {
    if (data != null) {
      return null;
    }
    String uid = data['uid'];
    String displayName = data['displayName'];
    String email = data['email'];
    String phoneNumber = data['phoneNumber'];
    String photoURL = data['photoURL'];
    String userType = data['userType'];

    return UserModal(
        uid: uid,
        displayName: displayName,
        email: email,
        phoneNumber: phoneNumber,
        photoURL: photoURL,
        userType: userType);
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoURL,
      'userType': userType
    };
  }
}
