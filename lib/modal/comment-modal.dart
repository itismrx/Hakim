import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModal {
  final String ownerId;
  final String postOwnerId;
  final String caseId;
  final String commentId;
  final String content;
  final DateTime timestamp;

  CommentModal({
    this.ownerId,
    this.content,
    this.postOwnerId,
    this.commentId,
    this.caseId,
    this.timestamp,
  });

  factory CommentModal.fromDocument(DocumentSnapshot doc) {
    Timestamp time = doc['timestamp'];
    return CommentModal(
        ownerId: doc['ownerId'],
        content: doc['content'],
        postOwnerId: doc['postOwnerId'],
        commentId: doc['commentId'],
        caseId: doc['caseId'],
        timestamp: time.toDate());
  }
  Map<String, dynamic> toMap() {
    return {
      'ownerId': this.ownerId,
      'content': this.content,
      'commentId': this.commentId,
      'caseId': this.caseId,
      'postOwnerId': this.postOwnerId,
      'timestamp': this.timestamp
    };
  }
}
