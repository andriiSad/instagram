import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/comment.dart';
import 'package:instagram/models/notification.dart' as model;
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost({
    required String description,
    required Uint8List file,
    required String uid,
    required String username,
    required String profImage,
  }) async {
    String res = "Some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost({
    required String postId,
    required String uid,
    required List likes,
  }) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        final postOwnerUser =
            await _firestore.collection('posts').doc(postId).get();
        final postOwnerId = postOwnerUser['uid'];
        if (postOwnerId != uid) {
          final postLikingUser =
              await _firestore.collection('users').doc(uid).get();

          String notificationId = const Uuid().v1();
          model.Notification notification = model.Notification(
            username: postLikingUser['username'],
            uid: uid,
            notificationType: 'likePost',
            datePublished: DateTime.now(),
            profImage: postLikingUser['photoUrl'],
            postId: postId,
          );
          await _firestore
              .collection('users')
              .doc(postOwnerId)
              .collection('notifications')
              .doc(notificationId)
              .set(notification.toJson());
        }

        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      //TODO change to res approach
      print(e.toString());
    }
  }

  Future<String> uploadComment({
    required String username,
    required String uid,
    required String profImage,
    required String commentText,
    required String postId,
  }) async {
    String res = "Some error occured";
    try {
      if (commentText.trim().isNotEmpty) {
        String commentId = const Uuid().v1();

        Comment comment = Comment(
          username: username,
          uid: uid,
          postId: postId,
          profImage: profImage,
          commentId: commentId,
          commentText: commentText,
          datePublished: DateTime.now(),
          likes: [],
        );
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(comment.toJson());
        res = 'success';
      } else {
        res = 'Cant upload empty comment';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likeComment({
    required String postId,
    required String commentId,
    required String uid,
    required List likes,
  }) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      //TODO change to res approach
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      //TODO change to res approach
      print(e.toString());
    }
  }

//TODO change function parameters naming, fill notification with real data
  Future<void> followUser({
    required String sourceUserid,
    required String sourceUsername,
    required String sourceUserProfImage,
    required String targetUserId,
  }) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(sourceUserid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(targetUserId)) {
        await _firestore.collection('users').doc(sourceUserid).update({
          'following': FieldValue.arrayRemove([targetUserId]),
        });
        await _firestore.collection('users').doc(targetUserId).update({
          'followers': FieldValue.arrayRemove([sourceUserid]),
        });
      } else {
        // create a notification
        String notificationId = const Uuid().v1();

        model.Notification notification = model.Notification(
          username: sourceUsername,
          uid: sourceUserid,
          notificationType: 'follow',
          datePublished: DateTime.now(),
          profImage: sourceUserProfImage,
          postId: '',
        );
        await _firestore
            .collection('users')
            .doc(targetUserId)
            .collection('notifications')
            .doc(notificationId)
            .set(notification.toJson());
        await _firestore.collection('users').doc(sourceUserid).update({
          'following': FieldValue.arrayUnion([targetUserId]),
        });
        await _firestore.collection('users').doc(targetUserId).update({
          'followers': FieldValue.arrayUnion([sourceUserid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
