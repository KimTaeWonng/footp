// ignore_for_file: unnecessary_this

import 'package:app_footp/createFoot.dart';
import 'package:app_footp/createFootMap.dart';
import 'package:app_footp/main.dart';
import 'package:app_footp/myLocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart' as DIO;
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:scaled_list/scaled_list.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';

final List<String> imgList = [
  "asset/band.png",
  "asset/band.png",
  "asset/band.png",
  "asset/band.png",
  "asset/band.png",
];

class megaPhoneForm extends StatefulWidget {
  const megaPhoneForm({super.key});

  @override
  State<megaPhoneForm> createState() => _megaPhoneFormState();
}

class _megaPhoneFormState extends State<megaPhoneForm> {
  CreateMarker createMarker = Get.put(CreateMarker());
  String showFileName = "";
  List<String> allowedFileTypes = ['jpg', 'mp3', 'mp4'];
  final myMegaText = TextEditingController();
  FilePickerResult? result;
  String? filePath = '';
  UserData user = Get.put(UserData());
  var _timeresult = "종료 시간 설정";
  var _timeresultindex;
  var _categoryresult = "카테고리 설정";
  var _categoryindex;

  addtime() {
    final today = DateTime.now();
    var addDate;
    switch (_timeresultindex) {
      case 0:
        {
          addDate = today.add(const Duration(hours: 1));
          return addDate.toString();
        }
      case 1:
        {
          addDate = today.add(const Duration(hours: 2));
          return addDate.toString();
        }
      case 2:
        {
          addDate = today.add(const Duration(hours: 3));
          return addDate.toString();
        }
      case 3:
        {
          addDate = today.add(const Duration(hours: 6));
          return addDate.toString();
        }
      case 4:
        {
          addDate = today.add(const Duration(hours: 12));
          return addDate.toString();
        }
      case 5:
        {
          addDate = today.add(const Duration(days: 1));
          return addDate.toString();
        }
      case 6:
        {
          addDate = today.add(const Duration(days: 2));
          return addDate.toString();
        }
      case 7:
        {
          addDate = today.add(const Duration(days: 7));
          return addDate.toString();
        }
      case 8:
        {
          addDate = today.add(const Duration(days: 36500));
          return addDate.toString();
        }
    }
  }

