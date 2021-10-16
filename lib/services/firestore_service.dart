import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData(
      {@required String path,
      @required Map<String, dynamic> data,
      bool merge = false}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data, SetOptions(merge: true));
  }

  Future<void> addData(
      {@required String path,
      @required Map<String, dynamic> data,
      bool merge = false}) async {
    //parm : path is to the collection
    final reference = FirebaseFirestore.instance.collection(path);
    await reference.add(data);
  }

  Future<void> deleteData({@required String path}) async {
    FirebaseFirestore.instance.doc(path).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  Stream<List<T>> collectionFeedStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    Query query = FirebaseFirestore.instance
        .collection(path)
        .orderBy('postedTime', descending: true);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();

    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();

    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Future<T> collectionFuture<T>({
    @required String path,
    @required T builder(List<dynamic> data),
  }) async {
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection(path).get();
    return builder(data.docs);
  }

  Future<T> documentFuture<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
  }) async {
    DocumentSnapshot data = await FirebaseFirestore.instance.doc(path).get();
    return builder(data.data());
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }
}
