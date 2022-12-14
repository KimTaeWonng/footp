import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:app_footp/signIn.dart';
import 'package:app_footp/mainMap.dart';
import 'package:app_footp/components/mainMap/footList.dart' as footlist;
import 'package:app_footp/components/msgFoot/reportModal.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:app_footp/components/userSetting/myFoot.dart';

const serverUrl = 'http://k7a108.p.ssafy.io:8080/';

class StampFoot extends StatefulWidget {
  Map<String, dynamic> normalmsg;
  StampFoot(this.normalmsg, {Key? key}) : super(key: key);

  @override
  State<StampFoot> createState() => _StampFootState();
}

class _StampFootState extends State<StampFoot> {
  @override
  int heartnum = 0;

  late VideoPlayerController _videocontroller;

  late Future<void> _initializeVideoPlayerFuture;

  List<String> heartList = ["imgs/heart_empty.png", "imgs/heart_color.png"];
  UserData user = Get.put(UserData());

  bool click_play = false;
  final _player = AudioPlayer();

  void initState() {
    _videocontroller = VideoPlayerController.network(
      widget.normalmsg["messageFileurl"],
    );

    _initializeVideoPlayerFuture = _videocontroller.initialize();

    super.initState();
  }

  void dispose() {
    _videocontroller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    //VideoPlayerController _videocontroller;
    footlist.ListMaker listmaker = footlist.listmaker;
    MyFootPageState myfoot;

    double width = MediaQuery.of(context).size.width * 0.62;
    widget.normalmsg["isMylike"] ? heartnum = 1 : heartnum = 0;
    heartCheck();

    // print("메시지 정보보보보");
    // print(widget.normalmsg);

    //AudioPlayer player = new AudioPlayer();

    return GestureDetector(
        onTap: () {
          maindata.moveMapToMessage(widget.normalmsg["messageLatitude"],
              widget.normalmsg["messageLongitude"]);
          listmaker.listcontroller.reset();
          listmaker.refresh();
          Fluttertoast.showToast(
              msg: "해당 메세지로 지도를 이동하였습니다.",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: const Color(0xff6E6E6E),
              fontSize: 13,
              toastLength: Toast.LENGTH_SHORT);
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Card(
              child: Container(
                decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black, width: 3),
                                      borderRadius: BorderRadius.circular(20),
                                      ),
            // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Text(
                      changeDate(widget.normalmsg["messageWritedate"]),
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 110, 110, 110)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 15,
                ),
                //중간
                Container( 
                  padding: EdgeInsets.fromLTRB(20, 0, 15, 0),
                  // color: Colors.red,
                    child: (widget.normalmsg["messageFileurl"] != "empty")
                        ? Row(
                            children: [
                              fileCheck(widget.normalmsg["messageFileurl"]) != -1
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      height: MediaQuery.of(context).size.width * 0.3,
                                      child: (() {
                                        int flag = fileCheck(
                                            widget.normalmsg["messageFileurl"]);
                                        if (flag == 0) {
                                          //이미지
                                          print("이미지");
                                          return Image.network(
                                              widget.normalmsg["messageFileurl"]);
                                        } else if (flag == 1) {
                                          //비디오
                                          print("비디오");
                                          // print(_videocontroller);
                                          return FutureBuilder(
                                              future:
                                                  _initializeVideoPlayerFuture,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  return AspectRatio(
                                                    aspectRatio: _videocontroller
                                                        .value.aspectRatio,
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          print(_videocontroller
                                                              .value.isPlaying);
                                                          if (_videocontroller
                                                              .value.isPlaying) {
                                                            print("중지");
                                                            _videocontroller
                                                                .pause();
                                                          } else {
                                                            print("시작");
                                                            print(
                                                                _videocontroller);
                                                            _videocontroller
                                                                .play();
                                                          }
                                                        });
                                                      },
                                                      child: VideoPlayer(
                                                          _videocontroller),
                                                    ),
                                                  );
                                                } else {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                              });
                                        } else if (flag == 2) {
                                          //오디오
                                          return click_play == false
                                              ? IconButton(
                                                  icon: Icon(Icons.play_arrow,
                                                      size: 30),
                                                  onPressed: () {
                                                    _player.stop();
                                                    // print("재생!!");

                                                    click_play = true;
                                                    _player.setUrl(
                                                        widget.normalmsg[
                                                            "messageFileurl"]);
                                                    _player.play();

                                                    print(click_play);
                                                  },
                                                )
                                              : IconButton(
                                                  icon:
                                                      Icon(Icons.pause, size: 30),
                                                  onPressed: () {
                                                    _player.stop();
                                                    // print("멈춰!!");
                                                    click_play = false;
                                                    print(click_play);
                                                  },
                                                );
                                        }
                                      })(),
                                    )
                                  : Text(""),
                              Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    widget.normalmsg["messageText"], //100자로 제한
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 110, 110, 110)),
                                  ))
                            ],
                          )
                        : Container(
                          alignment: Alignment.centerLeft,
                          //height: 100,
                          child: Text(
                            widget.normalmsg["messageText"], //100자로 제한
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 110, 110, 110)),
                          ),
                        )),
                // 비밀글
                (maindata.hiddenMessage[widget.normalmsg["messageId"]] != null)
                    ? Container(
                        height: 50,
                        //width: width,
                        child: Text(
                          maindata.hiddenMessage[
                              widget.normalmsg["messageId"]] ??= "",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 110, 110, 110)),
                        ))
                    : Container(color: Colors.pink),
                // 주소
                Container(
                  // color: Colors.green,
                    height: 30,
                    // width: width,
                    child: Text(
                      maindata.address[widget.normalmsg["messageId"]] ??= "",
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 110, 110, 110)),
                    )),
                //하단
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (!user.isLogin()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn()),
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return widget.normalmsg["userNickname"] ==
                                        user.userinfo["userNickname"]
                                    ? AlertDialog(
                                        title: Text("확성기 삭제하기"),
                                        content: SingleChildScrollView(
                                          child: ListBody(children: <Widget>[
                                            Text('삭제하시겠습니까??')
                                          ]),
                                        ),
                                        actions: <Widget>[
                                            TextButton(
                                                onPressed: () {
                                                  deleteMessage(widget
                                                      .normalmsg["messageId"]);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("삭제")),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("취소"))
                                          ])
                                    : ReportModal(widget.normalmsg["messageId"],
                                        user.userinfo["userId"]);
                              });
                        }
                      },
                      icon: Icon(Icons.more_horiz, size: 30),
                    ),
                    Container(
                      // padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: Row(children: [
                        InkWell(
                            child: Image.asset(
                              heartList[heartnum],
                              width: 30,
                              height: 30,
                            ),
                            onTap: () {
                              if (!user.isLogin()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignIn()),
                                );
                              } else {
                                heartChange();
                              }
                            }),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 40,
                          //height:30,
                          child: Text(
                            widget.normalmsg["messageLikenum"].toString(),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )
                      ]),
                    )
                  ],
                )
              ],
            ),
          )),
        ));
  }

  int fileCheck(String file) {
    //이미지 0 영상 1 음성 2
    // print("########파일체크크#####");
    // print(file);

    if (file.endsWith('jpg') || file.endsWith('jpeg')) {
      return 0;
    } else if (file.endsWith('mp4')) {
      return 1;
    } else if (file.endsWith('mp3')) {
      return 2;
    }
    return -1;
  }

  String changeDate(String date) {
    String newDate = "";

    newDate = date.replaceAll('T', "  ");

    return newDate;
  }

  void heartRequest(context, var heartInfo) async {
    final uri = Uri.parse(serverUrl +
        'foot/' +
        heartInfo +
        "/" +
        widget.normalmsg["messageId"].toString() +
        "/" +
        '${user.userinfo["userId"]}'.toString());

    print("하트하트하트하트");
    print(uri);

    http.Response response;

    if (heartInfo == "like") {
      response = await http.post(uri);
    } else {
      response = await http.delete(uri);
    }

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      print(decodedData);
    } else {
      print(response.statusCode);
    }
  }

  void heartCheck() {
    if (widget.normalmsg["isMylike"] == false) {
      heartnum = 0;
    } else {
      heartnum = 1;
    }
  }

  void heartChange() {
    setState(() {
      var heartInfo = "";
      if (heartnum == 0) {
        heartnum = 1;
        widget.normalmsg["isMylike"] = true;
        widget.normalmsg["messageLikenum"] =
            widget.normalmsg["messageLikenum"] + 1;
        heartInfo = "like";
      } else {
        heartnum = 0;
        widget.normalmsg["isMylike"] = false;
        widget.normalmsg["messageLikenum"] =
            widget.normalmsg["messageLikenum"] - 1;
        heartInfo = "unlike";
      }
      heartRequest(context, heartInfo);
    });
  }

  void deleteMessage(int messageId) async {
    final uri = Uri.parse(serverUrl + 'user/myfoot/' + '$messageId');

    print("메시지 삭제");
    print(uri);
    http.Response response = await http.delete(uri);
    print(uri);
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      print(decodedData);
    } else {
      print('실패패패패패패ㅐ퍂');
      print(response.statusCode);
    }
  }
}
