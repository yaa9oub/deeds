import 'package:deeds/core/constants/cities.dart';
import 'package:deeds/core/constants/consts.dart';
import 'package:deeds/core/constants/text.dart';
import 'package:deeds/core/services/location_service.dart';
import 'package:deeds/core/utils/shared_prefs.dart';
import 'package:deeds/presentation/widgets/primary_button.dart';
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
    final locationService = Get.find<LocationService>();

    return Expanded(
      child: Column(
        children: [
          // Current Location Button
          PrimaryButton(
            width: 300,
            onPressed: () async {
              await locationService.getCurrentLocation();
              final currentCity = locationService.currentCity;
              if (currentCity.isNotEmpty && currentCity != 'Unknown City') {
                controller.city.value = currentCity;
                await SharedPrefService.saveString(
                  LocalVariables.city.name,
                  currentCity,
                );
                await controller.searchForLocation(currentCity);
                Get.back();
              } else {
                Get.snackbar(
                  'Error',
                  'Could not get current location. Please select a city manually.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            label: 'Use Current Location',
          ),
          const Divider(),
          Expanded(
            // height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tunisianGovernorates.length,
              itemBuilder: (context, index) {
                bool isSelected = controller.city.value.toLowerCase() ==
                    tunisianGovernorates[index].toLowerCase();
                return ListTile(
                  onTap: () {
                    controller.city.value = tunisianGovernorates[index];
                    SharedPrefService.saveString(
                      LocalVariables.city.name,
                      tunisianGovernorates[index],
                    );
                    controller.searchForLocation(controller.city.value);
                    Get.back();
                  },
                  title: Text(
                    tunisianGovernorates[index],
                    style: AppTextStyles.smallMidText.copyWith(
                      color: isSelected ? AppColors.secondary : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
