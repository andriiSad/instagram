import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final User user = Provider.of<UserProvider>(
      context,
      listen: false,
    ).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: deviceSize.width > webScreenSize
            ? webBackgroundColor
            : mobileBackgroundColor,
        centerTitle: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text('Notifications'),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('notifications')
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
            itemBuilder: (context, index) =>
                NotificationCard(snap: snapshot.data!.docs[index]),
          );
        },
      ),
    );
  }
}
