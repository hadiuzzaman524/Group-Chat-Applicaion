import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'chat.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'constants.dart';

class Registration extends StatefulWidget {
  static const String id = 'registration_page';

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String email;

  String password;

  final auth = FirebaseAuth.instance;

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
                    'Registration',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  MyTextField(
                    textHint: 'Your email',
                    onChange: (value) {
                      email = value;
                      print(email);
                    },
                    flag: false,
                  ),
                  MyTextField(
                    textHint: 'Password',
                    onChange: (value) {
                      password = value;
                      print(password);
                    },
                    flag: true,
                  ),
                  ButtonDesign(
                    title: 'Register',
                    onClick: () async {
                      setState(() {
                        showProgress=true;
                      });

                      try {
                        final newUser = await auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, Chat.id);
                          setState(() {
                            showProgress=false;
                          });
                        }
                      } catch (e) {
                        print(e);
                        print('log in fail');
                        setState(() {
                          showProgress=false;
                          showToast('Registration Failed!');
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
