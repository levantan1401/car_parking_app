import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';
import 'package:giuaki_map_location/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Tìm kiếm Bãi Đỗ Xe",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            // SEARCH
            SizedBox(
              height: 60.h,
              width: 360.w,
              // color: ColorsConstants.kBackgroundColor,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: TextField(
                  style: TextStyle(
                    color: const Color(0xff020202),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Tìm kiếm bãi đỗ xe",
                    hintStyle: TextStyle(
                        color: const Color(0xffb2b2b2),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                        decorationThickness: 4),
                    suffixIcon: IconButton(
                      onPressed: () {
                        print("<CLICK> SEARCH");
                      },
                      icon: Icon(
                        Icons.search,
                        size: 30.sp,
                      ),
                    ),
                    suffixIconColor: ColorsConstants.kActiveColor,
                  ),
                ),
              ),
            ),
            // LIST RESULT
            Card(
              elevation: 3.0,
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side - Image
                  Container(
                    width: 150.0,
                    padding: EdgeInsets.all(8.0.sp),
                    child: Image.network(
                      "https://nld.mediacdn.vn/2019/7/6/6-7-bai-giu-xe-chat-chemanh-3-15623843597221490538198.jpg",
                      height: 130.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Right side - Information
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: 10.0.sp, top: 10.sp, bottom: 4.sp),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Trạm Đại Học Ngoại Ngữ Cơ Sở 2 Số 41 Đường Lê Duẩn",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "Số 41 Đường Lê Duẩn - Phường Hải Châu 1 - Quận Hải Châu - TP Đà Nẵng",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "Số vị trí trống: " + "25",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
