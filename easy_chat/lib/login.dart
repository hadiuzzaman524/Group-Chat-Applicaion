import 'package:easy_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'button.dart';
import 'chat.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  static const String id = 'login_page';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth auth=FirebaseAuth.instance;

  String email;

  String password;

  bool showProgress=false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showProgress,
        child: Scaffold(
          body: ListView(
            children: [
              SizedBox(
                height: 100.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Image.asset('images/b.png'),
                    ),
                    tag: 'icon',
                  ),
                  Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  MyTextField(
                    textHint: 'Your email',
                    onChange: (value) {
                      email=value;
                    },
                    flag: false,
                  ),
                  MyTextField(
                    textHint: 'Password',
                    onChange: (value) {
                      password=value;
                    },
                    flag: true,
                  ),
                  ButtonDesign(
                    title: 'Log In',
                    onClick: () async{
                      setState(() {
                        showProgress=true;
                      });
                      try {
                        final newUser = await auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if(newUser!=null){
                          Navigator.pushNamed(context, Chat.id);
                          setState(() {
                            showProgress=false;
                          });
                        }

                      }catch(e){
                        print(e);
                        setState(() {
                          showProgress=false;
                          showToast('Login Failed!');
                        });

                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
