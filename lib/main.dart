import 'package:flutter/material.dart';
import 'package:game_release/home.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  runApp(MaterialApp(
    home: Splash(),
    theme: ThemeData(
          brightness: Brightness.dark,
    primaryColor: Colors.red,
    accentColor: Color.fromRGBO(80, 193, 255, 1),
    ),
  ));
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: new Home(false),
      title: new Text(
        'Game Release',
        style: new TextStyle(
            fontWeight: FontWeight.bold, fontSize: 40.0, color: Colors.white),
      ),
      image: Image(image: AssetImage('assets/iconsplash.png')),
      //image: new Image.network('https://www.shareicon.net/data/2015/11/22/178424_game_256x256.png'),
      backgroundColor: Color.fromRGBO(26, 26, 26, 1),
      photoSize: 100.0,
      onClick: () => print("Flutter Egypt"),
      loaderColor: Color.fromRGBO(0, 0, 0, 0),
    );
  }
}
