import 'dart:io';
import 'package:flutter/material.dart';
import 'package:status_saver_ws/ads.dart';
import 'package:status_saver_ws/colors.dart';

class ViewPhotos extends StatefulWidget {
  String imgPath;
  bool fromDownloaded;

  ViewPhotos(this.imgPath, this.fromDownloaded);

  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  AdsClass ads = AdsClass();
  @override
  void initState() {
    super.initState();

    ads.initializeInter();

    //setData();
  }

  @override
  void dispose() {
    super.dispose();
    // ads.showInterstitial();
  }

  void _onLoading(bool t, String str) {
    if (t) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                Center(
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const CircularProgressIndicator()),
                ),
              ],
            );
          });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
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
                                    color: Colors.green),
                              ),
                              new TextSpan(
                                  text: 'Status Saved in your Gallery',
                                  style: new TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          child: const Text('Close'),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    ads.loadInterstitialAd();
    return widget.fromDownloaded
        ? Scaffold(
            backgroundColor: Colors.black12,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                color: Colors.indigo,
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SizedBox.expand(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Hero(
                      tag: widget.imgPath,
                      child: Image.file(
                        File(widget.imgPath),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.black12,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                color: Colors.indigo,
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SizedBox.expand(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Hero(
                      tag: widget.imgPath,
                      child: Image.file(
                        File(widget.imgPath),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new FloatingActionButton(
                  elevation: 20.0,
                  child: new Icon(Icons.download_rounded),
                  backgroundColor: ColorsClass.green,
                  onPressed: () {
                    savingImgFile();
                  }),
            ));
  }

  savingImgFile() async {
    _onLoading(true, '');
    final originalImgFile = File(widget.imgPath);
    if (!Directory('/storage/emulated/0/Status_Saver_i').existsSync()) {
      Directory('/storage/emulated/0/Status_Saver_i')
          .createSync(recursive: true);
    }
    final curDate = DateTime.now().toString();
    final newFileName = 'storage/emulated/0/Status_Saver_i/VIDEO-$curDate.jpg';
    //print(newFileName);
    await originalImgFile.copy(newFileName);
    _onLoading(
      false,
      'If Video not available in gallary\n\nYou can find all videos at',
    );
    ads.showInterstitial();
  }
}
