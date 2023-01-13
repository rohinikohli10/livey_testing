import 'package:better_player/better_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:livey_testing/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class TabDisplay extends StatefulWidget {
  final String videoUrl;
  final String videoId;
  const TabDisplay({super.key, required this.videoUrl, required this.videoId});

  @override
  State<TabDisplay> createState() => _TabDisplayState();
}

class _TabDisplayState extends State<TabDisplay> {
  BetterPlayerController? playerController;
  late final BetterPlayerCacheConfiguration cacheConfiguration;
  String? url;
  bool ismuted = false;
  bool isCurrentlyTouching = false;
  bool islike = false;
  bool isDownload = false;
  int? id;

  @override
  void initState() {
    url = widget.videoUrl;
    super.initState();
    print(isCurrentlyTouching);
    playerController?.setVolume(1.0);
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url!,
      placeholder: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://cdn.pixabay.com/animation/2022/12/26/09/50/09-50-13-682_512.gif"),
                fit: BoxFit.contain)),
      ),
    );
    cacheConfiguration = const BetterPlayerCacheConfiguration(useCache: true);
    playerController = BetterPlayerController(
        const BetterPlayerConfiguration(
            showPlaceholderUntilPlay: true,
            fit: BoxFit.contain,
            aspectRatio: 9 / 17,
            controlsConfiguration: BetterPlayerControlsConfiguration(
                showControls: false,
                backgroundColor: Colors.black,
                loadingColor: ProjectColors.yellow,
                loadingWidget: CircularProgressIndicator(),
                showControlsOnInitialize: false,
                enableAudioTracks: true),
            autoDetectFullscreenAspectRatio: true,
            autoPlay: true,
            autoDispose: true),
        betterPlayerDataSource: betterPlayerDataSource);
  }

  String? percent;
  bool downloading = false;

  void handleTouch() {
    if (ismuted == true) {
      setState(() {
        playerController?.setVolume(0.0);
        Future.delayed(const Duration(seconds: 4)).then((v) {
          showMuted();
        });
      });
    } else {
      playerController?.setVolume(1.0);
      Future.delayed(const Duration(seconds: 4)).then((v) {
        showUnMuted();
      });
    }
  }

  Widget showMuted() {
    return Center(
      child: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.volume_off,
          size: 70,
        ),
      ),
    );
  }

  Widget showUnMuted() {
    return Center(
      child: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.volume_up_outlined,
          size: 70,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        RotatedBox(
          quarterTurns: 4,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: ProjectColors.black,
            // decoration: BoxDecoration(
            //     image:
            //         DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
            child: BetterPlayer(
              controller: playerController!,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
                child: InkWell(
              onTap: () {
                setState(() {
                  isCurrentlyTouching = !isCurrentlyTouching;
                  ismuted = !ismuted;
                  handleTouch();
                });
              },
              child: Container(
                color: Colors.transparent,
              ),
            )),
            Container(
              height: size.height,
              width: size.width * 0.2,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: size.height * 0.6,
                    ),
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: ProjectColors.primaryColor,
                      child: CircleAvatar(
                        radius: 23,
                        backgroundImage:
                            AssetImage("assets/images/family_pic.png"),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            islike = !islike;
                          });
                        },
                        icon: Icon(
                          islike ? Icons.favorite : Icons.favorite_border,
                          color: islike
                              ? ProjectColors.red
                              : ProjectColors.primaryColor,
                          size: 40,
                        )),
                    IconButton(
                        onPressed: () async {
                          setState(() {
                            isDownload = true;
                          });
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.storage,
                            //add more permission to request here.
                          ].request();
                          if (statuses[Permission.storage]!.isGranted) {
                            //for download in android=================
                            if (Platform.isAndroid) {
                              // var dir =
                              //     await DownloadsPathProvider.downloadsDirectory;
                              var documents =
                                  await getExternalStorageDirectory();
                              if (documents != null) {
                                String savename = "${widget.videoId}_video.mp4";
                                String savePath = "${documents.path}/$savename";
                                print(savePath);
                                //output:  /storage/emulated/0/Download/banner.png

                                try {
                                  await Dio().download(url!, savePath,
                                      onReceiveProgress: (received, total) {
                                    if (total != -1) {
                                      print(
                                          "${(received / total * 100).toStringAsFixed(0)}%");
                                      setState(() {
                                        downloading = true;
                                        percent =
                                            "${(received / total * 100).toStringAsFixed(0)}%";
                                        print(received);
                                      });
                                      //you can build progressbar feature too
                                    }
                                  });
                                  print("Image is saved to download folder.");
                                } on DioError catch (e) {
                                  print(e.message);
                                }
                                setState(() {
                                  downloading = false;
                                  percent = "Completed";
                                });
                                print("Download completed");
                              }
                            } else {
                              //for download in ios=================
                              Directory documents =
                                  await getApplicationDocumentsDirectory();

                              if (documents != null) {
                                String savename = "${widget.videoId}_video.mp4";
                                String savePath = "${documents.path}/$savename";
                                print(savePath);
                                //output:  /storage/emulated/0/Download/banner.png
                                try {
                                  await Dio().download(url!, savePath,
                                      onReceiveProgress: (received, total) {
                                    if (total != -1) {
                                      print(
                                          "${(received / total * 100).toStringAsFixed(0)}%");
                                      setState(() {
                                        downloading = true;
                                        percent =
                                            "${(received / total * 100).toStringAsFixed(0)}%";
                                        print(received);
                                      });

                                      //you can build progressbar feature too
                                    }
                                    // _showAlertDialog(percent!);
                                    // if (received == total) {
                                    //   Navigator.pop(context);
                                    // }

                                    print("received=-------------------");
                                    print(received);
                                  });
                                  // ignore: use_build_context_synchronously

                                  // Fluttertoast.showToast(
                                  //     msg: "Video downloaded Successfully",
                                  //     toastLength: Toast.LENGTH_LONG,
                                  //     gravity: ToastGravity.CENTER,
                                  //     timeInSecForIosWeb: 2,
                                  //     backgroundColor: ProjectColors.pink,
                                  //     textColor: Colors.white,
                                  //     fontSize: 16.0);
                                  print("Image is saved to download folder.");
                                } on DioError catch (e) {
                                  print(e.message);
                                }
                                setState(() {
                                  downloading = false;
                                  percent = "Completed";
                                });
                                print("Download completed");
                              }
                            }
                          } else {
                            print("No permission to read and write.");
                          }
                        },
                        icon: Icon(
                          isDownload
                              ? Icons.download_for_offline
                              : Icons.download_for_offline_outlined,
                          color: ProjectColors.primaryColor,
                          size: 40,
                        )),
                    Container(
                      height: size.height * 0.1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        Center(
          child: downloading
              ? Container(
                  height: 120.0,
                  width: 200.0,
                  child: Card(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const CircularProgressIndicator(),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Downloading File: $percent",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(),
        ),

        // InkWell(
        //   onTap: () {
        //     setState(() {
        //       isCurrentlyTouching = !isCurrentlyTouching;
        //       ismuted = !ismuted;
        //       handleTouch();
        //     });
        //   },
        //   child: SizedBox(
        //     child: Align(
        //       alignment: Alignment.centerRight,
        //       child: ElevatedButton(
        //         onPressed: () async {
        //           Map<Permission, PermissionStatus> statuses = await [
        //             Permission.storage,
        //             //add more permission to request here.
        //           ].request();
        //           if (statuses[Permission.storage]!.isGranted) {
        //             var dir = await DownloadsPathProvider.downloadsDirectory;
        //             if (dir != null) {
        //               String savename = "banner.mp4";
        //               String savePath = dir.path + "/$savename";
        //               print(savePath);
        //               //output:  /storage/emulated/0/Download/banner.png

        //               try {
        //                 await Dio().download(url!, savePath,
        //                     onReceiveProgress: (received, total) {
        //                   if (total != -1) {
        //                     print((received / total * 100).toStringAsFixed(0) +
        //                         "%");
        //                     print(received);
        //                     //you can build progressbar feature too
        //                   }
        //                   print(received);
        //                 });

        //                 print("Image is saved to download folder.");
        //               } on DioError catch (e) {
        //                 print(e.message);
        //               }
        //             }
        //           } else {
        //             print("No permission to read and write.");
        //           }
        //         },
        //         child: Icon(Icons.download),
        //       ),
        //     ),
        //   ),
        //   // child: Container(
        //   //   color: isCurrentlyTouching
        //   //       ? ProjectColors.black.withOpacity(0.4)
        //   //       : Colors.transparent,
        //   // child: Center(
        //   //   child: IconButton(
        //   //     onPressed: () {
        //   //       setState(() {
        //   //         playerController?.videoPlayerController?.refresh();
        //   //       });
        //   //       print("kboirtnot78689668------");
        //   //     },
        //   //     icon: Icon(
        //   //       Icons.replay_outlined,
        //   //       size: 70,
        //   //     ),
        //   //   ),
        //   // ),
        //   // ),
        // )
      ],
    );
  }

  Future<void> _showAlertDialog(String received) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          // <-- SEE HERE
          title: Row(
            children: [Text('Downloading.... $received')],
          ),
        );
      },
    );
  }
}
