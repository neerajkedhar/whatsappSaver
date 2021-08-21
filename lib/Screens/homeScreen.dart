import 'dart:io';
import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:device_info/device_info.dart';
import 'package:share/share.dart';
import 'package:status_saver_ws/Screens/imageViewScreen.dart';
import 'package:status_saver_ws/ads.dart';
import 'package:status_saver_ws/colors.dart';
import 'package:status_saver_ws/homePage.dart';
import 'package:status_saver_ws/videoScripts/videoImage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//Directory _photoDir;

Directory _photoDir = Directory(
    "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses");
//"/storage/emulated/0/WhatsApp/Media/.Statuses"
Directory android11 = Directory("/storage/emulated/0/WhatsApp/Media/.Statuses");
//"/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses"

class _HomeScreenState extends State<HomeScreen> {
  final controller = NativeAdController();
  var nativeAdUnitID = "ca-app-pub-3071933490034842/6129129503";
  //"ca-app-pub-3940256099942544/2247696110"; //real id
  AdsClass ads = AdsClass();
  Color accent = ColorsClass.green;
  late Color primery;
  late Color secondry;
  late Color textColor;

  var imageList;
  var adsImageList = [];

  nativeAdCallbacks() {
    controller.onEvent.listen((e) {
      final event = e.keys.first;
      switch (event) {
        case NativeAdEvent.loading:
          print('loading');
          break;
        case NativeAdEvent.loaded:
          print('loaded');

          break;
        case NativeAdEvent.loadFailed:
          final errorCode = e.values.first;
          print('nativead loadFailed in homescreen $errorCode');
          break;

        default:
          break;
      }
    });
  }

  checkingTheData() {
    print("something....");
    print("${_photoDir.path} path existts");
    if (Directory('${_photoDir.path}').existsSync()) {
      print("${_photoDir.path} path existtssss");
      setState(() {
        imageList = _photoDir
            .listSync()
            .map((item) => item.path)
            .where((item) => item.endsWith('.jpg') || item.endsWith('.mp4'))
            .toList(growable: false);
      });
      setData();
    }
  }

  getData() async {
    final result = await Permission.storage.status;
    if (result == PermissionStatus.granted) {
      if (Directory('${android11.path}').existsSync()) {
        setState(() {
          imageList = android11
              .listSync()
              .map((item) => item.path)
              .where((item) => item.endsWith('.jpg') || item.endsWith('.mp4'))
              .toList(growable: false);
        });
        setData();
      } else if (Directory('${_photoDir.path}').existsSync()) {
        print("${_photoDir.path} path existtssss");
        setState(() {
          imageList = _photoDir
              .listSync()
              .map((item) => item.path)
              .where((item) => item.endsWith('.jpg') || item.endsWith('.mp4'))
              .toList(growable: false);
        });
        setData();
      }
    } else {}
  }

