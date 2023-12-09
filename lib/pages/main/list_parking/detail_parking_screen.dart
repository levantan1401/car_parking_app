import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';


import '../../../constants/color_constants.dart';
import '../home/direction_parking.dart';

class ParkingItemScreen extends StatelessWidget {
  final String idParking;
  final String name;

  final String address;
  final String? description;

  final List<String>? image;
  final double lat;
  final double long;
  final int slot;
  final int max;

  const ParkingItemScreen({
    super.key,
    required this.idParking,
    required this.name,
    this.image,
    required this.address,
    this.description,
    required this.lat,
    required this.long,
    required this.slot,
    required this.max,
  });
  // const ParkingItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            // child: Image.asset("assets/images/onboarding1.png"),
            child: Image.network(
              image!.first,
              width: MediaQuery.of(context).size.width,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          buttonArrow(context),
          scroll(),
          Positioned(
            bottom: 20, // Điều chỉnh khoảng cách từ bottom tùy ý
            left: 20, // Điều chỉnh khoảng cách từ left tùy ý
            right: 20, // Điều chỉnh khoảng cách từ right tùy ý
            child: ElevatedButton(
              onPressed: () {
                if (slot > 0) {
                  print("Click " + name);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DirectionParking(
                        // idParking: idParking, // Truyền thông tin sản phẩm
                        lat: lat,
                        lng: long,
                      ),
                    ),
                  );
                } else {
                  // showToast(context, "Đã hết chỗ đổ xe trống");
                  showCustomDialog(context, "Thông báo",
                      "Hiện tại đã hết chỗ đổ xe trống\nVui lòng quay lại sau.");
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF567DF4), // Sử dụng màu #567DF4
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fixedSize: Size.fromHeight(50), // Điều chỉnh chiều cao ở đây
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10), // Khoảng cách giữa icon và text
                  Text(
                    "Chỉ Đường",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info), // Biểu tượng mặc định
              SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog khi nhấn nút OK
              },
            ),
          ],
        );
      },
    );
  }

  buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(221, 187, 187, 187),
          ),
          child: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Color.fromARGB(255, 3, 3, 3),
            ),
          ),
        ),
      ),
    );
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.65,
        maxChildSize: 1.0,
        minChildSize: 0.65,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 228, 228, 228),
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 35,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(address, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(
                    height: 15,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Đảm bảo các phần tử con căn giữa theo chiều ngang
                      children: [
                        // Button hiển thị số lượng vị trí còn trống
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 245, 150, 136),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Căn giữa theo chiều ngang
                              children: [
                                const Icon(
                                  Icons.directions_car,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  slot == 0 ? 'ĐÃ HẾT CHỖ' : '$slot còn trống',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10), // Khoảng cách giữa hai button
                        // Button hiển thị tổng số chỗ đỗ xe
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Căn giữa theo chiều ngang
                              children: [
                                Icon(
                                  Icons.local_parking,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Tổng $max chỗ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Text(
                    "Mô tả",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Html(
                      data: description!,
                      ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Text(
                    "Dịch vụ: ",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return ingredients(context, "Dịch Vụ Giữ Xe Qua Đêm");
                        case 1:
                          return ingredients(context, "An Ninh 24/7");
                        case 2:
                          return ingredients(context, "Dịch Vụ Rửa Xe");
                        default:
                          return const SizedBox
                              .shrink(); // Trả về widget trống nếu index không phù hợp
                      }
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Text(
                    "Một số hình ảnh khác: ",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: image?.length,
                    itemBuilder: (context, index) {
                      String imageUrl = image![index];
                      print("IMAGE " + imageUrl);
                      switch (index) {
                        case 0:
                          return steps(context,
                              "https://filesdata.cadn.com.vn//filedatacadn/media/800/2023/4/18/2p-2.jpg");
                        case 1:
                          return steps(context,
                              "https://xedanangdihoian.vn/wp-content/uploads/2022/11/B%C3%A3i-%C4%91%E1%BA%ADu-xe-H%E1%BB%99i-An-2.png");
                        case 2:
                          return steps(context,
                              "https://staticgthn.kinhtedothi.vn/zoom/868/uploaded/thanhluangthn/2022_12_02/z3930165931059f690746b9dfde564da1cec88126e533b_scss.jpg");
                        default:
                          return const SizedBox
                              .shrink(); // Trả về widget trống nếu index không phù hợp
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  ingredients(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: Color.fromARGB(0, 227, 255, 248),
            child: Image.asset(
              'assets/images/icon_tick.png',
              width: 55,
              height: 55,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  steps(BuildContext context, String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // CircleAvatar(
          //   backgroundColor: ColorsConstants.kMainColor,
          //   radius: 12,
          //   child: Text("${index + 1}"),
          // ),
          // Image.asset(
          //   "assets/images/splash.png",
          //   height: 155,
          //   width: 270,
          // )
          ClipRRect(
            borderRadius: BorderRadius.circular(
                10.0), // Điều chỉnh giá trị để tạo độ cong
            child: Image.network(
              image,
              width: MediaQuery.of(context).size.width - 50,
              height: 250,
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}
