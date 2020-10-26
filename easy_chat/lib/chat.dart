
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat extends StatefulWidget {
  static const id = 'chat_page';

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestore=Firestore.instance;
  User logInUser;
  String userMessage;

  getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        logInUser = user;
      }
    } catch (e) {
      print(e);
    }

    print(logInUser.email);
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                auth.signOut();
                SystemNavigator.pop();
                showToast('Sign Out and Exit Successfully');
              },
              child: Icon(
                Icons.backspace,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: TextField(
                    scrollPadding: EdgeInsets.zero,
                    textAlign:TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type your message here',
                      filled: true,
                      fillColor: Color(0xFFEDEDED),
                      contentPadding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 0.0),
                      border:OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),

                      ),
                    ),
                    onChanged: (value){
                      userMessage=value;
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                     // print(userMessage);
                      firestore.collection('Messages').add(
                        {
                          'sender':logInUser.email,
                          'information':userMessage,
                        }
                      );
                    },
                    child: Icon(
                      Icons.send_sharp,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
