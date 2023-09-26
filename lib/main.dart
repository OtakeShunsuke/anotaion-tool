import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
// import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Make sure to add the required packages to pubspec.yaml:
  // * https://github.com/media-kit/media-kit#installation
  // * https://pub.dev/packages/media_kit#installation
  MediaKit.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isButtonEnabled = false; // ボタンの初期状態
  // 洗濯中のファイル名
  String selectedFileName = 'No file selected';

  List<VideoFile> videoFiles = [];
  // ビデオファイルのインデックス
  int videoFileIndex = 1;
  var selectedIndex = -1;

  final Player player = Player();
  late final VideoController controller = VideoController(player);

  void toggleButtonState() {
    setState(() {
      isButtonEnabled = !isButtonEnabled; // 条件を切り替えるための関数
    });
  }

  @override
  void initState() {
    super.initState();
    _getVideoFiles();
    player.setAudioTrack(AudioTrack.no());
    player.setPlaylistMode(PlaylistMode.loop);
    player.open(Media(
        '/Users/otakeshunsuke/Library/CloudStorage/OneDrive-個人用/0_7_LabelClips/Interview/Happy/0227.mp4'));
    player.stream.error.listen((error) => debugPrint(error));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _getVideoFiles() async {
    final String? directoryPath = await getDirectoryPath();
    if (directoryPath == null) {
      return;
    }

    Directory directory = Directory(directoryPath);
    List<FileSystemEntity> files = directory.listSync();
    // debugPrint(files.toString());
    for (FileSystemEntity file in files) {
      if (file is File && file.path.endsWith('.mp4')) {
        videoFiles.add(VideoFile(file.path));
      }
    }
    setState(() {});
    debugPrint(videoFiles[0].fileName);
    // videoFilesのファイルネームをリストで表示
    for (int i = 0; i < videoFiles.length; i++) {
      debugPrint(videoFiles[i].fileName);
    }

    player.open(Media(videoFiles[videoFileIndex].path));
    setState(() {
      selectedFileName = videoFiles[videoFileIndex].fileName;
    });
  }

  Future<void> showFilePicker(BuildContext context, Player player) async {
    // final result = await FilePicker.platform.pickFiles(type: FileType.any);
    // if (result?.files.isNotEmpty ?? false) {
    //   final file = result!.files.first;
    //   if (kIsWeb) {
    //     await player.open(Media(convertBytesToURL(file.bytes!)));
    //   } else {
    //     await player.open(Media(file.path!));
    //   }
    // }
    // videoFiles[];
    toggleButtonState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Windowsの動画再生アプリ',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Windowsの動画再生アプリ'),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'file',
          tooltip: 'Open [File]',
          onPressed: () => showFilePicker(context, player),
          child: const Icon(Icons.file_open),
        ),
        body: Row(
          children: [
            Text(
              'ファイル名：',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      selectedFileName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 256.0,
                      child: AspectRatio(
                        aspectRatio: 4.0 / 3.0,
                        child: Video(
                          controller: controller,
                          controls: NoVideoControls,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AntiArrowButton(
                            size: 50.0,
                            color: const Color.fromARGB(255, 152, 201, 242),
                            isButtonEnabled: isButtonEnabled,
                            onPressed: () {
                              videoFileIndex--;
                              player
                                  .open(Media(videoFiles[videoFileIndex].path));
                              setState(() {
                                selectedFileName =
                                    videoFiles[videoFileIndex].fileName;
                              });
                            },
                          ),
                          //Passボタンを配置
                          Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: ElevatedButton(
                              child: Text('Pass'),
                              onPressed: toggleButtonState,
                            ),
                          ),
                          ArrowButton(
                            size: 50.0,
                            color: const Color.fromARGB(255, 152, 201, 242),
                            isButtonEnabled: isButtonEnabled,
                            onPressed: () {
                              videoFileIndex++;
                              player
                                  .open(Media(videoFiles[videoFileIndex].path));
                              setState(() {
                                selectedFileName =
                                    videoFiles[videoFileIndex].fileName;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      width: 150,
                      child: ListView.builder(
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return ListTile(
                            selected: selectedIndex == index ? true : false,
                            selectedTileColor: Colors.pink.withOpacity(0.2),
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            title: Text('$index'),
                          );
                        },
                      ),
                    ),
                    Text(
                      'Passボタンを押すと次の動画に進みます',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoFile {
  final String path;
  final String fileName;

  VideoFile(this.path) : fileName = path.split('/').last;
}

String convertBytesToURL(Uint8List bytes) {
  // N/A
  throw UnimplementedError();
}

// 矢印ボタン
class ArrowButton extends StatelessWidget {
  final double size;
  final Color color;
  final VoidCallback onPressed;
  final bool isButtonEnabled; // 条件によってボタンを有効/無効にするためのプロパティ

  ArrowButton({
    required this.size,
    required this.color,
    required this.onPressed,
    required this.isButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isButtonEnabled ? onPressed : null, // 条件に応じてボタンを有効/無効にする
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: Size(1.7 * size, size),
            painter: ArrowButtonPainter(color),
          ),
          const Text(
            'Next',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ArrowButtonPainter extends CustomPainter {
  final Color color;

  ArrowButtonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double arrowWidth = size.width;
    final double arrowHeight = size.height;

    final Path path = Path()
      ..moveTo(0, 0.15 * arrowHeight)
      ..lineTo(0.66 * arrowWidth, 0.15 * arrowHeight)
      ..lineTo(0.66 * arrowWidth, 0)
      ..lineTo(size.width, 0.5 * arrowHeight)
      ..lineTo(0.66 * arrowWidth, size.height)
      ..lineTo(0.66 * arrowWidth, 0.85 * size.height)
      ..lineTo(0, 0.85 * arrowHeight)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// 矢印ボタン
class AntiArrowButton extends StatelessWidget {
  final double size;
  final Color color;
  final VoidCallback onPressed;
  final bool isButtonEnabled; // 条件によってボタンを有効/無効にするためのプロパティ

  AntiArrowButton({
    required this.size,
    required this.color,
    required this.onPressed,
    required this.isButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isButtonEnabled ? onPressed : null, // 条件に応じてボタンを有効/無効にする
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: Size(1.7 * size, size),
            painter: AntiArrowButtonPainter(color),
          ),
          const Text(
            'Next',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class AntiArrowButtonPainter extends CustomPainter {
  final Color color;

  AntiArrowButtonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double arrowWidth = size.width;
    final double arrowHeight = size.height;

    final Path path = Path()
      ..moveTo(size.width, 0.15 * arrowHeight)
      ..lineTo(0.33 * arrowWidth, 0.15 * arrowHeight)
      ..lineTo(0.33 * arrowWidth, 0)
      ..lineTo(0, 0.5 * arrowHeight)
      ..lineTo(0.33 * arrowWidth, size.height)
      ..lineTo(0.33 * arrowWidth, 0.85 * size.height)
      ..lineTo(size.width, 0.85 * arrowHeight)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
