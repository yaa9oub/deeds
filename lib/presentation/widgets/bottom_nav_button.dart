import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/colors.dart';

class BottomNavButton extends StatelessWidget {
  const BottomNavButton({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
    this.isSelected = false,
  });
  final IconData icon;
  final String title;
  final bool isSelected;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed(route);
          },
          child: Center(
            child: Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.black54,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
