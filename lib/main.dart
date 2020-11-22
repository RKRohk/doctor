import 'package:doctor/constants.dart';
import 'package:doctor/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv().load(".env");
  await Firebase.initializeApp();
  runApp(MaterialApp(home: Splash()));
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        navigateAfterSeconds: HomePage(),
        image: new Image.asset('assets/images/splash_screen.png'),
        backgroundColor: kPrimaryColour,
        seconds: 5,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 200.0,
        loaderColor: Colors.orange);
  }
}
