import 'dart:io';

import 'package:flutter/material.dart';
import 'package:status_saver_ws/ads.dart';
import 'package:status_saver_ws/colors.dart';
import 'package:status_saver_ws/videoScripts/videoPlayer.dart';

import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  String videoFile;
  bool isDownloaded;
  VideoScreen(this.videoFile, this.isDownloaded);
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  AdsClass ads = AdsClass();
  @override
  void initState() {
    super.initState();
    ads.initializeInter();
    print('Video file you are looking for:' + widget.videoFile);
  }

  @override
  void dispose() {
    ads.showInterstitial();
    super.dispose();
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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SimpleDialog(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Great, Saved in Gallary',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(str,
                              style: const TextStyle(
                                fontSize: 16.0,
                              )),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          const Text('FileManager > wa_status_saver',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.teal)),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          MaterialButton(
                            child: const Text('Close'),
                            color: ColorsClass.green,
                            textColor: Colors.white,
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    ads.loadInterstitialAd();
    return widget.isDownloaded
        ? Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                color: Colors.white,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
              child: VideoPlayerScreen(
                videoPlayerController:
                    VideoPlayerController.file(File(widget.videoFile)),
                looping: true,
                videoSrc: widget.videoFile,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                color: Colors.white,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
              child: VideoPlayerScreen(
                videoPlayerController:
                    VideoPlayerController.file(File(widget.videoFile)),
                looping: true,
                videoSrc: widget.videoFile,
              ),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 5, 70),
              child: FloatingActionButton(
                  backgroundColor: ColorsClass.green,
                  child: const Icon(Icons.download_rounded),
                  onPressed: () async {
                    _onLoading(true, '');

                    final originalVideoFile = File(widget.videoFile);

                    if (!Directory('/storage/emulated/0/Status_Saver_i')
                        .existsSync()) {
                      Directory('/storage/emulated/0/Status_Saver_i')
                          .createSync(recursive: true);
                    }

                    final curDate = DateTime.now().toString();
                    final newFileName =
                        'storage/emulated/0/Status_Saver_i/VIDEO-$curDate.mp4';

                    await originalVideoFile.copy(newFileName);

                    _onLoading(
                      false,
                      'If Video not available in gallary\n\nYou can find all videos at',
                    );
                  }),
            ),
          );
  }
}
