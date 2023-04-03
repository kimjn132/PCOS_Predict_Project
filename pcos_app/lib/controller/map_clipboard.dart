import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';


class MapClipboard extends ChangeNotifier {

  MapClipboard();

  //clipboard에 복사하는 함수(미완성)
  void copyClipboard(String txt) {
    Clipboard.setData(ClipboardData(text: txt));
    Get.snackbar('Message', '주소가 클립보드에 복사되었습니다');
    notifyListeners();
  }


  //전화거는 함수
  
  void makePhoneCall(String phoneNumber) async {
    String telUrl = 'tel:$phoneNumber';
    if (await canLaunchUrlString(telUrl)) {
      await launchUrlString(telUrl);
    } else {
      throw 'Could not launch $telUrl';
    }
    notifyListeners();
  }
  
}