import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';

class GlassBottomSheet extends StatelessWidget {
  const GlassBottomSheet({
    super.key,
    required this.content,
  });

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white,
            width: 0.5,
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: Blur(
                blur: 5,
                blurColor: AppColors.cardBgColor,
                colorOpacity: 0.2,
                child: Container(),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 30.w,
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Divider(
                        height: 8.h,
                        thickness: 4.h,
                        color: AppColors.secondary,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SizedBox(
                        width: 30.w,
                        child: Icon(
                          Icons.close,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              content,
            ],
          ),
        ],
      ),
    );
  }
}