  setData() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      setState(() {
        adsImageList = List.from(imageList);
        for (int i = 8; i <= adsImageList.length; i += 9) {
          adsImageList.insert(i, 5);
        }
      });
    } else if (result == ConnectivityResult.none) {
      setState(() {
        adsImageList = List.from(imageList);
      });
    } else {
      setState(() {
        adsImageList = List.from(imageList);
      });
    }
  }

  loadNativeAd() {
    controller.load(
      options: NativeAdOptions(),
      unitId: nativeAdUnitID,
    );
  }

  @override
  void initState() {
    // ads.initializeInter();
    //  loadNativeAd();
    //nativeAdCallbacks();
    super.initState();
    getData();

    chech();
  }

  shareFile(var imgPath) {
    Share.shareFiles([imgPath], text: '');
  }

  @override
  Widget build(BuildContext context) {
    // ads.loadInterstitialAd();
    bool themeIsDark = Theme.of(context).brightness == Brightness.dark;
    primery = themeIsDark ? ColorsClass.primeDark : ColorsClass.primeWhite;
    secondry =
        themeIsDark ? ColorsClass.secondryDark : ColorsClass.secondryWhite;
    textColor = themeIsDark ? ColorsClass.icon : Colors.grey;
    return FutureBuilder(
      future: Permission.storage.status,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return RefreshIndicator(
            child: ss(snapshot, themeIsDark), onRefresh: onRefreshFun);
      },
    );
  }

  Future<void> onRefreshFun() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      if (Directory('${android11.path}').existsSync()) {
        setState(() {
          imageList = android11
              .listSync()
              .map((item) => item.path)
              .where((item) => item.endsWith('.jpg') || item.endsWith('.mp4'))
              .toList(growable: false);
        });

        adsImageList = List.from(imageList);
        for (int i = 5; i <= adsImageList.length; i += 6) {
          adsImageList.insert(i, 5);
        }
      } else if (Directory('${_photoDir.path}').existsSync()) {
        setState(() {
          imageList = _photoDir
              .listSync()
              .map((item) => item.path)
              .where((item) => item.endsWith('.jpg') || item.endsWith('.mp4'))
              .toList(growable: false);
        });
        adsImageList = List.from(imageList);
        for (int i = 5; i <= adsImageList.length; i += 6) {
          adsImageList.insert(i, 5);
        }
      }
    } else if (result == ConnectivityResult.none) {
      if (Directory('${android11.path}').existsSync()) {
        setState(() {
          imageList = android11
              .listSync()
              .map((item) => item.path)
              .where((item) => item.endsWith('.jpg') || item.endsWith('.mp4'))
              .toList(growable: false);
        });
        adsImageList = List.from(imageList);
      } else if (Directory('${_photoDir.path}').existsSync()) {
        setState(() {
          imageList = _photoDir
              .listSync()
              .map((item) => item.path)
              .where((item) => item.endsWith('.jpg') || item.endsWith('.mp4'))
              .toList(growable: false);
        });
        adsImageList = List.from(imageList);
      }
    } else {
      if (Directory('${android11.path}').existsSync()) {
        setState(() {
          imageList = android11
              .listSync()
              .map((item) => item.path)
              .where((item) => item.endsWith('.jpg') || item.endsWith('.mp4'))
              .toList(growable: false);
        });
        adsImageList = List.from(imageList);
      } else if (Directory('${_photoDir.path}').existsSync()) {
        setState(() {
          imageList = _photoDir
              .listSync()
              .map((item) => item.path)
              .where((item) => item.endsWith('.jpg') || item.endsWith('.mp4'))
              .toList(growable: false);
        });
        adsImageList = List.from(imageList);
      }
    }
  }

  late int version;
  chech() async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = androidInfo.version.release;
    setState(() {
      version = int.parse(release);
      print("Version.....................>$version");
    });
  }

  ss(var snapshot, bool themeIsDark) {
    if (!snapshot.hasData) {
      return Text("Loading...");
    } else {
      if (snapshot.data == PermissionStatus.granted) {
        if (!Directory('${android11.path}').existsSync()) {
          if (!Directory("${_photoDir.path}").existsSync()) {
            return Scaffold(
              body: Container(
                color: primery,
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Image.asset("assets/2.png"),
                              SizedBox(height: 20),
                              Text(
                                "WhatsApp is not installed",
                                style:
                                    TextStyle(fontSize: 15.0, color: textColor),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Install WhatsApp to Download Statuses $version $imageList',
                                style: TextStyle(color: textColor),
                              ),
                            ]),
                      )),
                ),
              ),
            );
          } else {
            if (adsImageList.length > 0) {
              return Container(
                color: primery,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StaggeredGridView.countBuilder(
                    itemCount: adsImageList.length,
                    crossAxisCount: 4,
                    itemBuilder: (context, index) {
                      var imgPath = adsImageList[index];
                      if (imgPath is String) {
                        return adsImageList[index].endsWith(".jpg")
                            ? imageCard(
                                imgPath, true, index, imageList, themeIsDark)
                            : videoCard(
                                imgPath, true, index, imageList, themeIsDark);
                      } else {
                        return f();
                      }
                    },
                    staggeredTileBuilder: (i) {
                      if (adsImageList[i] is String) {
                        return StaggeredTile.fit(2);
                      } else {
                        return StaggeredTile.count(4, 1.2);
                      }
                    },
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 10.0,
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Container(
                  color: primery,
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                Image.asset("assets/2.png"),
                                SizedBox(height: 20),
                                Text(
                                  "Oops!",
                                  style: TextStyle(
                                      fontSize: 25.0, color: textColor),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Status are not loaded. Open WhatsApp and View your desired status to load here',
                                  style: TextStyle(color: textColor),
                                ),
                                SizedBox(height: 15),
                                TextButton(
                                    onPressed: () {
                                      DeviceApps.openApp('com.whatsapp');
                                    },
                                    child: Text(
                                      "Open WhatsApp",
                                      style:
                                          TextStyle(color: ColorsClass.green),
                                    )),
                              ]),
                        )),
                  ),
                ),
              );
            }
          }
        } else {
          if (adsImageList.length > 0) {
            return Container(
              color: primery,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StaggeredGridView.countBuilder(
                  itemCount: adsImageList.length,
                  crossAxisCount: 4,
                  itemBuilder: (context, index) {
                    var imgPath = adsImageList[index];
                    if (imgPath is String) {
                      return adsImageList[index].endsWith(".jpg")
                          ? imageCard(
                              imgPath, true, index, imageList, themeIsDark)
                          : videoCard(
                              imgPath, true, index, imageList, themeIsDark);
                    } else {
                      return f();
                    }
                  },
                  staggeredTileBuilder: (i) {
                    if (adsImageList[i] is String) {
                      return StaggeredTile.fit(2);
                    } else {
                      return StaggeredTile.count(4, 1.2);
                    }
                  },
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 10.0,
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Container(
                color: primery,
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Image.asset("assets/5.png"),
                              SizedBox(height: 20),
                              Text(
                                "Oops!",
                                style:
                                    TextStyle(fontSize: 25.0, color: textColor),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Status are not loaded. Open WhatsApp and View your desired status to load here',
                                style: TextStyle(color: textColor),
                              ),
                              SizedBox(height: 15),
                              // TextButton(
                              //     onPressed: () {
                              //       // DeviceApps.openApp('com.whatsapp');
                              //       checkingTheData();
                              //     },
                              //     child: Text(
                              //       "Open WhatsApp",
                              //       style: TextStyle(color: ColorsClass.green),
                              //     )),
                              // TextButton(
                              //     onPressed: () {
                              //       // DeviceApps.openApp('com.whatsapp');
                              //       checkingTheData();
                              //     },
                              //     child: Text(
                              //       "Open WhatsApp",
                              //       style: TextStyle(color: ColorsClass.green),
                              //     )),
                            ]),
                      )),
                ),
              ),
            );
          }
        }
      } else if (snapshot.data == PermissionStatus.denied) {
        return Container(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(height: 30),
              Image.asset("assets/2.png"),
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
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Text("Give Permission"))
            ]),
          ),
        );
      }
      print(snapshot.data.toString());
      return Container(
        child: Text(snapshot.data.toString()),
      );
    }
  }

  videoCard(
      var imgPath, bool isDownloaded, var index, var imageList, bool theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: secondry,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(children: [
          InkWell(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Hero(
                  tag: imgPath,
                  child: Container(
                    child: VideoImage(imgPath, false),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.download_rounded,
                    size: 27,
                    color: theme ? ColorsClass.icon : Colors.grey[500],
                  ),
                  onPressed: () {
                    savingVidFile(imgPath, theme);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    size: 25,
                    color: theme ? ColorsClass.icon : Colors.grey[500],
                  ),
                  onPressed: () {
                    shareFile(imgPath);
                  },
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  imageCard(
      var imgPath, bool isDownloaded, var index, var imageList, bool theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: secondry,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPhotos(
                    imgPath,
                    false,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Hero(
                  tag: imgPath,
                  child: Image.file(
                    File(imgPath),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.download_rounded,
                    size: 27,
                    color: theme ? ColorsClass.icon : Colors.grey[500],
                  ),
                  onPressed: () {
                    savingFile(imgPath, theme);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    size: 25,
                    color: theme ? ColorsClass.icon : Colors.grey[500],
                  ),
                  onPressed: () {
                    shareFile(imgPath);
                  },
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  savingFile(var imgPath, bool theme) async {
    final originalImgFile = File(imgPath);
    if (!Directory('/storage/emulated/0/Status_Saver_i').existsSync()) {
      Directory('/storage/emulated/0/Status_Saver_i')
          .createSync(recursive: true);
    }
    final curDate = DateTime.now().toString();
    final newFileName = 'storage/emulated/0/Status_Saver_i/VIDEO-$curDate.jpg';

    await originalImgFile.copy(newFileName);
    _onDownload(theme);
  }

  savingVidFile(var imgPath, bool theme) async {
    final originalImgFile = File(imgPath);
    if (!Directory('/storage/emulated/0/Status_Saver_i').existsSync()) {
      Directory('/storage/emulated/0/Status_Saver_i')
          .createSync(recursive: true);
    }
    final curDate = DateTime.now().toString();
    final newFileName = 'storage/emulated/0/Status_Saver_i/VIDEO-$curDate.mp4';

    await originalImgFile.copy(newFileName);
    _onDownload(theme);
  }

  void _onDownload(bool theme) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: primery,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: EdgeInsets.zero,
            children: <Widget>[
              Center(
                child: Container(
                  margin: EdgeInsets.all(15),
                  padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      new RichText(
                        text: new TextSpan(
                          style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            new TextSpan(
                              text: 'Great! ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsClass.green),
                            ),
                            new TextSpan(
                                text: 'Status Saved in your Gallery',
                                style: new TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color:
                                        theme ? Colors.white : Colors.black)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        child: const Text('Okay'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorsClass.green),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                        onPressed: () {
                          Navigator.pop(context);
                          ads.showInterstitial();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget f() {
    return NativeAd(
      height: 100,
      unitId: nativeAdUnitID,
      buildLayout: secondBuilder,
      loading: Text('loading'),
      error: Text('error'),
      icon: AdImageView(size: 100),
      advertiser: AdTextView(
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      button: AdButtonView(
        decoration: AdDecoration(backgroundColor: Colors.blue),
      ),
      headline: AdTextView(
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        maxLines: 1,
      ),
      media: AdMediaView(height: 80, width: 120),
    );
  }

  AdLayoutBuilder get secondBuilder => (ratingBar, media, icon, headline,
          advertiser, body, price, store, attribution, button) {
        return AdLinearLayout(
          padding: EdgeInsets.all(5),
          width: MATCH_PARENT,
          orientation: HORIZONTAL,
          decoration: AdDecoration(backgroundColor: primery),
          children: [
            icon,
            AdLinearLayout(
              children: [
                headline,
                AdLinearLayout(
                  children: [attribution, advertiser, ratingBar],
                  orientation: HORIZONTAL,
                  width: WRAP_CONTENT,
                  height: 20,
                ),
                button,
              ],
              margin: EdgeInsets.symmetric(horizontal: 4),
            ),
          ],
        );
      };
}
