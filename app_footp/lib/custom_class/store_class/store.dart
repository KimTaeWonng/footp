import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:log_print/log_print.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:app_footp/mainMap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart' as DIO;

//일반 or 이벤트 모드
class ModeController extends GetxController {
  int _mode = 0;

  int get mode => _mode;

  void press(int index) {
    _mode = index;
    update();
  }
}

//내위치 클래스
class MyPosition extends GetxController {
  double _latitude = 37.566570;
  double _longitude = 126.978442;

  double get latitude => _latitude;
  double get longitude => _longitude;

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _latitude = position.latitude;
    _longitude = position.longitude;
    update();
  }
}

//마커 생성 클래스
class CreateMarker extends GetxController {
  double _latitude = 37.566570;
  double _longitude = 126.978442;

  double get latitude => _latitude;
  double get longitude => _longitude;

  List<Marker> _list = [];
  List<Marker> get list => _list;

  var _newmarker = {
    "isOpentoall": true,
    "messageLatitude": 37.72479485462167,
    "messageLongitude": 128.71639982661415,
    "messageText": "test!",
    "userId": 7,
    "messageWritedate": DateTime.now().toString(),
    "isBlurred": false,
    "messageBlurredtext": "",
  };

  var _newmegaphone = {
    "gatherLatitude": 37.72479485462167,
    "gatherLongitude": 128.71639982661415,
    "gatherText": "모집합니다",
    "gatherWritedate": DateTime.now().toString(),
    "gatherFinishdate": "2022-11-03T01:37",
    "gatherDesigncode": 1,
    "userId": 1
  };

  DIO.MultipartFile? file;

  String filePath = '';

  Map get newmarker => _newmarker;
  Map get newmegaphone => _newmegaphone;

  Marker _marker = Marker(
      markerId: 'marker1', position: LatLng(0, 0), width: 40, height: 40);

  //탭한 부분 위도경도 받아오기
  void tapped(double a, double b) {
    _latitude = a;
    _longitude = b;
    Marker temp = _marker;
    temp.position = (LatLng(a, b));
    _newmarker["messageLatitude"] = a;
    _newmarker["messageLongitude"] = b;
    _newmegaphone["gatherLatitude"] = a;
    _newmegaphone["gatherLongitude"] = b;
    // _list.add(Marker(markerId: '$a', position: LatLng(a,b)));
    _list.insert(0, temp);
    update();
    // print('@@@@$_list)');
  }

  //마커 이미지 생성
  Future<void> createImage(BuildContext context, int i) async {
    if (i == 0) {
      _marker.icon =
          await OverlayImage.fromAssetImage(assetName: "asset/foot_2.png");
    } else {
      _marker.icon =
          await OverlayImage.fromAssetImage(assetName: "asset/megaphone_2.png");
    }
    update();
  }
}

//유저 데이터
class UserData extends GetxController {
  //토큰들
  String _Token = "";
  String _Mypayurl = "";
  bool _isPayRequest = false;

  Map _userinfo = {
    "userId": null,
    "userEmail": "",
    "userPassword": "",
    "userNickname": "",
    "userEmailKey": "",
    "userSocial": null,
    "userSocialToken": null,
    "userPwfindkey": "invaild",
    "userPwfindtime": null,
    "userCash": 0
  };

  Map get userinfo => _userinfo;

  //토큰들
  String get Token => _Token;
  String get Mypayurl => _Mypayurl;
  bool get isPayRequest => _isPayRequest;

  get userNickname => null;

  //로그인 토큰저장
  void login(String a) {
    _Token = a;
    LogPrint("$_Token");
    update();
  }

  void logout() {
    _Token = "";
    update();
  }

  //토큰이 있는지 없는지 확인
  bool isLogin() {
    if (_Token == "") {
      return false;
    } else
      return true;
  }

  void payRequest() {
    _isPayRequest = true;
  }

  void paySuccess() {
    _userinfo["userCash"] += 50000;
    update();
  }

  void megaCost() {
    _userinfo["userCash"] -= 50000;
    update();
  }

  void payRequestDone() {
    _isPayRequest = false;
  }

  //payload 디코딩
  Map<String, dynamic>? decoding_payload(String token) {
    if (token == null) return null;
    final parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var resp = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(resp);
    if (payloadMap is! Map<String, dynamic>) {
      return null;
    }
    return payloadMap;
  }

  void userinfoSet(Map a) {
    _userinfo = a;
  }

  void payurlSet(String url) {
    _Mypayurl = url;
  }
}

class Category {
  final String image;
  final String name;

  Category({required this.image, required this.name});
}

