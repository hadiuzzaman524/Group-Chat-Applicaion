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
  // ignore: deprecated_member_use
  final firestore = Firestore.instance;
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

  getStream() async{
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
    await for(var snapshots in firestore.collection('Messages').snapshots()){
      // ignore: deprecated_member_use
      for(var m in snapshots.documents){
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                /*auth.signOut();
                SystemNavigator.pop();
                showToast('Sign Out and Exit Successfully');*/
                getStream();
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
