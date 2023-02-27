// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:pcos_app/controller/map_clipboard.dart';
// import 'package:pcos_app/view/map/map_favorite.dart';
// import 'package:pcos_app/widget/map/hospital_data.dart';
// import 'package:provider/provider.dart';

// class MapListview extends StatelessWidget {
//   const MapListview({super.key});

//   @override
//   Widget build(BuildContext context) {
    
//     final clipboard = Provider.of<MapClipboard>(context);
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
//       child: Align(
//         alignment: Alignment.bottomCenter,
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 20.0),
//           height: 150.0,
//           child: ListView.builder(
//             //List<Marker> _markers = HospitalData().loadMarkers(context),
//             itemCount: _markers.length,
//             itemBuilder: (BuildContext context, int index) {
//               Marker marker = _markers[index];
//               //print(_markers[0]);
//               String markerTitle = marker.infoWindow.title!;
//               String markerSnippet = marker.infoWindow.snippet!;
//               // print(markerSnippet);
//               return Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: _boxes(markerTitle, markerSnippet),
//               );
//             },
//             scrollDirection: Axis.horizontal,
//           ),
//         ),
//       ),
//     );
//   }

// //1-1. 리스트 뷰 디자인
//   Widget _boxes(String title, String snippet) {
    
//   return FittedBox(
//     child: Material(
//       color: const Color(0xFFF16A6E),
//       elevation: 0.0,
//       borderRadius: BorderRadius.circular(24.0),
//       // shadowColor: const Color(0xFFE45256),
//       child: Row(
//         children: [
//           Container(
//             width: 400,
//             height: 260,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(24.0),
//                 bottomLeft: Radius.circular(24.0),
//               ),
//             ),
//             child: ClipRect(
//               child: Stack(
//                 children: [
//                   Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
                              
//                               title,
//                               style: const TextStyle(
//                                 fontSize: 35.0,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFFF16A6E),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 16.0),
//                       Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Text(
//                           clipboard.copyClipboard(snippet),
//                           style: const TextStyle(
//                             fontSize: 30.0,
//                             color: Color.fromARGB(255, 149, 141, 141),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     top: 0.0,
//                     right: 0.0,
//                     child: MapFavorite(name: title)
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             width: 20.0,
//             height: 200.0,
//             decoration: const BoxDecoration(
//               color: Color(0xFFFB5A5A),
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(24.0),
//                 bottomRight: Radius.circular(24.0),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
//   }
//   }