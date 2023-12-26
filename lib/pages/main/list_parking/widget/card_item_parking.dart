import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';
import 'package:giuaki_map_location/models/station.dart';

class CardItemWidget extends StatelessWidget {
  const CardItemWidget({
    super.key,
    required this.stations,
    required this.limitSubtitle,
    required this.index
  });

  final List<Station> stations;
  final int limitSubtitle;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.only(left: 10.0.sp, right: 10.0.sp, top: 10.h),
      child: Container(
        height: 120.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Image
            Container(
              width: 150.0.w,
              padding: EdgeInsets.all(8.0.sp),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: Image.network(
                  stations[index].image.first,
                  height: 110.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Right side - Information
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: 10.0.sp, top: 10.sp, bottom: 4.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      stations[index].name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      (stations[index].address.length > limitSubtitle)
                          ? '${stations[index].address.substring(0, limitSubtitle)}...'
                          : stations[index].address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.0.sp),
                    ),
                    SizedBox(height: 4.h),
                    RichText(
                      text: TextSpan(
                          text: "Số vị trí trống:",
                          style: TextStyle(
                            color: ColorsConstants.kActiveColor,
                            fontSize: 12.sp,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: stations[index].slot.toString(),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold))
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}