import 'package:deeds/core/constants/text.dart';
import 'package:deeds/domain/entities/prayer_timing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../home_controller.dart';

Widget buildPrayerItem(
    PrayerTiming prayer, int index, HomeController controller) {
  return SizedBox(
    width: double.infinity,
    height: 50.h,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 45.h,
              height: 45.h,
              child: Center(
                child: Image.asset(
                  prayer.icon,
                  fit: BoxFit.fitWidth,
                  width: 30.h,
                  height: 30.h,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(prayer.time, style: AppTextStyles.smallMidText),
                Text(prayer.label, style: AppTextStyles.smallBoldText),
              ],
            ),
          ],
        ),
        Row(
          children: [
            _buildPrayerToggleButton(
              icon: prayer.isAlarm ? Icons.alarm_on : Icons.alarm_off,
              color: prayer.isAlarm ? Colors.green : Colors.grey,
              onTap: () => controller.toggleAlarm(index),
            ),
            SizedBox(width: 8.w),
            _buildPrayerToggleButton(
              icon: prayer.isReminder
                  ? Icons.timer_outlined
                  : Icons.timer_outlined,
              color: prayer.isReminder ? Colors.blueAccent : Colors.grey,
              onTap: () => controller.toggleReminder(index),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildPrayerToggleButton({
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return SizedBox(
    height: 45.h,
    width: 40.h,
    child: Center(
      child: InkWell(
        onTap: onTap,
        child: Icon(icon, color: color),
      ),
    ),
  );
}
