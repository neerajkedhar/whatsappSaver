import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:status_saver_ws/Screens/imageViewScreen.dart';
import 'package:status_saver_ws/ads.dart';
import 'package:status_saver_ws/colors.dart';
import 'package:status_saver_ws/homePage.dart';
import 'package:status_saver_ws/videoScripts/videoImage.dart';

class DownloadScreen extends StatefulWidget {
  DownloadScreen({Key? key}) : super(key: key);

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
  // _DownloadScreenState myd = new _DownloadScreenState();
}

final Directory _photoDir = Directory('/storage/emulated/0/Status_Saver_i');

class _DownloadScreenState extends State<DownloadScreen> {
  final controller = NativeAdController();
  Color accent = ColorsClass.green;
  AdsClass ads = AdsClass();
  late Color primery; // = ColorsClass.primeDark;
  late Color secondry;
  late Color textColor;
  var nativeAdUnitID = "ca-app-pub-3071933490034842/9820962500";
  //"ca-app-pub-3940256099942544/2247696110"; //real id
  shareFile(var imgPath) {
    Share.shareFiles([imgPath], text: '');
  }

  Future checkIfPermissionIsGiven() async {
    final result = await Permission.storage.status;
    if (result.isDenied) {
      await [Permission.storage].request();
      return result;
    } else if (result.isGranted) {
      return result;
    }
    return result;
  }

  loadNativeAd() {
    controller.load(
      options: NativeAdOptions(),
      unitId: nativeAdUnitID,
    );
  }

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
          print('native ad download screen loadFailed $errorCode');
          break;

        default:
          break;
      }
    });
  }

  @override
  void initState() {
    loadNativeAd();
    nativeAdCallbacks();
    super.initState();
    getData();

    ads.initializeInter();
    if (!Directory('/storage/emulated/0/Status_Saver_i').existsSync()) {
      Directory('/storage/emulated/0/Status_Saver_i')
          .createSync(recursive: true);
    }
    //setData();
  }

  var imageList;
  var adsImageList;

  getData() async {
    final result = await Permission.storage.status;
    if (result == PermissionStatus.granted) {
      setState(() {
        imageList = _photoDir
            .listSync()
            .map((item) => item.path)
            .where((item) => item.endsWith('.jpg') || item.endsWith('.mp4'))
            .toList(growable: true);
      });
      setData();
    }
  }

  setData() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      setState(() {
        adsImageList = List.from(imageList);
        for (int i = 5; i <= adsImageList.length; i += 6) {
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

  @override
  Widget build(BuildContext context) {
    ads.loadInterstitialAd();
    bool themeIsDark = Theme.of(context).brightness == Brightness.dark;
    primery = themeIsDark ? ColorsClass.primeDark : ColorsClass.primeWhite;
    secondry =
        themeIsDark ? ColorsClass.secondryDark : ColorsClass.secondryWhite;
    textColor = themeIsDark ? ColorsClass.icon : Colors.grey;
    return Container(
      color: primery,
      child: FutureBuilder(
          future: Permission.storage.status,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return RefreshIndicator(
                child: ss(snapshot, themeIsDark), onRefresh: onRefreshFun);
          }),
    );
  }

  Future<void> onRefreshFun() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      setState(() {
        imageList = _photoDir
            .listSync()
            .map((item) => item.path)
            .where((item) => item.endsWith('.jpg') || item.endsWith('.mp4'))
            .toList(growable: false);

        adsImageList = List.from(imageList);
        for (int i = 5; i <= adsImageList.length; i += 6) {
          adsImageList.insert(i, 5);
        }
      });
    } else if (result == ConnectivityResult.none) {
      setState(() {
        imageList = _photoDir
            .listSync()
            .map((item) => item.path)
            .where((item) => item.endsWith('.jpg') || item.endsWith('.mp4'))
            .toList(growable: false);

        adsImageList = List.from(imageList);
      });
    } else {
      setState(() {
        imageList = _photoDir
            .listSync()
            .map((item) => item.path)
            .where((item) => item.endsWith('.jpg') || item.endsWith('.mp4'))
            .toList(growable: false);

        adsImageList = List.from(imageList);
      });
    }
  }

  Widget ss(var snapshot, bool themeIsDark) {
    if (snapshot.data == PermissionStatus.granted) {
      if (!Directory('${_photoDir.path}').existsSync()) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Install WhatsApp\n',
              style: TextStyle(fontSize: 18.0),
            ),
            const Text(
              "Your Friend's Status Will Be Available Here",
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        );
      } else {
        if (adsImageList.length > 0) {
          return Container(
            color: primery,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StaggeredGridView.countBuilder(
                key: Key(adsImageList.length.toString()),
                itemCount: adsImageList.length,
                crossAxisCount: 4,
                itemBuilder: (context, index) {
                  final imgPath = adsImageList[index];
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
                    //return StaggeredTile.count(2, 1);
                  } else {
                    return StaggeredTile.count(4, 1.2);
                    // return StaggeredTile.fit(2);
                  }
                }, //=> StaggeredTile.fit(2),
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
                      // padding: const EdgeInsets.only(bottom: 60.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Image.asset("assets/2.png"),
                            SizedBox(height: 20),
                            Text(
                              "Whoops!",
                              style:
                                  TextStyle(fontSize: 25.0, color: textColor),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'You have no Downloads',
                              style: TextStyle(color: textColor),
                            ),
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
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(height: 30),
            Image.asset("assets/hand.png"),
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
                  Navigator.pop(context); // pop current page
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
    return Container();
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
                    child: VideoImage(imgPath, true),
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
                      Icons.share,
                      color: theme ? ColorsClass.icon : Colors.grey[500],
                    ),
                    onPressed: () {
                      shareFile(imgPath);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_rounded,
                      color: theme ? ColorsClass.icon : Colors.grey[500],
                    ),
                    onPressed: () {
                      _onDeleteFromDevice(imgPath, imageList, index, theme);
                    },
                  ),
                ],
              ))
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
                    isDownloaded,
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
                      Icons.share,
                      color: theme ? ColorsClass.icon : Colors.grey[500],
                    ),
                    onPressed: () {
                      shareFile(imgPath);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_rounded,
                      color: theme ? ColorsClass.icon : Colors.grey[500],
                    ),
                    onPressed: () {
                      _onDeleteFromDevice(imgPath, imageList, index, theme);
                    },
                  ),
                ],
              ))
        ]),
      ),
    );
  }

  void _onDeleteFromDevice(var path, var imageList, var index, bool theme) {
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
                  color: primery,
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
                              text: 'This Status will be ',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: theme ? Colors.white : Colors.black),
                            ),
                            new TextSpan(
                                text: 'Deleted ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)),
                            new TextSpan(
                              text: 'from Your Device',
                              style: new TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: theme ? Colors.white : Colors.black),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      ElevatedButton(
                        child: const Text('Delete'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorsClass.green),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                        onPressed: () {
                          File(path).delete();
                          final snackBar = SnackBar(
                            content: Text('File Deleted!'),
                            duration: Duration(milliseconds: 1000),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pop(context);
                          ads.showInterstitial();
                          setState(() {
                            adsImageList.removeAt(index);
                          });
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
      // controller: controller,
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
