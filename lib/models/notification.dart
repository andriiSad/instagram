import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  Notification({
    required this.uid,
    required this.username,
    required this.datePublished,
    required this.profImage,
    required this.notificationType,
  });

  final String uid;
  final String username;
  final DateTime datePublished;
  final String profImage;
  final String notificationType;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'datePublished': datePublished,
        'profImage': profImage,
        'notificationType': notificationType,
      };

  static Notification fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Notification(
      uid: snapshot['uid'],
      username: snapshot['username'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      notificationType: snapshot['notificationType'],
    );
  }
}
