import 'package:flutter/material.dart';
import 'package:youtube_downloader/screens/donwnloads_screen.dart';
import 'package:youtube_downloader/widgets/video_widget.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var linkInputController = TextEditingController();

  var Yt = YoutubeExplode();
  var videoLink = "";

  void downloadVideos() async {
    if (linkInputController.text.isEmpty) return;
    print("link = ${linkInputController.text}");
    setState(() {
      videoLink = linkInputController.text;
    });
  }

  void showVideoInfo(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return VideoWidget(linkInputController.text);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // linkInputController.text =
    //     "https://www.youtube.com/watch?v=iJN_VR3D8IY&ab_channel=Nakkalites";
    return Scaffold(
      appBar: AppBar(
        title: const Text("YT Downloader"),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(DownloadsScreen.routeName),
              icon: const Icon(Icons.download))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: TextField(
                controller: linkInputController,
                decoration: const InputDecoration(
                  label: Text("paste link here"),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                downloadVideos();
                showVideoInfo(context);
              },
              icon: const Icon(Icons.download_rounded),
            ),
          ]),
        ]),
      ),
    );
  }
}
