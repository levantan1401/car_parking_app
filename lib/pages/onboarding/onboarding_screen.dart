import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';
import 'package:giuaki_map_location/controller/onboarding/onboarding_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  final onboardingController = Get.find<OnboardingController>();

  int currentPage = 0;
  int numberOfPages = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 40.sp),
          child: Column(
            children: [
              Expanded(child: buildPages()),
              Padding(
                padding: EdgeInsets.all(40.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildIndicator(),
                    buildActionButton(),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActionButton() {
    return TextButton(
      style: currentPage == numberOfPages-1
        ? ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(ColorsConstants.kMainColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
            ),
          )
        : ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 10.sp),
            ),
          ),
      child: Text(
        currentPage == numberOfPages-1
          ? 'Bắt đầu'
          : 'Tiếp theo',
        style: currentPage == numberOfPages-1 
          ? TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            )
          : TextStyle(
              color: ColorsConstants.kMainColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
      ), // Check current page
      onPressed: () {
        if (currentPage == numberOfPages-1) {
          onboardingController.onSkip();
        } else {
          controller.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        }
      },
    );
  }


  Widget buildPages() {
    return PageView(
      controller: controller,
      onPageChanged: (value) {
        setState(() {
          currentPage = value;
        });
      },
      children: [
        onboardPageView(
            const AssetImage('assets/images/onboarding1.png'),
            'Tìm kiếm vị trí đậu xe?',
            'Tìm kiếm nơi đậu xe không còn là vấn đề?'),
        onboardPageView(
            const AssetImage('assets/images/onboarding2.png'),
            'Hiển thị các vị trị đậu xe xung quay bạn',
            'Dễ hình dung, dễ dàng, tiết kiệm thời gian'),
        onboardPageView(
            const AssetImage('assets/images/onboarding3.png'),
            'Dẫn đường và hướng dẫn bạn đậu xe đúng vị trí',
            'Tối ưu, nhanh chóng'),
      ],
    );
  }

  Widget onboardPageView(
      ImageProvider imageProvider, String text, String text2) {
    return Padding(
      padding: EdgeInsets.all(40.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            image: imageProvider,
          ),
          SizedBox(height: 20.sp),
          Text(
            text,
            style:  TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: ColorsConstants.kTextMainColor,
            ),
            textAlign: TextAlign.start,
          ),
         SizedBox(height: 16.sp),
          Text(
            text2,
            style: TextStyle(fontSize: 18.sp),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget buildIndicator() {
    return SmoothPageIndicator(
      controller: controller,
      count: numberOfPages,
      effect: const WormEffect(
        activeDotColor: ColorsConstants.kActiveColor,
      ),
    );
  }
}
