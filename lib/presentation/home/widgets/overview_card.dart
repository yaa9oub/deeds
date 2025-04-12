import 'package:deeds/core/constants/text.dart';
import 'package:deeds/presentation/widgets/card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildOverviewCard({
  required String emoji,
  required String label,
  required String value,
}) {
  return Expanded(
    child: CardWidget(
      height: 130.h,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      content: Center(
        child: Column(
          spacing: 8.h,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: AppTextStyles.mediumBoldText),
            Text(label, style: AppTextStyles.smallMidText),
            Text(
              value,
              style: AppTextStyles.mediumBoldText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
