import 'package:deeds/core/constants/text.dart';
import 'package:deeds/presentation/read/read_controller.dart';
import 'package:deeds/presentation/widgets/card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CurrentOverview extends StatelessWidget {
  const CurrentOverview({
    super.key,
    required this.controller,
  });

  final ReadController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Obx(
            () => Visibility(
              visible: controller.isReadOnly.value,
              child: Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.w,
                    ),
                    CardWidget(
                      width: MediaQuery.of(context).size.width,
                      height: 60.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 6,
                      ),
                      content: SizedBox(
                        height: 60.h,
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "💕 ${controller.currentDeeds.value}",
                                  style: AppTextStyles.mediumBoldText,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "📖 ${controller.currentSurah.value}",
                                  style: AppTextStyles.mediumBoldText,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "📄 ${controller.currentPage.value}",
                                  style: AppTextStyles.mediumBoldText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
