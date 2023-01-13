import 'package:flutter/material.dart';
import 'package:livey_testing/screens/home/tab_display.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController? controller;
  int currentIndex = 0;

  @override
  void initState() {
    currentIndex = 0;
    controller = PageController(initialPage: currentIndex);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  List data = [
    {
      "url":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      "id": "1"
    },
    {
      "url":
          //"https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
          "https://assets.mixkit.co/videos/preview/mixkit-man-under-colored-lights-1241-large.mp4",
      "id": "2"
    },
    {
      "url":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      "id": "3"
    },
    {
      "url":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
      //  "https://assets.mixkit.co/videos/preview/mixkit-hands-holding-a-smart-watch-with-the-stopwatch-running-32808-large.mp4",
      "id": "4"
    },
    {
      "url":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
      "id": "5"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // List<Widget> newList = List.generate(
    //   data.length,
    //   (index) {
    //     return TabDisplay(
    //       image: data[index]["image"],
    //       text: data[index]["id"],
    //     );
    //   },
    // );

    return Scaffold(
        body: PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      controller: controller,
      itemBuilder: (context, index) {
        return TabDisplay(
            videoUrl: data[index]["url"], videoId: data[index]["id"]);
      },
    ));
  }
}
