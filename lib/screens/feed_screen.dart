import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_variables.dart';

import '../widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: deviceSize.width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: deviceSize.width > webScreenSize
                  ? webBackgroundColor
                  : mobileBackgroundColor,
              centerTitle: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  height: 32,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.messenger_sharp),
                )
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy("datePublished", descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: deviceSize.width > webScreenSize
                    ? deviceSize.width * 0.3
                    : 0,
                vertical: deviceSize.width > webScreenSize ? 15 : 0,
              ),
              child: PostCard(
                snap: snapshot.data!.docs[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
