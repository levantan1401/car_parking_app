import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../constants/color_constants.dart';

class ParkingItemScreen extends StatelessWidget {
  final String idParking;
  final String name;

  final String address;

  final String image;

  const ParkingItemScreen({
    super.key,
    required this.idParking,
    required this.name,
    required this.image,
    required this.address,
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
              image,
              width: MediaQuery.of(context).size.width,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          buttonArrow(context),
          scroll(),
        ],
      ),
    ));
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
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(address, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //           ProfileTap(showFollowBottomInProfile: true),
                          //     ));
                        },
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              AssetImage("assets/imges/Avatar3.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text("Elena Shelby",
                          style: Theme.of(context).textTheme.headline3!),
                      const Spacer(),
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: ColorsConstants.kSecondColor,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text("273 Likes",
                          style: Theme.of(context).textTheme.headline3!),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      'Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your',
                      style: Theme.of(context).textTheme.bodyText2!),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Text(
                    "Ingredients",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) => ingredients(context),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Text(
                    "Steps",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) => steps(context, index),
                  ),
                ],
              ),
            ),
          );
        });
  }

  ingredients(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 10,
            backgroundColor: Color(0xFFE3FFF8),
            child: Icon(
              Icons.done,
              size: 15,
              color: ColorsConstants.kSecondColor,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "4 Eggs",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }

  steps(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundColor: ColorsConstants.kMainColor,
            radius: 12,
            child: Text("${index + 1}"),
          ),
          Column(
            children: [
              SizedBox(
                width: 270,
                child: Text(
                  "Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your",
                  maxLines: 3,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: ColorsConstants.kMainColor),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                "assets/imges/Rectangle 219.png",
                height: 155,
                width: 270,
              )
            ],
          )
        ],
      ),
    );
  }
}
