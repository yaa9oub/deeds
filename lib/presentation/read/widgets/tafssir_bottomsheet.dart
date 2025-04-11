import 'package:deeds/core/constants/colors.dart';
import 'package:deeds/core/constants/text.dart';
import 'package:deeds/domain/entities/surah_entity.dart';
import 'package:deeds/presentation/read/read_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TafssirBottomSheet extends StatelessWidget {
  const TafssirBottomSheet({
    super.key,
    required this.verse,
    required this.controller,
  });

  final VerseEntity? verse;
  final ReadController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  verse!.text,
                  style: AppTextStyles.mediumBoldText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.h,
                ),
                controller.isLoading.value
                    ? Expanded(
                        child: Center(
                          child: SizedBox(
                            width: 25.w,
                            height: 25.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 4.w,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      )
                    : Text(
                        controller.tafsirText.value,
                        style: AppTextStyles.smallBoldText,
                        textAlign: TextAlign.justify,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
