import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  Comment({
    required this.username,
    required this.postId,
    required this.uid,
    required this.profImage,
    required this.commentId,
    required this.commentText,
    required this.datePublished,
    required this.likes,
  });

  final String username;
  final String postId;
  final String uid;
  final String profImage;
  final String commentId;
  final String commentText;
  final datePublished;
  final likes;

  Map<String, dynamic> toJson() => {
        'username': username,
        'postId': postId,
        'uid': uid,
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
      postId: snapshot['postId'],
      uid: snapshot['uid'],
      profImage: snapshot['profImage'],
      commentId: snapshot['commentId'],
      commentText: snapshot['commentText'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
    );
  }
}
