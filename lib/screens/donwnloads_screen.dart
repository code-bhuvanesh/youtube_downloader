import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_downloader/models/downloadVideo.dart';
import 'package:youtube_downloader/providers/downloads.dart';

class DownloadsScreen extends StatefulWidget {
  static var routeName = "DownloadsScreen";
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  Widget build(BuildContext context) {
    final videoDownloads = Provider.of<Downloads>(context);
    print(" download video length = ${videoDownloads.downloads.length}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: videoDownloads.downloads[i],
              child: DownloadVideoWidget(),
            ),
            itemCount: videoDownloads.downloads.length,
          )),
    );
  }
}

class DownloadVideoWidget extends StatefulWidget {
  const DownloadVideoWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<DownloadVideoWidget> createState() => _DownloadVideoWidgetState();
}

class _DownloadVideoWidgetState extends State<DownloadVideoWidget> {
  @override
  Widget build(BuildContext context) {
    final downloadVideo = Provider.of<DownloadVideo>(context);
    return Container(
      width: double.infinity,
      height: 120,
      child: Center(
        child: Row(
          children: [
            SizedBox(
              width: 150,
              height: 100,
              child: Image.network(
                downloadVideo.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 120,
              padding: const EdgeInsets.all(10),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 195,
                      child: Text(
                        downloadVideo.title,
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ),
                    Text(
                      downloadVideo.channelName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${downloadVideo.downloadedVideoSize}MB/${downloadVideo.totalVideoSizeMB}MB",
                      textAlign: TextAlign.right,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 10,
                          width: 130,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.grey,
                            color: Colors.blue,
                            value: downloadVideo.downloadPercentage,
                          ),
                        ),
                        Text(
                            "    ${(downloadVideo.downloadPercentage * 100).toStringAsFixed(0)}%")
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
