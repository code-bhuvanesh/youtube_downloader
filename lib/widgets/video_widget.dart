import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:provider/provider.dart';
import 'package:youtube_downloader/models/downloadVideo.dart';

import '../providers/downloads.dart';

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = Set();
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

class VideoWidget extends StatefulWidget {
  String link;
  String videoId = '';
  VideoWidget(this.link) {
    if (link.contains("youtube.com")) {
      if (link.contains("https://www.youtube.com/")) {
        videoId = link.substring(32, 43);
      } else {
        videoId = link.substring(20, 31);
      }
    } else {
      videoId = link.substring(17);
    }
    print(" = $videoId");
  }

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  var showProgressBar = false;
  late DownloadVideo downloadingVideo;

  var isLoading = true;

  void changeState() {
    setState(() {});
    if (isLoading) {
      isLoading = false;
    }
  }

  @override
  void initState() {
    downloadingVideo = DownloadVideo(widget.videoId, changeState);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height - 186,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  height: 100,
                  child: Image.network(
                    downloadingVideo.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 195,
                        child: Text(
                          downloadingVideo.title,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                      Text(
                        downloadingVideo.channelName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          //if (!showProgressBar)
          isLoading
              ? const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: GridView.count(
                    childAspectRatio: 3 / 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 4,
                    children: downloadingVideo.streamsList
                        .map((stream) =>
                            DownloadWidget(stream, downloadingVideo))
                        .toList(),
                  ),
                ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

class DownloadWidget extends StatelessWidget {
  final StreamInfo streamInfo;
  final DownloadVideo downloadingVideo;
  DownloadWidget(this.streamInfo, this.downloadingVideo);
  final int downloadId = 32;

  @override
  Widget build(BuildContext context) {
    // print("list quality = ${streamInfo.qualityLabel}");
    return InkWell(
      onTap: () async {
        Provider.of<Downloads>(context, listen: false)
            .addVideo(downloadingVideo);
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromARGB(255, 218, 193, 193)),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Text(streamInfo.qualityLabel),
              Text("${streamInfo.size.totalMegaBytes.round()}MB"),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
      ),
    );
  }
}












































//////////////////////////WORKING CODE/////////////////////////////////////////////////////////////
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// extension Unique<E, Id> on List<E> {
//   List<E> unique([Id Function(E element)? id, bool inplace = true]) {
//     final ids = Set();
//     var list = inplace ? this : List<E>.from(this);
//     list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
//     return list;
//   }
// }

// class VideoWidget extends StatefulWidget {
//   String link;
//   String videoId = '';
//   VideoWidget(this.link) {
//     if (link.contains("youtube.com")) {
//       videoId = link.substring(32, 43);
//     } else {
//       videoId = link.substring(17);
//     }
//   }

//   @override
//   State<VideoWidget> createState() => _VideoWidgetState();
// }

// class _VideoWidgetState extends State<VideoWidget> {
//   var title = 'title';
//   var channelName = 'channel';
//   List<StreamInfo> streamsList = [];
//   final yt = YoutubeExplode();
//   var totalVideoSize = 0;
//   var downloadedVideoSize = 0.0;

//   var showProgressBar = false;

//   void getDownloadInfo() async {
//     var manifest = await yt.videos.streamsClient.getManifest(widget.videoId);
//     streamsList = manifest.streams.toList();
//     // streamsList = streamsList.unique(
//     //   (element) => element.qualityLabel,
//     // );
//     streamsList.removeWhere((element) => element.codec.mimeType != "video/mp4");

//     streamsList.removeWhere((element) => element.qualityLabel == "tiny");
//     streamsList.sort((a, b) {
//       var aLabel =
//           int.parse(a.qualityLabel.substring(0, a.qualityLabel.indexOf("p")));
//       var bLabel =
//           int.parse(b.qualityLabel.substring(0, b.qualityLabel.indexOf("p")));
//       return aLabel.compareTo(bLabel);
//     });
//   }

//   void getVideoInfo() async {
//     var video =
//         await yt.videos.get("https://youtube.com/watch?v=${widget.videoId}");
//     print("video url = https://youtube.com/watch?v=${widget.videoId}");
//     setState(() {
//       title = video.title;
//       // print("video title = ${video.title}");
//       channelName = video.author;
//     });
//   }

//   String? getDownloadPath() {
//     Directory? directory;
//     try {
//       directory = Directory('/storage/emulated/0/Download');
//     } catch (err) {
//       print("Cannot get download folder path");
//     }
//     return directory?.path;
//   }

//   var count = 0;

//   void downloadVideo(StreamInfo streamInfo) async {
//     print("downlod started");
//     setState(() {
//       showProgressBar = true;
//     });
//     var stream = yt.videos.streamsClient.get(streamInfo);
//     totalVideoSize = streamInfo.size.totalBytes.toInt();
//     var file =
//         File("${getDownloadPath()!}/${title}_${streamInfo.qualityLabel}.mp4");
//     var fileStream = file.openWrite();
//     await for (final data in stream) {
//       setState(() {
//         count += data.length;
//         downloadedVideoSize = ((count / totalVideoSize) * 1);
//       });
//       // print("count = $count");
//       // print("progress = ${((count / totalVideoSize) * 100).ceil()}");

//       fileStream.add(data);
//     }

//     await fileStream.flush();
//     await fileStream.close();
//     print("downlod Finished");
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print("link = ${widget.link}");

//     var imageUrl = "https://img.youtube.com/vi/${widget.videoId}/0.jpg";
//     // print(imageUrl);

//     // print("link = $url");
//     getVideoInfo();
//     getDownloadInfo();
//     return Container(
//       height: MediaQuery.of(context).size.height - 186,
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             child: Row(
//               children: [
//                 SizedBox(
//                   width: 150,
//                   height: 100,
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Container(
//                   height: 100,
//                   padding: EdgeInsets.all(10),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: 195,
//                         child: Text(
//                           title,
//                           maxLines: 2,
//                           softWrap: true,
//                         ),
//                       ),
//                       Text(
//                         channelName,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           //if (!showProgressBar)
//           Expanded(
//             child: GridView.count(
//               childAspectRatio: 3 / 2,
//               mainAxisSpacing: 10,
//               crossAxisSpacing: 10,
//               crossAxisCount: 4,
//               children: streamsList
//                   .map((stream) => DownloadWidget(stream, downloadVideo))
//                   .toList(),
//             ),
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           if (showProgressBar)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "completed ${(downloadedVideoSize * 100).toStringAsFixed(2)}",
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 Text(
//                     "${(count / 1048576).toStringAsFixed(2)} MB/${(totalVideoSize / 1048576).toStringAsFixed(2)} MB"),
//               ],
//             ),
//           SizedBox(
//             height: 10,
//           ),
//           LinearProgressIndicator(
//             backgroundColor: Colors.grey,
//             value: downloadedVideoSize.toDouble(),
//             valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DownloadWidget extends StatelessWidget {
//   final StreamInfo streamInfo;
//   final Function downloadVideo;
//   DownloadWidget(this.streamInfo, this.downloadVideo);

//   @override
//   Widget build(BuildContext context) {
//     // print("list quality = ${streamInfo.qualityLabel}");
//     return InkWell(
//       onTap: () => downloadVideo(streamInfo),
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             color: Color.fromARGB(255, 218, 193, 193)),
//         child: Padding(
//           padding: EdgeInsets.all(5),
//           child: Column(
//             children: [
//               Text(streamInfo.qualityLabel),
//               Text("${streamInfo.size.totalMegaBytes.round()}MB"),
//             ],
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           ),
//         ),
//       ),
//     );
//   }
// }
