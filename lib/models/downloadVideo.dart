import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';

class DownloadVideo with ChangeNotifier {
  String videoId;
  Function changeState;
  DownloadVideo(this.videoId, this.changeState) {
    getVideoInfo();
    getDownloadInfo();
    imageUrl = "https://img.youtube.com/vi/$videoId/0.jpg";
  }

  final yt = YoutubeExplode();

  var title = '';
  var channelName = '';
  var imageUrl = "";
  List<StreamInfo> streamsList = [];
  var totalVideoSize = 0;
  var totalVideoSizeMB = "0";
  var downloadedVideoSize = "0.0";

  var filePath = '';
  var downloadPercentage = 0.0;

  bool isGetDownloadInfo = false;

  void getDownloadInfo() async {
    List<StreamInfo> streamsList1 = [];
    var manifest = await yt.videos.streamsClient.getManifest(videoId);
    streamsList1 = manifest.streams.toList();
    streamsList1
        .removeWhere((element) => element.codec.mimeType != "video/mp4");

    streamsList1.removeWhere((element) => element.qualityLabel == "tiny");
    streamsList1.sort((a, b) {
      var aLabel =
          int.parse(a.qualityLabel.substring(0, a.qualityLabel.indexOf("p")));
      var bLabel =
          int.parse(b.qualityLabel.substring(0, b.qualityLabel.indexOf("p")));
      return aLabel.compareTo(bLabel);
    });

    streamsList = streamsList1;
    changeState();
  }

  void getVideoInfo() async {
    var video = await yt.videos.get("https://youtube.com/watch?v=${videoId}");
    title = video.title;
    title = title.replaceAll(r'"', ' ');
    title = title.replaceAll(r'*', ' ');
    title = title.replaceAll(r'/', ' ');
    title = title.replaceAll(r'<', ' ');
    title = title.replaceAll(r'>', ' ');
    title = title.replaceAll(r'?', ' ');
    title = title.replaceAll(r'\\', ' ');
    title = title.replaceAll(r'|', ' ');
    channelName = video.author;

    changeState();
  }

  String? getDownloadPath() {
    Directory? directory;
    try {
      directory = Directory('/storage/emulated/0/Download');
    } catch (err) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  var count = 0;

  void downloadVideo(StreamInfo streamInfo) async {
    print("starting background service");
    // WidgetsFlutterBinding.ensureInitialized();

    // if (Platform.isIOS) FlutterBackgroundServiceIOS.registerWith();
    // if (Platform.isAndroid) FlutterBackgroundServiceAndroid.registerWith();

    // final service = FlutterBackgroundService();
    // service.onDataReceived.listen((event) {
    //   if (event!["action"] == "setAsForeground") {
    //     service.setAsForegroundService();
    //     return;
    //   }

    //   if (event["action"] == "setAsBackground") {
    //     service.setAsBackgroundService();
    //   }

    //   if (event["action"] == "stopService") {
    //     service.stopService();
    //   }
    // });

    // // bring to foreground
    // service.setAsForegroundService();
    log("downlod started");
    filePath = getDownloadPath()! + "/" + title + ".mp4";
    totalVideoSize = streamInfo.size.totalBytes.toInt();
    var file = await File(filePath).create(recursive: true);
    var sink = file.openWrite(mode: FileMode.write);

    getFileLenth();
    var streamData =
        await yt.videos.streamsClient.get(streamInfo).forEach((data) {
      sink.add(data);
    });

    await sink.flush();
    await sink.close();
    print("downlod Finished");
  }

  Future<void> getFileLenth() async {
    const twentyMillis = Duration(milliseconds: 100);
    Timer.periodic(twentyMillis, (Timer t) async {
      var file = File(filePath);
      var fileLen = await file.length();
      downloadedVideoSize = (fileLen / (1024 * 1024)).toStringAsFixed(2);
      totalVideoSizeMB = (totalVideoSize / (1024 * 1024)).toStringAsFixed(2);
      downloadPercentage = fileLen / totalVideoSize;
      debugPrint("completed ${downloadPercentage.toStringAsFixed(2)}%");
      notifyListeners();
      if (downloadPercentage == 1.0) {
        t.cancel();
        print("tiemr canceled");
      }
    });
  }

  // Future<void> initializeDownload(StreamInfo streamInfo) async {
  //   final service = FlutterBackgroundService();
  //   await service.configure(
  //     androidConfiguration: AndroidConfiguration(
  //       // this will executed when app is in foreground or background in separated isolate
  //       onStart: () => downloadVideo(streamInfo),

  //       // auto start service
  //       autoStart: true,
  //       isForegroundMode: true,
  //     ),
  //     iosConfiguration: IosConfiguration(
  //       onForeground: downloadVideo,
  //       onBackground: downloadVideo,
  //     ),
  //   );
  // }
}
