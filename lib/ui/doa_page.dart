import 'dart:io';

import 'package:al_quran/common/global_thme.dart';
import 'package:al_quran/widgets/audio_player_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:al_quran/widgets/app_bar_widget.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DoaPage extends StatefulWidget {
  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  // const DoaPage({super.key});

  bool isDownloaded = false;
  bool isPlaying = false;
  // String audioUrl =
  //     'https://equran.nos.wjv-1.neo.id/audio-full/Abdullah-Al-Juhany/001.mp3';
  String audioUrl =
      'https://equran.nos.wjv-1.neo.id/audio-full/Abdul-Muhsin-Al-Qasim/001.mp3';
  String localFilePath = '';

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // initializePlayer();

    player.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        setState(() {
          isPlaying = false;
        });
      }

      if (event == PlayerState.stopped) {
        setState(() {
          isPlaying = false;
        });
      }

      if (event == PlayerState.playing) {
        setState(() {
          isPlaying = true;
        });
      }

      if (event == PlayerState.paused) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  // void initializePlayer() async {
  //   await
  // }

  Future<String> _downloadFile(String url, String filename) async {
    var httpClient = http.Client();
    var request = await httpClient.get(Uri.parse(url));
    var bytes = request.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;

    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future<void> _downloadAndPlay(
      {required String audioUrl, required String fileName}) async {
    // String filename = 'audio1.mp3';
    String extractedString =
        audioUrl.split('/').sublist(audioUrl.split('/').length - 2).last;
    print(extractedString);

    String dir = (await getApplicationDocumentsDirectory()).path;
    String filePath = '$dir/$fileName';

    // Check if the file already exists
    bool fileExists = await File(filePath).exists();

    if (fileExists) {
      print('File exists');
      setState(() {
        localFilePath = filePath;
      });
      await player.play(DeviceFileSource(filePath));
      setState(() {
        isPlaying = true;
      });
      return;
    } else {
      print('File does not exist');
      String filePath = await _downloadFile(audioUrl, fileName);
      setState(() {
        localFilePath = filePath;
      });
      await player.play(DeviceFileSource(filePath));
      setState(() {
        isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Doa Page'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13.5),
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(.2),
                    ),
                    child: Center(child: Text('1')),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        isPlaying = !isPlaying;
                      });

                      if (isPlaying) {
                        await _downloadAndPlay(
                            audioUrl:
                                'https://equran.nos.wjv-1.neo.id/audio-full/Abdul-Muhsin-Al-Qasim/001.mp3',
                            fileName: 'audio2.mp3');
                      } else {
                        await player.pause();
                      }
                    },
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_outlined
                          : Icons.play_arrow_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: const Text('Play'),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.share_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.bookmark_border_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
            AudioPlayerWidget(
              audioUrl:
                  'https://equran.nos.wjv-1.neo.id/audio-full/Abdul-Muhsin-Al-Qasim/001.mp3',
            ),
          ],
        ),
      ),
    );
  }
}
