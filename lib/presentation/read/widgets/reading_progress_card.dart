import 'package:deeds/core/constants/colors.dart';
import 'package:deeds/core/constants/text.dart';
import 'package:deeds/presentation/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../read_controller.dart';

class ReadingProgressCard extends StatelessWidget {
  final ReadController controller;

  const ReadingProgressCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.isReadOnly.value,
        child: Column(
          children: [
            SizedBox(height: 10.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: CardWidget(
                width: MediaQuery.of(context).size.width,
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 6),
                content: Container(
                  alignment: Alignment.center,
                  height: 60.h,
                  child: Obx(
                    () => Text(
                      "${controller.surahName.value}   •   ${controller.verseNumber.value} / ${controller.surahLength.value}   •   ${controller.surahNumber.value} / 114",
                      style: AppTextStyles.smallMidText,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
