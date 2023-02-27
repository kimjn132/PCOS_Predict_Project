import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class HospitalData {
  String data = "";
  late List<dynamic> markersJson;
  late List<Marker> markers;
  // 위도 경도 값
  // late double latitude;
  // late double longitude;
  // // 위도 경도 값 받아서 바운더리
  // late LatLngBounds bounds;
  late List<dynamic> title;
  late List<dynamic> call;
  late List<dynamic> address;
  late List<dynamic> alldetails;
  
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
  Future<List<dynamic>> loadDetails(BuildContext context) async {
    data = await DefaultAssetBundle.of(context)
        .loadString('datas/hospital_json.json');
    markersJson = json.decode(data);

        
    return markersJson;
  }

  

// json으로 가져온 병원 정보 마커 리스트로 변환 후(HospitalData class에서 처리) 해당 바운더리 마커만 변수에 담아줌
  // Future<void> _loadMarkers() async {
    // Load the markers from your data source
    //allMarkers = markers;

    // Filter the markers to show only the ones that are inside the visible region
    // List<Marker> visibleMarkers =
    //     markers.where((marker) => bounds.contains(marker.position)).toList();

    // Update the state to show the visible markers
    // setState(() {
    //   _markers = visibleMarkers;
      //print(_markers);
    // });

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

  // 지역 내 검색 바운더리 만들기
  // LatLngBounds _getVisibleRegion() {
  //   try {
  //     LatLng center = LatLng(latitude, longitude);
  //     double radius = 5000; // 500m radius

  //     // Earth's radius in meters
  //     const earthRadius = 6378137.0;

  //     double lat = center.latitude;
  //     double lng = center.longitude;
  //     double dLat = radius / earthRadius;
  //     double dLng = radius / (earthRadius * cos(pi / 180.0 * lat));

  //     double swLat = lat - dLat * 180.0 / pi;
  //     double swLng = lng - dLng * 180.0 / pi;
  //     double neLat = lat + dLat * 180.0 / pi;
  //     double neLng = lng + dLng * 180.0 / pi;

  //     LatLng southwest = LatLng(swLat, swLng);
  //     LatLng northeast = LatLng(neLat, neLng);

  //     // Create the LatLngBounds object
  //     bounds = LatLngBounds(southwest: southwest, northeast: northeast);
  //     return bounds;
  //   } catch (e) {
  //     // 예외가 발생한 경우 처리할 코드
  //     return LatLngBounds(
  //       southwest: const LatLng(37.5665, 126.9780),
  //       northeast: const LatLng(37.5665, 126.9780),
  //     );
  //   }
  // }




  // // gps값 잡기
  // Widget gps() {
  //   return // floatingActionButton을 누르게 되면 _goToTheLake 실행된다.
  //       FloatingActionButton(
  //     onPressed: () async {
  //       // var gps = await csvdata.getCurrentLocation();
  //       // mapController.animateCamera(
  //       //   CameraUpdate.newLatLng(
  //       //     LatLng(gps.latitude, gps.longitude),
  //       //   ),
  //       // );
  //       // //실제 gps
  //       // longitude = gps.longitude;
  //       // latitude = gps.latitude;

        
  //       // 임시 테스트용
  //       longitude = 126.8495;
  //       latitude = 37.5510;

  //       bounds = _getVisibleRegion();
  //       //버튼 누르면 실행할 함수
  //       _loadMarkers();
  //     },
  //     backgroundColor: Colors.white,
  //     child: const Icon(
  //       Icons.my_location,
  //       color: Colors.black,
  //     ),
  //   );
  // } // gps floating button

// }