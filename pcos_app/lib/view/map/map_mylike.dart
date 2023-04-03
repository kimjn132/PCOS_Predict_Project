import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pcos_app/controller/map_clipboard.dart';
import 'package:pcos_app/controller/map_favorite_provider.dart';
import 'package:pcos_app/model/hospitals/hospital_list.dart';
import 'package:provider/provider.dart';

class MapMyLike extends StatelessWidget {

  const MapMyLike({super.key});

  @override
  Widget build(BuildContext context) {
    final hospitals = Provider.of<FavoriteProvider>(context).hospitalListStream;
    final clipboard = Provider.of<MapClipboard>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueGrey[800], // 앱바 색상 변경
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFBA5A8), // 앱바 색상 변경
          foregroundColor: Colors.white, // 앱바 텍스트 색상 변경
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          title: const Text(
            '방문한 병원',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
            child: StreamBuilder<List<HospitalList>>(
          stream: hospitals,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('추가한 병원이 없습니다',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(1, 1, 1, 100),
              ),
              );
            }
            final hospitals = snapshot.data!;
            return ListView.separated(
                  itemBuilder: (context, index) {
                    final hospital = hospitals[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                              child: Text(hospital.name,
                              style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(1, 1, 1, 100),
                                    ),
                              ),
                            ),
                            SizedBox(
                              width: 280,
                              child: GestureDetector(
                                onTap: () => clipboard.copyClipboard(hospital.address),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                                  child: Flexible(
                                    child: 
                                    RichText(
                                      overflow: TextOverflow.clip,
                                      maxLines: 2,
                                      text: TextSpan(
                                       text: hospital.address,
                                       style: const TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(87, 87, 87, 100),
                                          ),
                                    ))
                                    // Text(
                                    // hospital.address,
                                    // style: const TextStyle(
                                    //         fontSize: 13.0,
                                    //         fontWeight: FontWeight.bold,
                                    //         color: Color.fromRGBO(87, 87, 87, 100),
                                    //       ),
                                    // ),
                                  ),
                                )),
                            ),
                            GestureDetector(
                              onTap: () => clipboard.makePhoneCall(hospital.phone),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                                child: Text(hospital.phone,
                                style: const TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(87, 87, 87, 100),
                                      ),
                                ),
                              ))
                          ],
                        ),
                        IconButton(
                      icon: Provider.of<FavoriteProvider>(context)
                              .isFavorite(hospital.name)
                          ? const Icon(Icons.favorite)
                          : const Icon(Icons.favorite),
                      onPressed: () {
                        Provider.of<FavoriteProvider>(context, listen: false)
                                .isFavorite(hospital.name)
                            ? Provider.of<FavoriteProvider>(context,
                                    listen: false)
                                .removeFavorite(hospital.name)
                            : Provider.of<FavoriteProvider>(context,
                                    listen: false)
                                .addFavorite(hospital.name, hospital.phone,
                                    hospital.address);
                      },
                      color: const Color(0xFFF16A6E),
                    ),
                      ],
                    );
                  }, 
                  separatorBuilder: (context, index) => const Divider(
                    height: 10.0,
                    color: Colors.grey,
                  ), 
                  itemCount: hospitals.length);



                


                // ListTile(
                //   isThreeLine: true,
                //   title: Text(hospital.name),
                //   subtitle: GestureDetector(
                //     onTap: () {
                //       clipboard.copyClipboard(hospital.address);
                //       clipboard.makePhoneCall(hospital.phone);
                //     },
                //     child: Text('${hospital.address} \n ${hospital.phone}')),
                //   trailing: 
                // IconButton(
                //     icon: Provider.of<FavoriteProvider>(context)
                //             .isFavorite(hospital.name)
                //         ? const Icon(Icons.favorite)
                //         : const Icon(Icons.favorite),
                //     onPressed: () {
                //       Provider.of<FavoriteProvider>(context, listen: false)
                //               .isFavorite(hospital.name)
                //           ? Provider.of<FavoriteProvider>(context,
                //                   listen: false)
                //               .removeFavorite(hospital.name)
                //           : Provider.of<FavoriteProvider>(context,
                //                   listen: false)
                //               .addFavorite(hospital.name, hospital.phone,
                //                   hospital.address);
                //     },
                //     color: const Color(0xFFF16A6E),
                //   ),
                // );
              },
        )
        ),
      ),
    );
  }
}
