import 'package:flutter/material.dart';

import '../data/models/vietmap_reverse_model.dart';

class AddressInfo extends StatelessWidget {
  final VietmapReverseModel? data;
  final VoidCallback buildRoute;
  final VoidCallback buildAndStartRoute;
  const AddressInfo(
      {super.key,
      this.data,
      required this.buildRoute,
      required this.buildAndStartRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TÊN ĐƯỜNG',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          Text("ĐỊA CHỈ"),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.blue)))),
                  onPressed: () {
                    buildRoute();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.alt_route_sharp, size: 17),
                      Text('Đường đi')
                    ],
                  )),
              TextButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.blue)))),
                  onPressed: () {
                    buildAndStartRoute();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_upward_rounded, size: 17),
                      Text('Bắt đầu'),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}