import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Uploadaudio extends StatefulWidget {
  const Uploadaudio({super.key});

  @override
  State<Uploadaudio> createState() => _UploadaudioState();
}
//do not touch
class _UploadaudioState extends State<Uploadaudio> {
  String extractedText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              // 1. Load asset as byte data
              final byteData = await rootBundle.load(
                'assets/audio.mp3',
              ); // your asset path

              // 2. Create a temporary file & write bytes to it
              final tempDir = await getTemporaryDirectory();
              final tempFile = File('${tempDir.path}/temp_audio.mp3');
              await tempFile.writeAsBytes(byteData.buffer.asUint8List());

              // 3. Prepare MultipartRequest and send file
              var uri = Uri.parse(
                'http://10.0.2.2:5000/transcribe',
              ); // or your backend URL
              var request = http.MultipartRequest('POST', uri)
                ..files.add(
                  await http.MultipartFile.fromPath('file', tempFile.path),
                );

              var response = await request.send();

              if (response.statusCode == 200) {
                final respStr = await response.stream.bytesToString();
                print('Transcription: $respStr');
                extractedText = respStr;
                setState(() {});
              } else {
                print(
                  'Failed with status: is this here? ${response.statusCode}',
                );
              }
            },
            child: Text("Audio to text"),
          ),
          Text(extractedText),
        ],
      ),
    );
  }
}
