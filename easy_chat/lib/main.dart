import 'package:easy_chat/chat.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  /*
  in new firebase there new required is to initialize firebase service
  to our app. that's why add this two line in our main function.
   */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String initPage;
  final FirebaseAuth auth=FirebaseAuth.instance;
  User currentUser;

  @override
  void initState() {
    super.initState();
    try {
      currentUser = auth.currentUser;
      if(currentUser!=null){
        initPage=Chat.id;
      }
      else{
        initPage=Home.id;
      }
    }
    catch(e){
      print(e);
      initPage=Home.id;
    }

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*
      make every class has static keyword id thats why we
      directly used id using class name..
       */

      debugShowCheckedModeBanner: false,
      initialRoute: initPage,
      routes: {
        Home.id: (context) => Home(),
        Login.id: (context) => Login(),
        Registration.id: (context) => Registration(),
        Chat.id: (context) => Chat(),
      },
    );
  }
}
