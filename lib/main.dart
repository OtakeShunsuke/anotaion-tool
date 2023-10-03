import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:test/botton.dart';
import 'package:test/dataentry.dart';
import 'package:test/videofile.dart';

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
  bool isButtonEnabled = true; // ボタンの初期状態
  // 洗濯中のファイル名
  String selectedFileName = 'No file selected';

  List<VideoFile> videoFiles = [];
  // ビデオファイルのインデックス
  int videoFileIndex = 1;
  int selectedIndex = -1;
  String csvFilePath = '';
  List<DataEntry> dataEntries = [];
  int currentIndex = 0;
  int selectedValue = 1;

  final Player player = Player();
  late final VideoController controller = VideoController(player);

  List<String> array = [
    "未選択",
    "アイテム1",
    "アイテム2",
    "アイテム3",
    "アイテム4",
    "アイテム5",
    "アイテム6",
    "アイテム7",
    "アイテム8",
    "アイテム9",
    "アイテム10",
    "アイテム11",
    "アイテム12",
    "アイテム13",
    "アイテム14",
    "アイテム15",
    "アイテム16",
    "アイテム17",
    "アイテム18",
    "アイテム19",
    "アイテム20",
    "アイテム21",
    "アイテム22",
  ];
  String selectedText = "";

  void toggleButtonStateTrue() {
    setState(() {
      isButtonEnabled = true;
    });
  }

  void toggleButtonStateFalse() {
    setState(() {
      isButtonEnabled = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // _getVideoFiles();
    player.setAudioTrack(AudioTrack.no());
    player.setPlaylistMode(PlaylistMode.loop);
    // player.open(Media(
    //     '/Users/otakeshunsuke/Library/CloudStorage/OneDrive-個人用/0_7_LabelClips/Interview/Happy/0227.mp4'));
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Windowsの動画再生アプリ',
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'file',
          tooltip: 'Open [File]',
          onPressed: () => pickAndReadCsvFile(),
          child: const Icon(Icons.file_open),
        ),
        body: SingleChildScrollView(
          // SingleChildScrollViewで子ウィジェットをラップ
          scrollDirection: Axis.horizontal, // スクロールの向きを水平方向に指定
          child: Row(
            children: [
              Container(
                alignment: Alignment.topCenter,
                width: 1000.0,
                child: Image.asset(
                  'assets/intro.png',
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.all(10.0),
                // child: Center(
                child: SingleChildScrollView(
                  // SingleChildScrollViewで子ウィジェットをラップ
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
                      const SizedBox(height: 10),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (currentIndex > 0)
                              AntiArrowButton(
                                size: 50.0,
                                color: const Color.fromARGB(255, 152, 201, 242),
                                isButtonEnabled: isButtonEnabled,
                                onPressed: () {
                                  videoFileIndex--;
                                  currentIndex--;

                                  player.open(Media(
                                      dataEntries[currentIndex].filePath));

                                  setState(() {
                                    saveCsvFile();
                                    selectedIndex =
                                        dataEntries[currentIndex].value;
                                    selectedText = array[selectedIndex];
                                    if (selectedIndex == 0) {
                                      toggleButtonStateFalse();
                                    }
                                    selectedFileName =
                                        "データ番号: ${currentIndex + 1}";
                                  });
                                },
                              )
                            else
                              const SizedBox(
                                width: 85.0,
                              ),
                            //Passボタンを配置
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: ElevatedButton(
                                onPressed: toggleButtonStateTrue,
                                child: const Text('Pass'),
                              ),
                            ),
                            if (currentIndex < dataEntries.length - 1)
                              ArrowButton(
                                size: 50.0,
                                color: const Color.fromARGB(255, 152, 201, 242),
                                isButtonEnabled: isButtonEnabled,
                                onPressed: () {
                                  videoFileIndex++;
                                  currentIndex++;
                                  player.open(Media(
                                      dataEntries[currentIndex].filePath));

                                  setState(() {
                                    saveCsvFile();
                                    selectedIndex =
                                        dataEntries[currentIndex].value;
                                    selectedText = array[selectedIndex];
                                    if (selectedIndex == 0) {
                                      toggleButtonStateFalse();
                                    }

                                    selectedFileName =
                                        "データ番号: ${currentIndex + 1}";
                                  });
                                },
                              )
                            else
                              const SizedBox(
                                width: 85.0,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 212,
                                padding: const EdgeInsets.all(1.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                ),
                                child: Text(
                                  selectedText,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                ),
                                child: SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: ListView.builder(
                                    itemCount: array.length,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        height: 20,
                                        child: Center(
                                          child: ListTile(
                                            dense: true,
                                            selected: selectedIndex == index
                                                ? true
                                                : false,
                                            // selectedTileColor: Colors.pink.withOpacity(0.2),
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = index;
                                                if (selectedIndex != 0) {
                                                  toggleButtonStateTrue();
                                                }
                                                selectedText =
                                                    array[selectedIndex];
                                              });
                                              dataEntries[currentIndex].value =
                                                  selectedIndex;
                                            },
                                            title: Align(
                                              alignment:
                                                  Alignment.topLeft, //真ん中
                                              child: Text(
                                                array[index],
                                                style: const TextStyle(
                                                    fontSize: 12, height: 0.5
                                                    //テキストを上下中央に配置する
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: toggleButtonStateTrue,
                                  child: const Text('Select'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickAndReadCsvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        csvFilePath = file.path!;
        dataEntries = [];
        currentIndex = 0;
        selectedValue = 1;
      });

      // CSVファイルを読み込む処理を追加
      List<String> lines = File(csvFilePath).readAsLinesSync();
      for (String line in lines) {
        List<String> values = line.split(',');
        String filePath = values[0].trim();
        int value = int.tryParse(values[1].trim()) ?? 0;
        dataEntries.add(DataEntry(filePath: filePath, value: value));
      }
      // 一つ目の動画を読み込む処理を追加
      player.open(Media(dataEntries[currentIndex].filePath));

      setState(() {
        selectedIndex = dataEntries[currentIndex].value;
        debugPrint("${dataEntries[currentIndex].value}");
        selectedText = array[selectedIndex];
        if (selectedIndex == 0) {
          toggleButtonStateFalse();
        }
        selectedFileName = "データ番号: ${currentIndex + 1}";
      });
    }
  }

  void saveCsvFile() {
    if (csvFilePath.isNotEmpty) {
      StringBuffer updatedCsvData = StringBuffer();
      for (DataEntry entry in dataEntries) {
        updatedCsvData.writeln('${entry.filePath}, ${entry.value}');
      }

      File(csvFilePath).writeAsStringSync(updatedCsvData.toString());
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // content: Text('CSVファイルが保存されました。'),
      // ));
    }
  }
}

String convertBytesToURL(Uint8List bytes) {
  // N/A
  throw UnimplementedError();
}
