import 'package:cloud_firestore/cloud_firestore.dart';
import '../utility.dart';

enum NotificationType {
  CaseFollowing,
  UserFollowing,
  Comment,
}

class NotificationModal {
  final NotificationType type;
  final String userName;
  final String uid;
  final String userProfileUrl;
  final String postId;
  final String mediaUrl;
  final String commentData;
  final DateTime timestamp;

  NotificationModal({
    this.type,
    this.userName,
    this.uid,
    this.userProfileUrl,
    this.postId,
    this.mediaUrl,
    this.commentData,
    this.timestamp,
  });

  factory NotificationModal.fromDocument(data) {
    /*  print('\n\n');
    print(
      NotificationType.UserFollowing ==
          NotificationType.values.firstWhere(
              (e) => e.toString() == 'NotificationType.' + data['type']),
    );
    print(data['type']);
    print(data['userName']);
    print('Comment Data:');
    print(data['commentData'] ?? "");
    print(data['mediaUrl']);
    print(data['postId']);
    print(data['userProfileUrl']);
    print(data['timestamp']);
    print(data['uid']);
    print('\n\n');
    // Timestamp timestamp =;*/
    if (data == null) return null;
    NotificationModal notificationModal = NotificationModal(
        type: NotificationType.values.firstWhere(
            (e) => e.toString() == 'NotificationType.' + data['type']),
        userName: data['userName'],
        uid: data['uid'],
        userProfileUrl: data['userProfileUrl'],
        mediaUrl: data['mediaUrl'],
        commentData: data['commentData'],
        postId: data['postId'],
        timestamp: toDateTime(data['timestamp']));
    // print('\nAfter Initialization');
    // print(notificationModal.commentData);
    // print(notificationModal.userName);
    return notificationModal;
  }

  factory NotificationModal.fromMap(data) {
    if (data == null) return null;
    NotificationModal notificationModal = NotificationModal(
        type: data['type'],
        userName: data['userName'],
        uid: data['uid'],
        userProfileUrl: data['userProfileUrl'],
        mediaUrl: data['mediaUrl'],
        commentData: data['commentData'],
        postId: data['postId'],
        timestamp: data['timestamp']);
    return notificationModal;
  }

  Map<String, dynamic> toMap() {
    // print('>>\n to map is called\n');
    return {
      'type': this.type.toString().split('.').last,
      'userName': this.userName,
      'uid': this.uid,
      'userProfileUrl': this.userProfileUrl,
      'mediaUrl': this.mediaUrl,
      'commentData': this.commentData,
      'postId': this.postId,
      'timestamp': this.timestamp,
    };
  }
}
