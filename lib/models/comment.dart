import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  Comment({
    required this.username,
    required this.uid,
    required this.profImage,
    required this.postId,
    required this.commentId,
    required this.commentText,
    required this.datePublished,
    required this.likes,
  });

  final String username;
  final String uid;
  final String postId;
  final String profImage;
  final String commentId;
  final String commentText;
  final DateTime datePublished;
  final List<String> likes;

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'postId': postId,
        'profImage': profImage,
        'commentId': commentId,
        'commentText': commentText,
        'datePublished': datePublished,
        'likes': likes,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      username: snapshot['username'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      profImage: snapshot['profImage'],
      commentId: snapshot['commentId'],
      commentText: snapshot['commentText'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
    );
  }
}
