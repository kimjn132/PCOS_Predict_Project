import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class MapClipboard extends ChangeNotifier {
  //clipboard에 복사하는 함수(미완성)
  void copyClipboard(String txt) {
    Clipboard.setData(ClipboardData(text: txt));
    Get.snackbar('Message', '주소가 클립보드에 복사되었습니다.');

    notifyListeners();
  }

  //전화거는 함수
  // void makePhoneCall(String url) async {
  //    var telUrl = 'tel:' + url;
  //    if (GetPlatform.isIOS) {
  //      telUrl =
  //          telUrl.replaceAll((new RegExp(r'-')), '');
  //    }
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     printError(info: '연결이 되지 않습니다.');
  //   }

  //   notifyListeners();
  // }

}