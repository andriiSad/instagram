import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.snap,
  });
  final QueryDocumentSnapshot<Map<String, dynamic>> snap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                snap['profImage'],
              ),
              radius: 26,
            ),
          ),
          Text(
            snap['username'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Text(" started ${snap['notificationType']} you."),
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
