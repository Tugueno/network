import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaceIDView extends GetView {
  const FaceIDView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFaceIDIcon(),
                SizedBox(height: 40),
                _buildWelcomeMessage(),
                SizedBox(height: 10),
                _buildDescriptionText(),
              ],
            ),
          ),
          _buildButtons(context),
          _buildHomeIndicator(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: Get.width,
      height: 100,
      padding: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          _buildStatusBar(),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      width: 375,
      height: 44,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 292,
            child: Container(
              width: 77,
              height: 13,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                      'assets/icons/battery.svg', width: 24, height: 24),
                  Image.asset(
                      'assets/icons/wifi.svg', width: 24, height: 24),
                  Image.asset(
                      'assets/icons/mobile_signal.svg', width: 24, height: 24),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 17,
            child: Container(
              width: 54,
              height: 21,
              child: Text(
                '9:41',
                style: const TextStyle(
                  color: Color(0xFF3D5AFE),
                  fontSize: 15,
                  fontFamily: 'SF Pro Text',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaceIDIcon() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Image.asset('assets/icons/face_id_large.svg', width: 80, height: 80), // Placeholder for Face ID icon
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Text(
      'Та цаашид нэвтрэхдээ \nFace ID ашиглах уу?',
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color(0xFF3D5AFE),
        fontSize: 24,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildDescriptionText() {
    return Text(
      'Тохиргоог идэвхжүүлснээр илүү хурдан нэвтрэх боломжтой.',
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color(0xFF6A6A6F),
        fontSize: 13,
        fontFamily: 'SF Pro Text',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF3D5AFE),
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Center(
              child: Text(
                'Зөвшөөрөх',
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontFamily: 'SF Pro Text',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0xFFE5E5EA), width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Center(
              child: Text(
                'Алгасах',
                style: const TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 16,
                  fontFamily: 'SF Pro Text',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeIndicator() {
    return Container(
      width: Get.width,
      height: 34,
      alignment: Alignment.center,
      child: Container(
        width: 134,
        height: 5,
        decoration: BoxDecoration(
          color: Color(0xFF000000),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
