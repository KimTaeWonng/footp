import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class NormalForm extends StatefulWidget {
  const NormalForm({super.key});

  @override
  State<NormalForm> createState() => _NormalFormState();
}

Future<dynamic> patchFootData(dynamic input) async {
  print("일반 게시글을 작성합니다.");
  var dio = new Dio();
  try {
    dio.options.contentType = 'multipart/form-data';

    print("############data: $input");

    // var response = await dio.patch(
    //   baseUri + '/users/profileimage',
    //   data: input,
    // );
    print('성공적으로 업로드했습니다');
  } catch (e) {
    print(e);
  }
}

enum OpenRange { all, me }

class _NormalFormState extends State<NormalForm> {
  OpenRange _openRange = OpenRange.all;
  String showFileName = "";
  List<String> allowedFileTypes = ['jpg', 'mp4', 'txt', 'pdf'];
  final myText = TextEditingController();
  FilePickerResult? result;
  String? filePath;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          maxLines: 10,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            alignLabelWithHint: true,
            hintText: '메세지를 입력하세요',
          ),
          controller: myText,
        ),
        Container(
          height: 200,
          width: 400,
          decoration: BoxDecoration(
            border: Border.all(
              width: 5,
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: allowedFileTypes,
                  );
                  if (result != null) {
                    print('########## ${result.files.first}');
                    PlatformFile file = result.files.single;
                    String fileName = result.files.first.name;
                    // Uint8List fileBytes = result.files.first.bytes!;
                    debugPrint(fileName);
                    this.filePath = result.files.single.path;
                    print('name: ${filePath}');
                    // var multipartFile = await MultipartFile.fromFile(
                    //   file.path,
                    // );
                    setState(() {
                      showFileName = "Now File Name: $fileName";
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Find and Upload",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                    Icon(
                      Icons.upload_rounded,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Text(
                "$allowedFileTypes",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                showFileName,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Text(
          '공개 범위',
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.start,
        ),
        Row(children: <Widget>[
          Expanded(
            child: RadioListTile(
              title: Text('전체 공개'),
              value: OpenRange.all,
              groupValue: _openRange,
              onChanged: (value) {
                setState(() {
                  _openRange = value!;
                });
              },
            ),
          ),
          Expanded(
            child: RadioListTile(
              title: Text('나만 보기'),
              value: OpenRange.me,
              groupValue: _openRange,
              onChanged: (value) {
                setState(() {
                  _openRange = value!;
                });
              },
            ),
          ),
        ]),
        Container(
            child: IconButton(
                onPressed: () async {
                  print(this.filePath.runtimeType);
                  print('#########################');
                  var formData = FormData.fromMap({
                    'messageText': myText.text,
                    'messageFileurl':
                        await MultipartFile.fromFile(this.filePath!),
                    'messageLongtitude': 37.60251338193296,
                    'messageLatitude': 127.12306290392186,
                    'isOpentoall': _openRange == OpenRange.all ? true : false,
                  });
                  print(formData.fields);
                },
                icon: Icon(
                  Icons.handshake,
                  size: 24,
                ))),
      ],
    ));
  }
}
