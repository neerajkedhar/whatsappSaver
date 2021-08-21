import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger extends StatefulWidget {
  Widget Function(BuildContext context, Brightness brightness)? builder;
  ThemeChanger({this.builder});

  @override
  _ThemeChangerState createState() => _ThemeChangerState();

  static _ThemeChangerState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ThemeChangerState>();
  }
}

class _ThemeChangerState extends State<ThemeChanger> {
  Brightness _brightness = Brightness.dark;
  final String key = "Theme";
  SharedPreferences? prefs;
  bool darkTheme = true;
  @override
  void initState() {
    super.initState();
    loadFromPrefs();
    // if (darkTheme) {
    //   _brightness = Brightness.dark;
    // }
  }

  initPrefs() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
  }

  loadFromPrefs() async {
    await initPrefs();
    darkTheme = prefs!.getBool(key) ?? true;
    if (prefs!.containsKey("Theme")) {}

    if (darkTheme) {
      setState(() {
        _brightness = Brightness.dark;
      });
    } else {
      setState(() {
        _brightness = Brightness.light;
      });
    }
  }

  saveToPrefs(bool val) async {
    await initPrefs();
    prefs!.setBool(key, val);
  }

  void changeTheme() {
    darkTheme = !darkTheme;

    saveToPrefs(darkTheme);
    setState(() {
      _brightness =
          _brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder!(context, _brightness);
  }
}
