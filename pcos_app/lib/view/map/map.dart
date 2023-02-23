import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pcos_app/widget/map/hospital_data.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  //google map basic controller
  late Completer<GoogleMapController> googleController = Completer();
  late GoogleMapController mapController;

  // google camera position check controller
  late CameraUpdate cameraUpdate;

  // 위도 경도 값
  late double latitude;
  late double longitude;
  // 위도 경도 값 받아서 바운더리
  late LatLngBounds bounds;

  // 초기 카메라 위치(서울 중심)
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.5665, 126.9780),
    zoom: 14.4746,
  );

  // 병원 마커 및 gps 처리 클래스 인스턴스
  HospitalData csvdata = HospitalData();

  // 병원 마커 데이터값 변환을 위한 변수
  List<Marker> allMarkers = [];
  List<Marker> _markers = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            // myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex, // 초기 카메라 위치
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            // 마커 찍어주기 (_markers 는 gps 위치 중심으로 반경 500m에 있는 마커 only)
            markers: Set<Marker>.from(_markers),

            onCameraIdle: () {
              setState(() {
                _markers;
              });
            },
          ),
        ],
      ),
      floatingActionButton: 
      Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Align(
              alignment: Alignment.topRight,
              child: gps(),
            ),
          ),
          // 찍은 마커 정보 리스트뷰로 정보 제공
          _buildcontainer()
        ],
      ),
    );
  }


// 1. 찍은 마커 정보 리스트뷰로 정보 제공
  Widget _buildcontainer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          height: 150.0,
          child: ListView.builder(
            itemCount: _markers.length,
            itemBuilder: (BuildContext context, int index) {
              Marker marker = _markers[index];
              String markerFinal = marker.infoWindow.title!;
              String markersnippet = marker.infoWindow.snippet!;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: _boxes(markerFinal, markersnippet),
              );
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
      ),
    );
  }

//1-1. 리스트 뷰 디자인
  Widget _boxes(String title, String snippet) {
    return Container(
      child: FittedBox(
        child: Material(
          color: const Color(0xFFF16A6E),
          elevation: 0.0,
          borderRadius: BorderRadius.circular(24.0),
          shadowColor: const Color(0xFFE45256),
          child: Row(
            children: [
              Container(
                width: 270,
                height: 220,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    bottomLeft: Radius.circular(24.0),
                  ),
                ),
                child: ClipRect(
                  child: Column(
                    children: [
                      const SizedBox(height: 16.0),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF16A6E),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          snippet,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 149, 141, 141),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 20.0,
                height: 200.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFFB5A5A),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24.0),
                    bottomRight: Radius.circular(24.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 지역 내 검색 바운더리 만들기
  LatLngBounds _getVisibleRegion() {
    try {
      LatLng center = LatLng(latitude, longitude);
      double radius = 500; // 500m radius

      // Earth's radius in meters
      const earthRadius = 6378137.0;

      double lat = center.latitude;
      double lng = center.longitude;
      double dLat = radius / earthRadius;
      double dLng = radius / (earthRadius * cos(pi / 180.0 * lat));
      

      double swLat = lat - dLat * 180.0 / pi;
      double swLng = lng - dLng * 180.0 / pi;
      double neLat = lat + dLat * 180.0 / pi;
      double neLng = lng + dLng * 180.0 / pi;

      LatLng southwest = LatLng(swLat, swLng);
      LatLng northeast = LatLng(neLat, neLng);

      // Create the LatLngBounds object
      bounds = LatLngBounds(southwest: southwest, northeast: northeast);
      return bounds;
    } catch (e) {
      // 예외가 발생한 경우 처리할 코드
      return LatLngBounds(
        southwest: const LatLng(37.5665, 126.9780),
        northeast: const LatLng(37.5665, 126.9780),
      );
    }
  }

// json으로 가져온 병원 정보 마커 리스트로 변환 후(HospitalData class에서 처리) 해당 바운더리 마커만 변수에 담아줌
  Future<void> _loadMarkers() async {
    // Load the markers from your data source
    allMarkers = await csvdata.loadMarkers(context);

    // Filter the markers to show only the ones that are inside the visible region
    List<Marker> visibleMarkers =
        allMarkers.where((marker) => bounds.contains(marker.position)).toList();

    // Update the state to show the visible markers
    setState(() {
      _markers = visibleMarkers;
      //print(_markers);
    });
  }


//clipboard에 복사하는 함수(미완성)
  void copyClipboard(String txt){
    Clipboard.setData(ClipboardData(text: txt));
    Get.snackbar('Message', '주소가 클립보드에 복사되었습니다.');
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
  // }


  //-----widget for floating buttong---------

// gps값 잡기
  Widget gps() {
    return // floatingActionButton을 누르게 되면 _goToTheLake 실행된다.
        FloatingActionButton(
      onPressed: () async {
        var gps = await csvdata.getCurrentLocation();
        mapController.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(gps.latitude, gps.longitude),
          ),
        );

        longitude = gps.longitude;
        latitude = gps.latitude;

        bounds = _getVisibleRegion();
        //버튼 누르면 실행할 함수
        _loadMarkers();
      },
      backgroundColor: Colors.white,
      child: const Icon(
        Icons.my_location,
        color: Colors.black,
      ),
    );
  } // gps floating button


// 지도 줌인 줌아웃 - 만들어 놨으나 사용할 지 말지 미정
  // Widget zoomout() {
  //   return FloatingActionButton(
  //     onPressed: () {
  //       mapController.animateCamera(CameraUpdate.zoomOut());
  //     },
  //     child: const Icon(Icons.zoom_out),
  //   );
  // } //zoomout

  // Widget zoomin() {
  //   return FloatingActionButton(
  //     onPressed: () {
  //       mapController.animateCamera(CameraUpdate.zoomIn());
  //     },
  //     child: const Icon(Icons.zoom_in),
  //   );
  // } //zoomin
} //End

