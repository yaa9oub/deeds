// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/text.dart';

// class PrimaryButton extends StatelessWidget {
//   const PrimaryButton({
//     super.key,
//     required this.onPressed,
//     this.width,
//     this.height,
//     this.color,
//     required this.label,
//     this.textStyle,
//   });
//   final VoidCallback onPressed;
//   final double? width, height;
//   final Color? color;
//   final String label;
//   final TextStyle? textStyle;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       borderRadius: BorderRadius.circular(25.r),
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(25.r),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(25.r),
//           child: Container(
//             width: width?.w ?? 85.w,
//             height: height ?? 55.h,
//             constraints: BoxConstraints(
//               minWidth: 100.w,
//             ),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(25.r),
//             ),
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(25.r),
//                     child: RepaintBoundary(
//                       child: Blur(
//                         blur: 2,
//                         blurColor: AppColors.bgColor,
//                         colorOpacity: 0.2,
//                         child: Container(),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: Text(
//                     label,
//                     style: textStyle ??
//                         AppTextStyles.smallBoldText.copyWith(
//                           color: Colors.white,
//                         ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    this.width,
    this.height,
    this.color,
    required this.label,
    this.textStyle,
  });
  final VoidCallback onPressed;
  final double? width, height;
  final Color? color;
  final String label;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16.r),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            width: width?.w ?? 85.w,
            height: height ?? 55.h,
            constraints: BoxConstraints(
              minWidth: 100.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.primary.withOpacity(0.63),
                  AppColors.primary,
                ],
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: textStyle ??
                    AppTextStyles.smallBoldText.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
