// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:upload_demo_1/widgets/video_player_widget.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const MainPage(),
//     );
//   }
// }

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   PlatformFile? pickedFile;
//   UploadTask? uploadTask;

//   Future uploadFile() async {
//     final path = 'files/${pickedFile!.name}';
//     final file = File(pickedFile!.path!);

//     final ref = FirebaseStorage.instance.ref().child(path);
//     setState(() {
//       uploadTask = ref.putFile(file);
//     });
//     final snapshot = await uploadTask!.whenComplete(() => null);
//     final urlDownload = await snapshot.ref.getDownloadURL();
//     print('Download Link: $urlDownload');
//     setState(() {
//       uploadTask = null;
//     });
//   }

//   Future selectFile() async {
//     final result = await FilePicker.platform.pickFiles();
//     if (result == null) return;
//     setState(() {
//       pickedFile = result.files.first;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload File'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (pickedFile != null)
//               Expanded(
//                 child: Container(
//                   color: Colors.blue[100],
//                   child: buildMediaPreview(),
//                 ),
//               ),
//             ElevatedButton(
//                 onPressed: selectFile, child: const Text('Select File')),
//             SizedBox(width: 30),
//             ElevatedButton(
//                 onPressed: uploadFile, child: const Text('Upload File')),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildMediaPreview() {
//     final file = File(pickedFile!.path!);

//     switch (pickedFile!.extension!.toLowerCase()) {
//       case 'jpg':
//       case 'jpeg':
//       case 'png':
//         return Image.file(
//           file,
//           width: double.infinity,
//           height: 50,
//           fit: BoxFit.cover,
//         );
//       case 'mp4':
//         return VideoPlayerWidget(file: file);
//       default:
//         return Center(child: Text(pickedFile!.name));
//     }
//   }

//   Widget buildProgress() => StreamBuilder<TaskSnapshot>(
//       stream: uploadTask?.snapshotEvents,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final data = snapshot.data!;
//           double progress = data.bytesTransferred / data.totalBytes;

//           return SizedBox(
//             height: 50,
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 LinearProgressIndicator(
//                   value: progress,
//                   backgroundColor: Colors.grey,
//                   color: Colors.green,
//                 ),
//                 Center(
//                   child: Text(
//                     '${(100 * progress).roundToDouble()}%',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return const SizedBox(height: 50);
//         }
//       });
// }
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:upload_demo_1/widgets/video_player_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 24),
              minimumSize: const Size(200, 52),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 24),
              minimumSize: const Size(200, 52),
            ),
          ),
        ),
        home: const MainPage(),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');

    setState(() {
      uploadTask = null;
    });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Upload File'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (pickedFile != null)
                Expanded(
                  child: Container(
                    color: Colors.blue[100],
                    child: buildMediaPreview(),
                  ),
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                child: const Text('Select File'),
                onPressed: selectFile,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                child: const Text('Upload File'),
                onPressed: uploadFile,
              ),
              const SizedBox(height: 32),
              buildProgress(),
            ],
          ),
        ),
      );

  Widget buildMediaPreview() {
    final file = File(pickedFile!.path!);

    switch (pickedFile!.extension!.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Image.file(
          file,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      case 'mp4':
        return VideoPlayerWidget(file: file);
      default:
        return Center(child: Text(pickedFile!.name));
    }
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(height: 50);
        }
      });
}
