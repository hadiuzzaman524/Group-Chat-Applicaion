import 'package:easy_chat/registration.dart';
import 'package:flutter/material.dart';
import 'button.dart';
import 'login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class Home extends StatefulWidget {
  static const String id = 'home_page';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  AnimationController animationController;
  Animation animation;


  @override
  void initState() {
    super.initState();

    animationController=AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    animationController.addListener(() {
      print(animationController.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFEDEDED),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    child: Container(
                      height: 90,
                      width: 90,
                      child: Image.asset('images/messenger.png'),
                    ),
                    tag: 'icon',
                  ),
                  TypewriterAnimatedTextKit(
                   text:['Easy Chat'],
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontFamily: 'Pacifico',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  ButtonDesign(
                    title: 'Log In',
                    onClick: () {
                    Navigator.pushNamed(context, Login.id);
                    },
                  ),
                  ButtonDesign(
                    title: 'Registration',
                    onClick: () {
                      Navigator.pushNamed(context, Registration.id);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                'Powered By Hadi',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Pacifico',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
