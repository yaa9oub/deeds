import 'dart:ui';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/colors.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.content,
    this.height,
    this.width,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.isShare = false,
  });
  final Widget content;
  final double? height, width;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry? padding;
  final bool isShare;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35.r),
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        // height: height,
        constraints: BoxConstraints(
          minHeight: height ?? 50.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Stack(
          children: [
            if (!isShare)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.r),
                  child: RepaintBoundary(
                    child: Blur(
                      blur: 3,
                      blurColor: AppColors.cardBgColor,
                      colorOpacity: 0.2,
                      child: Container(),
                    ),
                  ),
                ),
              ),
            if (isShare)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.r),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.cardBgColor.withAlpha(50),
                          AppColors.cardBgColor,
                          AppColors.cardBgColor.withAlpha(50),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: padding ??
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
