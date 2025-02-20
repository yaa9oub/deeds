import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constants/text.dart';
import '../../data/models/prayer.dart';
import '../widgets/card_widget.dart';
import 'current_prayer_controller.dart';

class CurrentPrayer extends StatelessWidget {
  const CurrentPrayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrentPrayerController>(
      init: CurrentPrayerController(),
      initState: (_) {},
      builder: (controller) {
        return CardWidget(
          content: Obx(
            () {
              double progress = controller.progressNotifier.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Prayer",
                    style: AppTextStyles.midBoldText,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPrayerColumn(
                          controller.currentPrayer.value, Alignment.centerLeft),
                      _buildPrayerColumn(
                          controller.nextPrayer.value, Alignment.centerRight),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 24.h,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 12.h,
                          width: 330.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [Colors.green, Colors.yellow, Colors.red],
                              stops: [0.1, 0.65, 1.0],
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: controller.progressNotifier,
                          builder: (context, child) {
                            return Positioned(
                              left: (progress * 315).w,
                              child: Container(
                                width: 1.w,
                                height: 24.h,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPrayerColumn(Prayer prayer, Alignment alignment) {
    return Column(
      crossAxisAlignment: alignment == Alignment.centerLeft
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Text(prayer.time, style: AppTextStyles.smallMidText),
        Row(
          children: [
            Image.asset(prayer.icon, width: 18, height: 18),
            SizedBox(width: 5),
            Text(prayer.label, style: AppTextStyles.smallBoldText),
          ],
        ),
      ],
    );
  }
}
