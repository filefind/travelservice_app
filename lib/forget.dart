import 'package:flutter/material.dart';
import 'package:travel/main.dart';

void main() {
  runApp(MaterialApp(
    home: Forget(),
  ));
}

class Forget extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Forget> {
//  TextEditingController nameController = TextEditingController();
//  TextEditingController passwordController = TextEditingController();
//  TextEditingController passwordControllerRepeat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Send password'),
          backgroundColor: getColorFromHex("#d14d5e"),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                name,
//                Container(
//                    alignment: Alignment.center,
//                    padding: EdgeInsets.all(10),
//                    child: Text(
//                      'Restore password',
//                      style: TextStyle(fontSize: 20),
//                    )),
                email,
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: getColorFromHex("#d14d5e"),
                      child: Text('Send'),
                      onPressed: () {
//                        print(nameController.text);
//                        print(passwordController.text);
                      },
                    )),
                Container(
                    child: Row(
                      children: <Widget>[
//                        Text('Does not have account?'),
                        FlatButton(
                          textColor: getColorFromHex("#d14d5e"),
                          child: Text(
                            'close',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            )));
  }
}