class JoinStampInfo extends GetxController {
  Map _joinedStamp = {};
  Map<String, dynamic> _message1 = {};
  Map<String, dynamic> _message2 = {};
  Map<String, dynamic> _message3 = {};
  List _joinedMessages = [];

  Map<String, dynamic> get message1 => _message1;
  Map<String, dynamic> get message2 => _message2;
  Map<String, dynamic> get message3 => _message3;
  Map get joinedStamp => _joinedStamp;
  List get joinedMessages => _joinedMessages;

  set message1(value) => _message1 = value;
  set message2(value) => _message2 = value;
  set message3(value) => _message3 = value;
  set joinedStamp(value) => _joinedStamp = value;
  set joinedMessages(value) => _joinedMessages = value;
}

class StampMessage extends GetxController {
  Map<String, dynamic> _stampMessage1 = {};
  Map<String, dynamic> _stampMessage2 = {};
  Map<String, dynamic> _stampMessage3 = {};
  Map _viewStamp = {};
  String _markerString = '';

  Map<String, dynamic> get stampMessage1 => _stampMessage1;
  Map<String, dynamic> get stampMessage2 => _stampMessage2;
  Map<String, dynamic> get stampMessage3 => _stampMessage3;
  Map get viewStamp => _viewStamp;
  String get markerString => _markerString;

  set stampMessage1(value) => _stampMessage1 = value;
  set stampMessage2(value) => _stampMessage2 = value;
  set stampMessage3(value) => _stampMessage3 = value;
  set viewStamp(value) => _viewStamp = value;
  set markerString(value) => _markerString = value;

  void getStampAddress(Map<String, dynamic> message) async {
    String lat = message["messageLatitude"].toString();
    String lng = message["messageLongitude"].toString();

    Map<String, String> clientkey = {
      "X-NCP-APIGW-API-KEY-ID": "9foipum14s",
      "X-NCP-APIGW-API-KEY": "scvqRxQKoZo5vULsFL1vrE56tqKcOl7u1z16iWz2"
    };

    if (maindata.address.containsKey(message["messageId"])) {
      // print("continue");
    } else {
      http.Response response = await http.get(
          Uri.parse(
              "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${lng},${lat}&sourcecrs=epsg:4326&orders=addr,roadaddr&output=json"),
          headers: clientkey);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(utf8.decode(response.bodyBytes));
        if (jsondata["status"]["code"] == 0) {
          if (jsondata["results"].length > 1) {
            maindata.address[message["messageId"]] =
                "${jsondata["results"][1]["region"]["area1"]["name"]} ${jsondata["results"][1]["region"]["area2"]["name"]} ${jsondata["results"][1]["land"]["name"]} ${jsondata["results"][1]["land"]["number1"]} ${jsondata["results"][1]["land"]["addition0"]["value"]}";
          } else {
            maindata.address[message["messageId"]] =
                "${jsondata["results"][0]["region"]["area1"]["name"]} ${jsondata["results"][0]["region"]["area2"]["name"]} ${jsondata["results"][0]["region"]["area3"]["name"]} ${jsondata["results"][0]["region"]["area4"]["name"]} ${jsondata["results"][0]["land"]["type"] == "1" ? "" : "산"} ${jsondata["results"][0]["land"]["number1"]}-${jsondata["results"][0]["land"]["number2"]}";
          }
        } else {
          maindata.address[message["messageId"]] = "";
        }
        update();
      } else {
        print(response.statusCode);
        throw 'getAddress() error';
      }
    }
  }

  void createStampMarker(Map<String, dynamic> message) {
    int like = (message["messageLikenum"] / 5).toInt();
    int color = 0;
    _markerString =
        "${message["userNickname"]}      \u{2764} ${message["messageLikenum"].toString()}\n${message["messageText"]}\n\n${maindata.address[message["messageId"]] ??= ""}\n${changeDate(message["messageWritedate"])}";

    if (like >= 45) {
      like = 44;
    }

    if (message["isBlurred"] == true) {
      color = 7;
    } else {
      color = message["messageId"] % 7;
    }

    Marker marker = Marker(
        markerId: message["messageId"].toString(),
        position:
            LatLng(message["messageLatitude"], message["messageLongitude"]),
        icon: maindata.footImage[color],
        width: 5 * (6 + like),
        height: 5 * (6 + like),
        onMarkerTab: (marker, iconSize) {
          // print("Hi ${dataList["message"][idx]["messageId"]}");
        },
        infoWindow: markerString);

    maindata.markers.add(marker);
    update();
  }

  String changeDate(String date) {
    String newDate = "";
    newDate = date.replaceAll('T', "  ");

    return newDate;
  }
}
