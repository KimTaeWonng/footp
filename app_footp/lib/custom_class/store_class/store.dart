import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'dart:convert';

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

  Map _newmarker = {
    "isOpentoall": true,
    "messageFileurl":
        "https://mblogthumb-phinf.pstatic.net/MjAxOTEyMTdfMjM5/MDAxNTc2NTgwNjQxMzIw.UIw2A-EU9OUtt5FQ_6iRP2QJQS-aFE7L_EkI_VK6ED0g.dGYlktZJPVI8Jn9z6czNo1FmNIKqNk6ap1tODyDVmswg.JPEG.ideaeditor_lee/officialDobes.jpg?type=w800",
    "messageLatitude": 37.72479485462167,
    "messageLongitude": 128.71639982661415,
    "messageText": "test!",
    "userId": 7,
    "userNickname": "",
  };

  Map get newmarker => _newmarker;

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
    // _list.add(Marker(markerId: '$a', position: LatLng(a,b)));
    _list.insert(0, temp);
    update();
    // print('@@@@$_list)');
  }

  //마커 이미지 생성
  Future<void> createImage(BuildContext context, int i) async {
    if (i == 0) {
      _marker.icon =
          await OverlayImage.fromAssetImage(assetName: "asset/normalfoot.png");
    } else {
      _marker.icon =
          await OverlayImage.fromAssetImage(assetName: "asset/eventfoot.png");
    }
    update();
  }
}

//유저 데이터
class UserData extends GetxController {
  //토큰들
  String _Token = "";

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

  get userNickname => null;

  //로그인 토큰저장
  void login(String a) {
    _Token = a;
    update();
  }

  //토큰이 있는지 없는지 확인
  bool isLogin() {
    if (_Token == "") {
      return false;
    } else
      return true;
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
}
