import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:status_saver_ws/homePage.dart';
import 'package:status_saver_ws/themeChanger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.initialize();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return ThemeChanger(builder: (context, _brightness) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            brightness: _brightness,
            primarySwatch: Colors.green,
          ),
          home: FutureBuilder(
              future: _fbApp,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return CircularProgressIndicator(); //HomePage();
                } else if (snapshot.hasData) {
                  return HomePage();
                } else {
                  return HomePage();
                }
              }));
    });
  }
}
