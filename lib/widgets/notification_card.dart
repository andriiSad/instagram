import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:intl/intl.dart';

enum NotificationTypes {
  follow,
  likePost,
  likeComment,
}

class NotificationCard extends StatelessWidget {
  NotificationCard({
    super.key,
    required this.snap,
  });
  final QueryDocumentSnapshot<Map<String, dynamic>> snap;
  late final NotificationTypes notificationType;

  void setNotificationType() {
    switch (snap['notificationType']) {
      case 'follow':
        notificationType = NotificationTypes.follow;
        break;
      case 'likePost':
        notificationType = NotificationTypes.likePost;
        break;
      case 'likeComment':
        notificationType = NotificationTypes.likeComment;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    setNotificationType();
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                snap['profImage'],
              ),
              radius: 22,
            ),
          ),
          Text(
            snap['username'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          if (notificationType == NotificationTypes.follow)
            const Text(" started following you."),
          if (notificationType == NotificationTypes.likePost)
            const Text(" liked your post."),
          if (notificationType == NotificationTypes.likeComment)
            const Text(" liked your comment."),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1674632633951-34a050fc0b95?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=400&q=60',
                    ),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                DateFormat.yMMMd().format(snap['datePublished'].toDate()),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 12,
                  color: secondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