  Future<void> _categorieselect(BuildContext context) async {
    return showDialog<void>(
        context: context,
        // 사용자가 다이얼로그 바깥을 터치하면 닫히지 않음
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue[100],
            title: Text(
              "카테고리 설정",
              style: TextStyle(color: Colors.blue[900]),
            ),
            content: Container(
              height: 400,
              width: 300,
              child: ScaledList(
                  unSelectedCardHeightRatio: 0.4,
                  selectedCardHeightRatio: 0.7,
                  itemBuilder: (index, selectedIndex) {
                    final category = categories[index];
                    _categoryindex = selectedIndex;
                    _categoryresult = categories[selectedIndex].name;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: selectedIndex == index ? 100 : 80,
                          child: Image.asset(category.image),
                        ),
                        SizedBox(height: 15),
                        Text(
                          category.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: selectedIndex == index ? 25 : 20),
                        )
                      ],
                    );
                  },
                  itemCount: categories.length,
                  itemColor: (index) {
                    return kMixedColors[index % kMixedColors.length];
                  }),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  // 다이얼로그 닫기
                  setState(() {
                    _categoryindex = _categoryindex;
                    _categoryresult = _categoryresult;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _neverSatisfied(BuildContext context) async {
    final _items = [
      "1시간",
      "2시간",
      "3시간",
      "6시간",
      "12시간",
      "하루",
      "이틀",
      "일주일",
      "평생"
    ];
    var result = _items[0]; // 기본값 0
    return showDialog<void>(
        context: context,
        // 사용자가 다이얼로그 바깥을 터치하면 닫히지 않음
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue[100],
            title: Text(
              "시간 설정",
              style: TextStyle(color: Colors.blue[900]),
            ),
            content: SingleChildScrollView(
              child: Container(
                height: 150.0,
                child: CupertinoPicker(
                  children: _items
                      .map((e) => Text(
                            '$e',
                            style: TextStyle(color: Colors.blue[900]),
                          ))
                      .toList(),
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int value) {
                    result = _items[value];
                    setState(() {
                      _timeresult = result;
                      _timeresultindex = value;
                    });
                  },
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  // 다이얼로그 닫기
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  final List<Color> kMixedColors = [
    Color(0xff71A5D7),
    Color(0xff72CCD4),
    Color(0xffFBAB57),
    Color(0xffF8B993),
    Color(0xff962D17),
    Color(0xffc657fb),
    Color(0xfffb8457),
  ];

  final List<Category> categories = [
    Category(image: "asset/band.png", name: "공연"),
    Category(image: "asset/band.png", name: "맛집"),
    Category(image: "asset/band.png", name: "행사"),
    Category(image: "asset/band.png", name: "관광"),
    Category(image: "asset/band.png", name: "친목"),
  ];

  @override
  Widget build(BuildContext context) {
    // ModeController modeController1 = Get.put(ModeController());
    // MyPosition myPosition_main = Get.put(MyPosition());
    // CreateMarker createMarker = Get.put(CreateMarker());
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 40),

        TextField(
          maxLines: 5,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            alignLabelWithHint: true,
            hintText: '메세지를 입력하세요',
          ),
          controller: myMegaText,
        ),
        Container(
          height: 150,
          width: 400,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                    filePath = result.files.first.path;
                    // var multipartFile = await MultipartFile.fromFile(
                    //   file.path,
                    // );
                    print('-----------------------------------');
                    print(filePath);
                    createMarker.filePath = filePath!;
                    print('--------------------------------------');
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
              Container(
                  child: TextButton(
                      child: Text(
                        '파일 삭제',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: (() {
                        setState(() {
                          this.filePath = '';
                          this.showFileName = '';
                        });
                      })))
            ],
          ),
        ),
        SizedBox(height: 40),
        CupertinoButton(
          child: Text("$_timeresult"),
          onPressed: () {
            _neverSatisfied(context);
          },
        ),
        CupertinoButton(
          child: Text("$_categoryresult"),
          onPressed: () {
            _categorieselect(context);
          },
        ),
        // Text("$_timeresult"),
        Container(
            child: IconButton(
          onPressed: () async {
            if (this.filePath == '' && myMegaText.text.trim() == '') {
              final snackBar = SnackBar(
                content: const Text('내용을 입력하거나 파일을 첨부해주세요!'),
                action: SnackBarAction(
                  label: '확인',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (myMegaText.text.length > 255) {
              final snackBar = SnackBar(
                content: const Text('내용은 255자 이하로만 작성 가능합니다.!'),
                action: SnackBarAction(
                  label: '확인',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (_timeresultindex == null) {
              final snackBar = SnackBar(
                content: const Text('종료 시간을 설정해 주세요!'),
                action: SnackBarAction(
                  label: '확인',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (_categoryindex == null) {
              final snackBar = SnackBar(
                content: const Text('카테고리를 설정해 주세요!'),
                action: SnackBarAction(
                  label: '확인',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              createMarker.newmegaphone['gatherText'] = myMegaText.text;

              DIO.MultipartFile? file = this.result != null
                  ? await DIO.MultipartFile.fromFile(this.filePath!)
                  : null;

              createMarker.newmegaphone['userId'] = user.userinfo["userId"];

              String finishdate = addtime();

              var i = finishdate.lastIndexOf(':');
              finishdate = finishdate.substring(0, i);
              finishdate = finishdate.replaceFirst(' ', 'T');

              createMarker.newmegaphone['gatherFinishdate'] = finishdate;

              createMarker.newmegaphone['gatherDesigncode'] = _categoryindex;

              createMarker.file = file;

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateFootMap()));
            }
          },
          icon: Image.asset('asset/megaphone.png'),
          iconSize: 75,
        )),
      ],
    ));
  }
}
