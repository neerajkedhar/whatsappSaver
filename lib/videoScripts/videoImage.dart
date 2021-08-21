import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:status_saver_ws/videoScripts/videoScreen.dart';
import 'package:video_player/video_player.dart';

class VideoImage extends StatefulWidget {
  final url;
  bool isDownloaded;

  VideoImage(this.url, this.isDownloaded);

  @override
  _VideoImageState createState() => _VideoImageState();
}

class _VideoImageState extends State<VideoImage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.url))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  Random rnd = new Random();

  randomNum(double max, double min) {
    var r = min + rnd.nextDouble() * (max - min);

    return r;
  }

  Color alpha = Colors.black;
  @override
  Widget build(BuildContext context) {
    var h = randomNum(300, 200);
    return Center(
      child: _controller.value.isInitialized
          ? Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VideoScreen(widget.url, widget.isDownloaded)));
                  },
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: randomNum(300, 200),
                    child: VideoPlayer(_controller),
                  ),
                ),
                Positioned.fill(
                  right: 10,
                  bottom: 10,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: alpha.withOpacity(0.4),
                        ),

                        height: 70, //h,
                        width: 70, //_controller.value.size.width,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoScreen(
                                        widget.url, widget.isDownloaded)));
                          },
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Center(
                //   child: Container(
                //     color: alpha.withOpacity(1),
                //     height: 100, //h,
                //     width: 100, //_controller.value.size.width,
                //   ),
                // ),
              ],
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
