import 'package:flutter/material.dart';

class ButtonDesign extends StatelessWidget {
  ButtonDesign({@required this.title, @required this.onClick});

  final String title;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        margin: EdgeInsets.all(10.0),
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String textHint;
  final Function onChange;
  final flag;

  MyTextField({@required this.textHint, @required this.onChange,this.flag});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextField(
        textAlign: TextAlign.center,
        style: TextStyle(),
        onChanged: onChange,
        obscureText: flag,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: textHint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
        ),
      ),
    );
  }
}
