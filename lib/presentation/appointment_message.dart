import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meni_medical/presentation/message_stream.dart';

import '../components/constant.dart';
class AppointmentMessage extends StatelessWidget {
  final messageTextController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? messageText;
  String appointmentId;


  AppointmentMessage({required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('Message',style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {
            
          }, icon: Icon(Icons.more_vert,color: Colors.black,))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MessageStream(appointmentId: appointmentId,),
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:  Border.all(
                  color: MyConstant.mainColor
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    onChanged: (value) {
                      messageText = value;
                    },
                    keyboardType: TextInputType.multiline,
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    messageTextController.clear();
                    _firestore.collection('appointments/${appointmentId}/messages').add({
                      'text': messageText,
                      'sender': _auth.currentUser!.uid,
                      'messageTimeStamp' : DateTime.now()
                    });
                  },
                  child: Icon(Icons.send,color: MyConstant.mainColor,)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
