import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram/utils/colors.dart';

import '../utils/global_variables.dart';
import '../widgets/post_card.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    super.key,
    required this.postId,
  });
  final String postId;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('postId', isEqualTo: widget.postId)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal:
                  deviceSize.width > webScreenSize ? deviceSize.width * 0.3 : 0,
              vertical: deviceSize.width > webScreenSize ? 15 : 0,
            ),
            child: PostCard(
              snap: snapshot.data!.docs[0],
            ),
          );
        },
      ),
    );
  }
}
