import 'package:flutter/material.dart';

import '../models/downloadVideo.dart';

class Downloads with ChangeNotifier {
  List<DownloadVideo> _downloads = [];

  List<DownloadVideo> get downloads {
    return [..._downloads];
  }

  void addVideo(DownloadVideo video) {
    _downloads.add(video);
  }

  DownloadVideo findById(String id) {
    return _downloads.firstWhere((element) => element.videoId == id);
  }
}
