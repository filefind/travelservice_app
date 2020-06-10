import 'package:flutter/material.dart';
import 'package:travel/main.dart';
import 'forget.dart';

void main() {
  runApp(MaterialApp(
    home: SignInApp(),
  ));
}

class SignInApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');

  if (hexColor.length == 6) {
    hexColor = 'FF' + hexColor;
  }

  return Color(int.parse(hexColor, radix: 16));
}

class _State extends State<SignInApp> {
//  TextEditingController nameController = TextEditingController();
//  TextEditingController passwordController = TextEditingController();
//  TextEditingController passwordControllerRepeat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
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
//                      'Register',
//                      style: TextStyle(fontSize: 20),
//                    )),
                email,
                password,
                Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Repeat Password',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: getColorFromHex("#d14d5e"),
                      child: Text('Register'),
                      onPressed: () {
//                        print(nameController.text);
//                        print(passwordController.text);
                      },
                    )),
                FlatButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            Forget()
                        ));
                  },
                  textColor: getColorFromHex("#d14d5e"),
                  child: Text('Forgot Password'),
                ),
                Container(
                    child: Row(
                      children: <Widget>[
//                        Text('Does not have account?'),
                        FlatButton(
                          textColor: getColorFromHex("#d14d5e"),
                          child: Text(
                            'Login',
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