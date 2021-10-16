import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import '/modal/case_modal.dart';
import '/modal/comment-modal.dart';
import '/modal/doctor-modal.dart';
import '/modal/notification_modal.dart';
import '/modal/user-modal.dart';
import '/provider/AuthProvider.dart';
import '/provider/DoctorProvider.dart';
import '/services/firestore_path.dart';
import '/services/firestore_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '/utility.dart';

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _firestoreService = FirestoreService.instance;

  Future<types.User> getUser(String userId) async =>
      await _firestoreService.documentFuture(
          path: FireStorePath.user(userId),
          builder: (data) => toUser(data, userId));

  // search(String query) async => await _firestoreService.collectionStream(path: 'cases/', builder: (data)=> CaseModal.fromDocument(data))

  Future<void> follow(String followedUserId) async {
    await _firestoreService.setData(
        path: FireStorePath.follower(uid, followedUserId),
        data: {},
        merge: true);
    await _firestoreService.setData(
        path: FireStorePath.following(uid, followedUserId),
        data: {},
        merge: true);
  }

  Future<void> unfollow(String followedUserId) async {
    await _firestoreService.deleteData(
        path: FireStorePath.follower(uid, followedUserId));
    await _firestoreService.deleteData(
        path: FireStorePath.following(uid, followedUserId));
  }

  Future<void> followCase(CaseModal caseModal) async {
    return await FirebaseFirestore.instance
        .collection('cases')
        .doc(caseModal.ownerId)
        .collection('cases')
        .doc(caseModal.caseId)
        .update({'followers.$uid': true});
  }

  Future<void> deleteCase(CaseModal caseModal) async {
    _firestoreService.deleteData(
        path: FireStorePath.aCase(uid, caseModal.caseId));
  }

  Future<void> deleteComment(CommentModal commentModal) async {
    _firestoreService.deleteData(
      path: FireStorePath.comment(commentModal.caseId, commentModal.commentId),
    );
  }

  Future<void> unFollowCase(CaseModal caseModal) async {
    return await FirebaseFirestore.instance
        .collection('cases')
        .doc(caseModal.ownerId)
        .collection('cases')
        .doc(caseModal.caseId)
        .update({'followers.$uid': false});
  }

  // Future<bool> isFollowingCase(CaseModal caseModal) async {
  //   FirebaseFirestore.instance
  //       .collection('cases')
  //       .doc(caseModal.ownerId)
  //       .collection('cases')
  //       .doc(caseModal.caseId).get()
  //       .update({'followers.$uid': true});
  // }

  Future<bool> isFollowing(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('following')
        .doc(AuthProvider().getCurrentUser().uid)
        .collection('userFollowers')
        .doc(uid)
        .get();
    if (snapshot == null) return false;
    return snapshot.exists;
  }

  Future<int> numberOfFollowers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('followers')
        .doc(this.uid)
        .collection('userFollowers')
        .get();
    if (snapshot.docs == null) return 0;
    if (snapshot.docs.isEmpty) return 0;
    return snapshot.docs.length;
  }

  Future<int> numberOfFollowings() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('following')
        .doc(this.uid)
        .collection('userFollowers')
        .get();
    if (snapshot.docs == null) return 0;
    if (snapshot.docs.isEmpty) return 0;
    return snapshot.docs.length;
  }

  Future<int> numberOfCases() async => await _firestoreService.collectionFuture(
      path: FireStorePath.cases(uid),
      builder: (data) {
        return data.length;
      });

  Stream<QuerySnapshot> featchComment(String postId) {
    return FirebaseFirestore.instance
        .collection('comments')
        .doc(postId)
        .collection('postComments')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<int> numberOfComments(String postId) async =>
      await _firestoreService.collectionFuture(
          path: FireStorePath.comments(postId), builder: (data) => data.length);

  Future<void> setUser(UserModal user) async => await _firestoreService.setData(
      path: FireStorePath.user(uid), data: user.toMap());

  Future<void> setCase(CaseModal caseModal) async =>
      await _firestoreService.setData(
          path: FireStorePath.cases(uid),
          data: caseModal.toMap(),
          merge: false);

  Future<void> addComment(CommentModal commentModal, String postId) async =>
      await _firestoreService.setData(
          path: FireStorePath.comment(
              commentModal.caseId, commentModal.commentId),
          data: commentModal.toMap());

  // Future<void> addCase(CaseModal caseModal) async =>
  //     await _firestoreService.addData(
  //         path: FireStorePath.aCase(
  //           uid,
  //           caseModal.caseId,
  //         ),
  //         data: caseModal.toMap());
  Future<void> addCase(CaseModal caseModal) async {
    return await FirebaseFirestore.instance
        .collection('cases')
        .doc(uid)
        .collection('cases')
        .doc(caseModal.caseId)
        .set(caseModal.toMap());
  }

  Future<void> updateCase(CaseModal caseModal) async {
    return await FirebaseFirestore.instance
        .collection('cases')
        .doc(uid)
        .collection('cases')
        .doc(caseModal.caseId)
        .update(caseModal.toMap());
  }

  Future<void> deleteUser(UserModal user) async {
    await _firestoreService.deleteData(
      path: FireStorePath.user(uid),
    );
  }

  Future<DoctorModal> getADoctor({@required String uid}) async =>
      await _firestoreService.documentFuture(
        path: FireStorePath.doctor(uid),
        builder: (data) => DoctorModal.fromDocument(data),
      );

  // Future<CaseModal> getACase(
  //         {@required String ownerId, @required String caseId}) async =>
  //     await _firestoreService.documentFuture(
  //       path: FireStorePath.aCase(ownerId, caseId),
  //       builder: (data) => CaseModal.fromDocument(data),
  //     );

  Future<CaseModal> getACase({String ownerId, String caseId}) async {
    FirebaseFirestore.instance
        .collection('cases')
        .doc(ownerId)
        .collection('cases')
        .doc(caseId)
        .get()
        .then((value) {
      // CaseModal aCase =
      if (value.exists) {
        print('\n***** ');
        // print(value.data().values);

        // value.data().values.forEach((element) {
        //   print(element);
        // });
        // // print(data['caseId']);
        final data = value.data();
        return CaseModal(
          caseId: data['caseId'],
          ownerId: data['ownerId'],
          postedTime: toDateTime(data['postedTime']),
          lastEditedTime: toDateTime(data['lastEditedTime']),
          isEdited: data['isEdited'],
          caseTitle: data['caseTitle'],
          caseDescription: data['caseDescription'],
          images: data['images'] != null ? data['images'].cast<String>() : [],
          visibility: data['visibility'],
          tag: data['tag'],
          consent: data['consent'],
          likes: data['likes'],
          followers: data['followers'],
        );
        // return CaseModal(caseDescription: data['caseId'],caseId:data['caseId'],
        // { caseId,
        //   ownerId,
        //    postedTime,
        //  lastEditedTime,
        //  isEdited,
        //  caseTitle,
        // String caseDescription,
        //  List<String> images,
        // String visibility,
        //  String tag,
        //  String consent,
        //   Map<dynamic, dynamic>
        //  likes, Map<String, dynamic> followers}
        // );
      }
    });
  }

  Future<UserModal> getAUser({@required String uid}) async =>
      await _firestoreService.documentFuture(
        path: FireStorePath.user(uid),
        builder: (data) => UserModal.fromMap(data, uid),
      );

  Future<void> setDoctor(DoctorModal doctor) async => await _firestoreService
      .setData(path: FireStorePath.doctor(uid), data: doctor.toMap());

  Future<void> setCommentFeed(
      DoctorModal doctorModal, CaseModal caseModal, CommentModal commentModal) {
    FirebaseFirestore.instance
        .collection('feeds')
        .doc(caseModal.ownerId)
        .collection('feedItems')
        .doc(caseModal.caseId)
        .set({
      'type': 'comment',
      'commentData': commentModal.content,
      'userName': doctorModal.userName,
      'uid': doctorModal.uid,
      'userProfileUrl': doctorModal.profilePictureUrl,
      'postId': caseModal.caseId,
      'mediaUrl': caseModal.images ?? "",
      'timestamp': DateTime.now(),
    });
  }

  Future<void> removeFeed(String uid, String nid) async =>
      await _firestoreService.deleteData(path: FireStorePath.feed(uid, nid));

  Future<void> addReport(String postId, String userId, String type) {
    FirebaseFirestore.instance.collection('reports').add({
      'postId': postId,
      'userId': userId,
      'type': type,
      'timestamp': DateTime.now(),
    });
  }

  Future<void> removeChat(String chatId) async =>
      await _firestoreService.deleteData(path: FireStorePath.chat(chatId));

  Future<String> getMessage(String roomId) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();
    if (doc.exists) {
      dynamic msgs = doc.data();
// if(msgs['lastMessages'][0]['type'] == t)
      return msgs['lastMessages'][0]['text'].toString();
      // return msgs.first['lastMessages']['text'];
    }
    return '';
  }
  // }

  Future<void> setFeed(NotificationModal notificationModal) async =>
      notificationModal.postId == null
          ? await _firestoreService.addData(
              path: FireStorePath.feeds(uid), data: notificationModal.toMap())
          : await _firestoreService.setData(
              path: FireStorePath.feed(uid, notificationModal.postId),
              data: notificationModal.toMap());

  Future<void> addFeed(
          {NotificationModal notificationModal, String userId}) async =>
      await _firestoreService.addData(
          path: FireStorePath.feeds(userId), data: notificationModal.toMap());

  Future<void> setCaseFollowFeed(
      DoctorModal doctorModal, CaseModal caseModal, CommentModal commentModal) {
    FirebaseFirestore.instance
        .collection('feeds')
        .doc(caseModal.ownerId)
        .collection('feedItems')
        .doc(caseModal.caseId)
        .set({
      'type': 'CASE-FOLLOW',
      'commentData': commentModal.content,
      'userName': doctorModal.userName,
      'uid': doctorModal.uid,
      'userProfileUrl': doctorModal.profilePictureUrl,
      'postId': caseModal.caseId,
      'mediaUrl': caseModal.images ?? "",
      'timestamp': DateTime.now(),
    });
  }

  Future<void> setUserFollower(DoctorModal doctorModal) {
    FirebaseFirestore.instance
        .collection('feeds')
        .doc(doctorModal.uid)
        .collection('feedItems')
        .doc(uid)
        .set({
      'type': 'CASE-FOLLOW',
      'userName': doctorModal.userName,
      'uid': doctorModal.uid,
      'userProfileUrl': doctorModal.profilePictureUrl,
      'timestamp': DateTime.now(),
    });
  }

  Stream<DoctorModal> doctorStream({@required String uid}) =>
      _firestoreService.documentStream(
          path: FireStorePath.doctor(uid),
          builder: (data, documentId) => DoctorModal.fromDocument(data));

  Stream<List<NotificationModal>> notificationStream(String uid) =>
      _firestoreService.collectionStream(
          path: FireStorePath.feeds(uid),
          builder: (data, documentId) => NotificationModal.fromDocument(data));

  Stream<List<CaseModal>> casesStream(String uid) =>
      _firestoreService.collectionStream(
          path: FireStorePath.cases(uid),
          builder: (data, documentId) => CaseModal.fromDocument(data));
  Stream<List<CaseModal>> casesFeedStream(String uid) =>
      _firestoreService.collectionStream(
          path: FireStorePath.timeline(uid),
          builder: (data, documentId) => CaseModal.fromDocument(data));

  Stream<List<CaseModal>> feedStream(String uid) =>
      _firestoreService.collectionStream(
          path: FireStorePath.cases(uid),
          builder: (data, documentId) => CaseModal.fromDocument(data));

  Stream<List<DoctorModal>> doctorsStream() =>
      _firestoreService.collectionStream(
          path: FireStorePath.doctor(uid),
          builder: (data, documentId) => DoctorModal.fromMap(data));
}
