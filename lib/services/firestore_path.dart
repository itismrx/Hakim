class FireStorePath {
  static String chat(String roomId) => 'rooms/$roomId/';

  static String user(String uid) => 'users/$uid';

  static String doctor(String uid) => 'doctors/$uid';

  static String doctors(String uid) => 'doctors';

  static String followers(String currentUid) =>
      'followers/$currentUid/userFollowers';

  static String followings(String currentUid) =>
      'following/$currentUid/userFollowers';

  static String follower(String currentUid, String followedUserId) =>
      'followers/$followedUserId/userFollowers/$currentUid';

  static String following(String currentUid, String followedUserId) =>
      'following/$currentUid/userFollowers/$followedUserId';

  static String cases(String uid) => 'cases/$uid/cases';
  static String timeline(String uid) => 'timeline/$uid/timelinePosts';

  static String aCase(String uid, String caseId) => 'cases/$uid/cases/$caseId';

  static String comments(String postId) => 'comments/$postId/postComments/';

  static String comment(String postId, String commentId) =>
      'comments/$postId/postComments/$commentId';

  static String feed(String ownerId, String notificationId) =>
      'feeds/$ownerId/feedItems/$notificationId/';

  static String feeds(String uid) => 'feeds/$uid/feedItems';
}
