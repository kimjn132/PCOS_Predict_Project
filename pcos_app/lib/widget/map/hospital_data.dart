import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalData {
  //병원 마커 찍기

  Future<List<Marker>> loadMarkers(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('datas/hospital_json.json');
    List<dynamic> markersJson = json.decode(data);
    // print(markersJson);
    List<Marker> markers = markersJson.map((marker) {
      return Marker(
        markerId: MarkerId(marker['name'].toString()),
        position: LatLng(marker['latitude'], marker['longitude']),

        infoWindow: InfoWindow(
          title: marker['name'],
          snippet:
              '전화: ${marker['call']}\n주소: ${marker['address']}',
          onTap: () {
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(16.0),
            //       topRight: Radius.circular(16.0),
            //     ),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.2),
            //         blurRadius: 6.0,
            //         spreadRadius: 2.0,
            //       ),
            //     ],
            //   ),
            //   child: ListView.builder(
            //     itemCount: marker.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       return Card(
            //         child: ListTile(
            //           title: Text(marker.title[index]),
            //           subtitle: Text(marker.snippet[index]),
            //           onTap: () {
            //             // Handle marker tap
            //           },
            //         ),
            //       );
            //     },
            //   ),
            // );
          },
        ),

        //icon: BitmapDescriptor.defaultMarker,
      );
    }).toList();

    return markers;
  }


//clipboard에 복사하는 함수(미완성)
  void copyClipboard(String txt) {
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
}



// class MarkerListSheet extends StatefulWidget {
//   final String title;
//   final String snippet;

//   const MarkerListSheet(
//       {super.key, required this.title, required this.snippet});

//   @override
//   // ignore: library_private_types_in_public_api
//   _MarkerListSheetState createState() => _MarkerListSheetState();
// }

// class _MarkerListSheetState extends State<MarkerListSheet> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(16.0),
//           topRight: Radius.circular(16.0),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 6.0,
//             spreadRadius: 2.0,
//           ),
//         ],
//       ),
//       child: ListView.builder(
//         itemCount: widget.title.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Card(
//             child: ListTile(
//               title: Text(widget.title[index]),
//               subtitle: Text(widget.snippet[index]),
//               onTap: () {
//                 // Handle marker tap
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
