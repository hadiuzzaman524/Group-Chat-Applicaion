import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'constants.dart';

class Chat extends StatefulWidget {
  static const id = 'chat_page';

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User logInUser;

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
              onTap: (){
                auth.signOut();
                SystemNavigator.pop();
                showToast('Sign Out and Exit Successfully');
              },
              child: Icon(Icons.backspace,
              color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [],
        ),
      ),
    ));
  }
}
