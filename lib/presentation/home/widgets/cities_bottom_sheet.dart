import 'package:deeds/core/constants/cities.dart';
import 'package:deeds/core/constants/consts.dart';
import 'package:deeds/core/constants/text.dart';
import 'package:deeds/core/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../home_controller.dart';

class CitiesBottomSheetContent extends StatelessWidget {
  const CitiesBottomSheetContent({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: tunisianGovernorates.length,
        itemBuilder: (context, index) {
          bool isSelected = controller.city.value.toLowerCase() ==
              tunisianGovernorates[index].toLowerCase();

          return ListTile(
            onTap: () {
              controller.city.value = tunisianGovernorates[index];
              print(tunisianGovernorates[index]);
              SharedPrefService.saveString(
                  LocalVariables.city.name, tunisianGovernorates[index]);
              controller.searchForLocation(controller.city.value);
              Get.back();
            },
            title: Text(
              tunisianGovernorates[index],
              style: AppTextStyles.smallMidText.copyWith(
                color: isSelected ? AppColors.secondary : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
