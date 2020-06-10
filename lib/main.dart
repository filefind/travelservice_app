import 'package:flutter/material.dart';
import 'sign-in.dart';
import 'forget.dart';
import 'home.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
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
final Container name = Container(
    alignment: Alignment.center,
    padding: EdgeInsets.all(10),
    child: Text(
      'Travel',
      style: TextStyle(
          color: getColorFromHex("#d14d5e"),
          fontWeight: FontWeight.w500,
          fontSize: 30),
    ));
final  Container email = Container(
  padding: EdgeInsets.all(10),
  child: TextField(
    controller: TextEditingController(),
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'E-mail',
    ),
  ),
);
final Container password = Container(
  padding: EdgeInsets.all(10),
  child: TextField(
    obscureText: true,
    controller: TextEditingController(),
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Password',
    ),
  ),
);


class _State extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: AppBar(
//          title: Text('Sample App'),
//          backgroundColor: getColorFromHex("#d14d5e"),
//        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                name,
//                Container(
//                    alignment: Alignment.center,
//                    padding: EdgeInsets.all(10),
//                    child: Text(
//                      'Sign in',
//                      style: TextStyle(fontSize: 20),
//                    )),
                email,
                password,
                Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: getColorFromHex("#d14d5e"),
                      child: Text('Login'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                TabLayout())
                        );
//                        print(nameController.text);
//                        print(passwordController.text);
                      },
                    ),
                ),
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
                            'Sign in',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    SignInApp()
                                ));
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            )));
  }
}