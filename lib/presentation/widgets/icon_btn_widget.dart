import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/colors.dart';

class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget({
    super.key,
    this.size = 40,
    required this.icon,
    this.onTap,
    this.backgroundColor,
    this.gradient,
    this.border,
  });
  final double size;
  final Widget icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: size.w,
          height: size.w,
          decoration: BoxDecoration(
            color: backgroundColor,
            gradient: gradient,
            border: border,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: icon,
          ),
        ),
      ),
    );
  }
}
