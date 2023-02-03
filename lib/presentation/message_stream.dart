import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'message_bubble.dart';

class MessageStream extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String appointmentId;

  MessageStream({required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('appointments/${appointmentId}/messages')
          .orderBy('messageTimeStamp').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: const Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.none) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];
          final messageTimeStamp = message.data()['messageTimeStamp'].toDate();
          String formattedTime = DateFormat.jm().format(messageTimeStamp);

          final currentUser = _auth.currentUser!.uid;

          final messageBubble = MessageBubble(
            text: messageText,
            isMe: currentUser == messageSender,
            timeStamp: formattedTime,
            // timeStamp: TimeOfDay(minute: messageTimeStamp.minute,hour: messageTimeStamp.hour),
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}