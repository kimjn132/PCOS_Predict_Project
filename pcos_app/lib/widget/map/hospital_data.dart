import 'dart:convert';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalData {
  String data = "";
  late List<dynamic> markersJson;
  late List<Marker> markers;
  
  
  //병원 마커 찍기
  Future<List<Marker>> loadMarkers(BuildContext context) async {
    data = await DefaultAssetBundle.of(context)
        .loadString('datas/hospital_json.json');
    markersJson = json.decode(data);
    
    // print(markersJson);
    markers = markersJson.map((marker) {
      return Marker(
        markerId: MarkerId(marker['name'].toString()),
        position: LatLng(marker['latitude'], marker['longitude']),

        infoWindow: InfoWindow(
          title: marker['name'],
          snippet: '전화: ${marker['call']}\n주소: ${marker['address']}',
        ),
      );
    }).toList();

    return markers;
  }

//clipboard에 복사하는 함수(미완성)
  void copyClipboard(String txt) {
    // txt = markers.
    Clipboard.setData(ClipboardData(text: txt));
    Get.snackbar('Message', '주소가 클립보드에 복사되었습니다.');
  }

// gps 나의 위치로 지도 이동

  late bool serviceEnabled;
  late LocationPermission permission;

  Future<Position> getCurrentLocation() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  } //getCurrentLocation

  // Get a Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uId = FirebaseAuth.instance.currentUser!.uid;

  

  checkIfIsFavorite(String title) async {
   
      // final bool check;
      final snapshot = await FirebaseFirestore.instance
          .collection('hospital')
          .where('hospital', isEqualTo: title)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // check = true;
        await firestore.collection('hopital').firestore.doc(title).delete();
      } else {
          // check = false;
          await firestore
          .collection('hospital')
          .add({'uId': uId, 'hospital': title});
      }

  }
}