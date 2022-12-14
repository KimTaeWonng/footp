import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:app_footp/mainMap.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;

Notice notice = Notice();

class Notice extends GetxController {
  late StompClient stompClient;
  late MainData maindata;
  var jsondata;
  bool ready = false;
  String result = "서울시 강남구";
  Map<String, String> clientkey = {
    "X-NCP-APIGW-API-KEY-ID": "9foipum14s",
    "X-NCP-APIGW-API-KEY": "scvqRxQKoZo5vULsFL1vrE56tqKcOl7u1z16iWz2"
  };

  Notice() {
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: "http://k7a108.p.ssafy.io:8080/wss",
        beforeConnect: () async {
          print("알리미 연결중");
        },
        onConnect: (p0) async {
          print("알리미 연결 완료");
          stompClient.subscribe(
              destination: '/notice',
              callback: (frame) {
                Map<String, dynamic> msgMap = jsonDecode(frame.body.toString());
                where(msgMap["gatherLatitude"], msgMap["gatherLongitude"]);
                showToast(msgMap);
              });
        },
      ),
    );
    stompClient.activate();
  }

  Future<void> send(Map<dynamic, dynamic> map) async {
    if (stompClient.connected) {
      stompClient.send(
        destination: "/app/notice",
        body: jsonEncode(map),
      );
    }
  }

  where(double lng, double lat) async {
    http.Response response = await http.get(
        Uri.parse(
            "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${lng},${lat}&sourcecrs=epsg:4326&orders=addr,roadaddr&output=json"),
        headers: clientkey);
    if (response.statusCode == 200) {
      ready = true;
      jsondata = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsondata["status"]["code"] == 0) {
        if (jsondata["results"].length > 1) {
          result =
              "${jsondata["results"][1]["region"]["area1"]["name"]} ${jsondata["results"][1]["region"]["area2"]["name"]} ${jsondata["results"][1]["land"]["name"]} ${jsondata["results"][1]["land"]["number1"]} ${jsondata["results"][1]["land"]["addition0"]["value"]}";
        } else {
          result =
              "${jsondata["results"][0]["region"]["area1"]["name"]} ${jsondata["results"][0]["region"]["area2"]["name"]} ${jsondata["results"][0]["region"]["area3"]["name"]} ${jsondata["results"][0]["region"]["area4"]["name"]} ${jsondata["results"][0]["land"]["type"] == "1" ? "" : "산"} ${jsondata["results"][0]["land"]["number1"]}-${jsondata["results"][0]["land"]["number2"]}";
        }
      }
    }
  }

  Future<void> showToast(Map<String, dynamic> map) async {
    Vibration.vibrate(duration: 1000);
    List<String> category = ['공연', '행사', '맛집', '관광', '친목'];
    Color color = Colors.yellow;
    switch (map["gatherDesigncode"]) {
      case 1:
        color = Colors.purple;
        break;
      case 2:
        color = Colors.blue;
        break;
      case 3:
        color = Colors.green;
        break;
      case 4:
        color = Colors.red;
        break;
    }
    if (ready) {
      result =
          "${jsondata["results"][0]["region"]["area1"]["name"]} ${jsondata["results"][0]["region"]["area2"]["name"]} ${jsondata["results"][0]["region"]["area3"]["name"]} ${jsondata["results"][0]["region"]["area4"]["name"]} ${jsondata["results"][0]["land"]["type"] == "1" ? "" : "산"} ${jsondata["results"][0]["land"]["number1"]}-${jsondata["results"][0]["land"]["number2"]}";
    }
    String str =
        "$result 에서 ${category[map["gatherDesigncode"]]} 이벤트가 시작되었습니다!";
    Fluttertoast.showToast(
      msg: str,
      gravity: ToastGravity.TOP,
      backgroundColor: color,
      fontSize: 20.0,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
