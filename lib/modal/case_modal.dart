import '../utility.dart';

class CaseModal {
  final String caseId;
  final String ownerId;
  final DateTime postedTime;
  final DateTime lastEditedTime;
  final String caseTitle;
  final String caseDescription;
  final List<String> images;
  final String visibility;
  final String tag;
  final String consent;
  final Map likes;
  final Map<String, dynamic> followers;
  final bool isEdited;

  CaseModal({
    this.caseId,
    this.ownerId,
    this.postedTime,
    this.lastEditedTime,
    this.isEdited,
    this.caseTitle,
    this.caseDescription,
    this.images,
    this.visibility,
    this.tag,
    this.consent,
    this.likes,
    this.followers,
  });

  factory CaseModal.fromDocument(data) {
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
  }

  Map<String, dynamic> toMap() {
    return {
      'caseId': this.caseId,
      'ownerId': this.ownerId,
      'postedTime': this.postedTime,
      'lastEditedTime': this.lastEditedTime,
      'isEdited': this.isEdited,
      'caseTitle': this.caseTitle,
      'caseDescription': this.caseDescription,
      'images': this.images,
      'visibility': this.visibility,
      'tag': this.tag,
      'consent': this.consent,
      'likes': this.likes,
      'followers': this.followers
    };
  }
}
