import 'dart:async';
import 'package:rive/rive.dart';
import 'package:neon/neon.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:flutter/services.dart';
void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neoflut',
      theme: ThemeData(
        fontFamily: 'Overlock-Regular',
      ),
      debugShowCheckedModeBanner: false,
      home: const Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 5),
          () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.black,
        body:
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),

                      Neon(
                        text: 'NEOFLUT',
                        color: Colors.pink,
                        fontSize: 35,
                        font: NeonFont.Membra,
                        flickeringText: true,
                      ),
                const SizedBox(
                  height: 10,
                ),
                      Neon(
                        text: '1024',
                        color: Colors.pink,
                        fontSize: 25,
                        font: NeonFont.Membra,
                        flickeringText: true,
                      ),
               const SizedBox(
                  height: 25,
                ),
      Container(
        height:300,
        width:300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(6.0),
        ),
               child:  Container(
                 padding: const EdgeInsets.all(1),
                  child:const RiveAnimation.asset('gifrive/car.riv'),
                ),),
              ],
            ),
          );
  }

}