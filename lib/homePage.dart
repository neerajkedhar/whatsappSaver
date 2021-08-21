import 'dart:io';
import 'dart:ui';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:share/share.dart';
import 'package:status_saver_ws/Screens/aboutUs.dart';
import 'package:status_saver_ws/Screens/downloadsScreen.dart';
import 'package:status_saver_ws/Screens/homeScreen.dart';
import 'package:status_saver_ws/colors.dart';
import 'package:status_saver_ws/icons/icons_new.dart';
import 'package:status_saver_ws/themeChanger.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  NotificationAppLaunchDetails? notificationAppLaunchDetails;

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Directory _photoDir = Directory(
      "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses");
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  String _url =
      "https://play.google.com/store/apps/details?id=com.kedhar.status_saver_ws";
  var samurl =
      "https://apps.samsung.com/appquery/AppRating.as?appId=com.kedhar.status_saver_ws";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void _launchURL() async => await canLaunch(samurl)
      ? await launch(samurl)
      : throw 'Could not launch $samurl';
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late TabController controller;
  double value = 0.0;
  final Color prime = Color(0xff15191d);
  int activeTabIndex = 1;

  ColorsClass colors = new ColorsClass();
  Color accent = ColorsClass.green;
  Color primery = ColorsClass.primeDark;
  Color secondry = ColorsClass.secondryDark;
  late Color textColor;
  Future<void> _sendAnalyticsEvent(String msg) async {
    await analytics.logEvent(
      name: 'test_event_$msg',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    );
    print("logged msg as: $msg");
  }

  ccc() async {
    if (_photoDir.existsSync()) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      print(appDocPath);
      print("modddaaaaallluuuu");
      List<FileSystemEntity> imageList = _photoDir.listSync();
      // for (FileSystemEntity files in imageList) {
      //   FileStat fi = files.statSync();
      //   print("yooo${fi.toString()}");
      // }
      // // .map((item) => item.path)
      // // .where((item) => item.endsWith('.jpg') || item.endsWith('.mp4'))
      // // .toList(growable: false);

      if (await File("$_photoDir/ggg.jpg").exists()) {
        print("yowza");
      } else {
        print("nope");
      }
      print(imageList.length);
    }
  }

  checkIfPermissionIsGiven() async {
    final result = await Permission.storage.status;
    if (result == PermissionStatus.denied) {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        print("yessss");
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (status.isDenied) {
        final snackBar = SnackBar(
          content: Text('permission Denied'),
          duration: Duration(milliseconds: 1000),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (status.isPermanentlyDenied) {
        final snackBar = SnackBar(
          content: Text(
              'permission is permanently Denied, go to setting to give Permission'),
          duration: Duration(milliseconds: 1000),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else if (result == PermissionStatus.permanentlyDenied) {
      final snackBar = SnackBar(
        content: Text(
            'permission is permanently Denied, go to setting to give Permission'),
        duration: Duration(milliseconds: 1000),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return result;
    }
  }

  var locations;
  @override
  void initState() {
    checkIfPermissionIsGiven();
    super.initState();
    tz.initializeTimeZones();
    locations = tz.timeZoneDatabase.locations;
    initiate();
    scheduleAlarm();

    controller = TabController(
      length: 2,
      initialIndex: 1,
      vsync: this,
    );
    controller.addListener(() {
      setState(() {
        activeTabIndex = controller.index;
      });
    });
    // scheduledNotification();
  }

  noti() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  bool? some;
  @override
  Widget build(BuildContext context) {
    if (widget.didNotificationLaunchApp) {
      _sendAnalyticsEvent("Opened_app_on_Notification");
    }
    bool themeIsDark = Theme.of(context).brightness == Brightness.dark;
    primery = Theme.of(context).brightness == Brightness.dark
        ? ColorsClass.primeDark
        : ColorsClass.primeWhite;
    secondry = Theme.of(context).brightness == Brightness.dark
        ? ColorsClass.secondryDark
        : ColorsClass.secondryWhite;
    textColor = themeIsDark ? ColorsClass.icon : Colors.grey;
    some = themeIsDark;
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: primery,
          drawer: drawer(themeIsDark),
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () async {
                  DeviceApps.openApp('com.whatsapp');
                  //  noti();
                },
                icon: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: ColorsClass.green,
                ),
              ),
              IconButton(
                  onPressed: () => ccc(), //openMenu(),
                  icon: Icon(
                    Icons.help_outline_outlined,
                    size: 25,
                  )),
            ],
            iconTheme:
                IconThemeData(color: themeIsDark ? Colors.white : Colors.black),
            leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              icon: Icon(FlutterMenu.menu),
              iconSize: 9,
            ),
            backgroundColor: primery,
            elevation: 0,
            title: Text(
              "Status Saver",
              style: TextStyle(
                  color: themeIsDark ? Colors.white : Colors.grey[700]),
            ),
            bottom: TabBar(
                onTap: (value) {},
                indicatorColor: accent,
                labelColor: accent,
                unselectedLabelColor:
                    themeIsDark ? Colors.white : Colors.grey[700],
                tabs: [
                  Tab(
                    text: "Home",
                  ),
                  Tab(
                    text: "Downloads",
                  ),
                ]),
          ),
          body: FutureBuilder(
            future: Permission.storage.status,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              print("snappppingggg......>${snapshot.data}");
              if (!snapshot.hasData) {
                return Center(child: Text("Loading..."));
              } else {
                if (snapshot.data == PermissionStatus.granted) {
                  return TabBarView(
                    children: [
                      HomeScreen(),
                      DownloadScreen(),
                    ],
                  );
                } else if (snapshot.data == PermissionStatus.denied) {
                  return Container(
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 30),
                            Image.asset(
                              "assets/hand.png",
                              height: 250,
                              width: 250,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Oh no...",
                              style: TextStyle(color: textColor, fontSize: 30),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "You have not given Permission to access Storage yet",
                              style: TextStyle(color: textColor),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                                onPressed: () async {
                                  await [Permission.storage].request();
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                },
                                child: Text("Give Permission"))
                          ]),
                    ),
                  );
                }
                return Container(
                  child: Text(snapshot.data.toString()),
                );
              }
            },
          )),
    );
  }

  Future initiate() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    scheduledNotification();
  }

  scheduleAlarm() async {
    var dateTime = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 20, 11);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'app_icon',
      priority: Priority.max,
      importance: Importance.max,
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'New Status!',
      'You have new updated Status! Tap to Download✌️✌️',
      tz.TZDateTime.from(dateTime, tz.local),
      //platformChannel,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduledNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'New Status!',
      'You have new updated Status! Tap to Download✌️',
      _nextInstanceOfTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily notification channel id',
          'daily notification channel name',
          'daily notification description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 8, 35);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future openMenu() {
    return showModalBottomSheet(
        backgroundColor: primery,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        context: context,
        builder: (context) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "How to use?",
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "- If you can't find your Status here, it means status are not loaded yet",
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "- To load Status, open WhatsApp and check the desired status to load status in the Status Saver App",
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "- Now open Status Saver App to download and share",
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          );
        });
  }

  Widget drawer(bool themeIsDark) {
    return Drawer(
      child: Container(
        color: themeIsDark ? ColorsClass.primeDark : ColorsClass.primeWhite,
        child: ListView(
          children: [
            Container(
                height: 120,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/app_icon.png",
                        height: 35,
                        width: 35,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Status Saver",
                        style: TextStyle(fontSize: 30),
                      )
                    ],
                  ),
                )),
            ListTile(
              leading: themeIsDark
                  ? Icon(Icons.dark_mode_rounded, color: ColorsClass.icon)
                  : Icon(Icons.light_mode_rounded, color: Colors.grey[700]),
              title: Text(
                "Dark  Theme",
                style: TextStyle(
                  color: themeIsDark ? ColorsClass.icon : Colors.grey[700],
                ),
              ),
              trailing: Switch(
                value: themeIsDark,
                activeColor: ColorsClass.green,
                onChanged: (bool isOn) {
                  setState(() {
                    some = isOn;
                    _sendAnalyticsEvent("DarkTheme_is_$some");
                    ThemeChanger.of(context)!.changeTheme();
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.feedback_rounded,
                color: themeIsDark ? ColorsClass.icon : Colors.grey[700],
              ),
              title: Text(
                "Feedback",
                style: TextStyle(
                  color: themeIsDark ? ColorsClass.icon : Colors.grey[700],
                ),
              ),
              onTap: () {
                print("zzzzzoooooozzooo");
                //_launchURL();
                ccc();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline_rounded,
                color: themeIsDark ? ColorsClass.icon : Colors.grey[700],
              ),
              title: Text(
                "About Us",
                style: TextStyle(
                  color: themeIsDark ? ColorsClass.icon : Colors.grey[700],
                ),
              ),
              onTap: () {
                _sendAnalyticsEvent("About_us_is_Clicked");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUs()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.star_rate_rounded,
                color: themeIsDark ? ColorsClass.icon : Colors.grey[700],
              ),
              title: Text(
                "Rate Us",
                style: TextStyle(
                  color: themeIsDark ? ColorsClass.icon : Colors.grey[700],
                ),
              ),
              onTap: () {
                _launchURL();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.share,
                color: themeIsDark ? ColorsClass.icon : Colors.grey[700],
              ),
              title: Text(
                "Share",
                style: TextStyle(
                  color: themeIsDark ? ColorsClass.icon : Colors.grey[700],
                ),
              ),
              onTap: () {
                Share.share(samurl);
              },
            ),
          ],
        ),
      ),
    );
  }
}
