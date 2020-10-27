import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User logInUser;
var userEmail;

class Chat extends StatefulWidget {
  static const id = 'chat_page';

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // ignore: deprecated_member_use
  final firestore = Firestore.instance;

  String userMessage;
  bool isMe;


  /*
  TextEditingController can be used in clear the textField
   */
  TextEditingController textEditingController = TextEditingController();

  getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        logInUser = user;
      }
    } catch (e) {
      print(e);
    }

    userEmail = logInUser.email;
  }

  /*
  Retrieve data from cloud fire store.
   */
  /* getMessage() async{
    // ignore: deprecated_member_use
    final messages=await firestore.collection('Messages').getDocuments();
    // ignore: deprecated_member_use
    for(var m in messages.documents){
      print(m.data());
    }
  }*/

  getStream() async {
    /*
    snapshots() method return a Stream , it help us to see message immediately,
    when any text or data push in storage at a time Snapshots notify us , but previous
    getMessage() method can not notify immediately this method need every time
    refresh our app....
    More about Stream:-
    Future return e future object just for singular form , more clearly it return a single item
    we wait for single pieces of data or object, But in Stream it works a List of data or object
    at a time it return previous data and also return newly inserted or update data without refresh
    our main app.
     */
    await for (var snapshots in firestore.collection('Messages').snapshots()) {
      // ignore: deprecated_member_use
      for (var m in snapshots.documents) {
        print(m.data());
      }
    }
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
        backgroundColor: Colors.cyan,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                auth.signOut();
                SystemNavigator.pop();
                showToast('Sign Out and Exit Successfully');
               // getStream();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilderInfo(firestore: firestore),
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: TextField(
                    controller: textEditingController,
                    scrollPadding: EdgeInsets.zero,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type your message here',
                      filled: true,
                      fillColor: Color(0xFFEDEDED),
                      contentPadding: EdgeInsets.only(
                          top: 0, bottom: 0, left: 10, right: 0.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      userMessage = value;
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      textEditingController.clear();
                      // print(userMessage);
                      firestore.collection('Messages').add({
                        'sender': logInUser.email,
                        'information': userMessage,
                      });
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

class StreamBuilderInfo extends StatelessWidget {
  const StreamBuilderInfo({
    @required this.firestore,
  });

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      /*
      snapshots return a stream
       */
      stream: firestore.collection('Messages').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // ignore: deprecated_member_use
          List<MessageStyle> textWidgets = [];
          // ignore: deprecated_member_use
          final messages = snapshot.data.documents.reversed;
          for (var msg in messages) {
            final sender = msg['sender'];
            final textMsg = msg['information'];

            bool flag=false;
           if(sender==userEmail){
              flag=true;
            }
          print(userEmail);
            final text = MessageStyle(
              sender: sender,
              textMsg: textMsg,
              isMe: flag,//sender == logInUser.email,
            );
            textWidgets.add(text);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              children: textWidgets,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
      },
    );
  }
}

class MessageStyle extends StatelessWidget {
  MessageStyle({
    @required this.sender,
    @required this.textMsg,
    @required this.isMe,
  });

  final sender;
  final textMsg;
  final isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment:isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Text(
              '$sender',
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.black54,
              ),
            ),
          ),
          Material(
            borderRadius:isMe? BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ):BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe?Colors.cyan:Color(0xFFEDEDED),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                '$textMsg',
                style: TextStyle(
                  fontSize: 16,
                  color:isMe? Colors.white:Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
