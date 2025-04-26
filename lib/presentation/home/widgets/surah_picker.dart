import 'package:deeds/core/constants/consts.dart';
import 'package:deeds/core/constants/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/all_surahs.dart';
import '../../../core/utils/shared_prefs.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/primary_button.dart';
import '../home_controller.dart';

void showSurahPicker(HomeController controller) {
  // Initialize with valid defaults
  controller.selectedSurah.value = controller.surahNumber.value;
  controller.selectedVerse.value = controller.verseNumber.value;

  Get.bottomSheet(
    GlassBottomSheet(
      content: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SizedBox(
              height: 250,
              child: CupertinoPicker(
                itemExtent: 60,
                scrollController: FixedExtentScrollController(
                  initialItem: controller.selectedSurah.value - 1,
                ),
                onSelectedItemChanged: (value) {
                  controller.selectedSurah.value = surahs[value]["id"];
                  controller.surahNumber.value = surahs[value]["id"];
                  controller.surahLength.value = surahs[value]["verses"];
                  controller.surahName.value = surahs[value]["name"];
                },
                children: List.generate(
                  surahs.length,
                  (index) {
                    var surah = surahs[index];
                    return Center(
                      child: Text(
                        '${surah['id']} - ${surah['name']} (${surah['verses']} Verses)',
                        style: AppTextStyles.smallMidText,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Obx(() {
              // Safely get number of verses for selected surah
              final selectedSurahIndex = controller.selectedSurah.value;
              final verseCount =
                  selectedSurahIndex >= 0 && selectedSurahIndex <= surahs.length
                      ? surahs[selectedSurahIndex - 1]['verses']
                      : 0;

              return SizedBox(
                height: 250,
                child: CupertinoPicker(
                  itemExtent: 60,
                  scrollController: FixedExtentScrollController(
                    initialItem: controller.selectedVerse.value - 1,
                  ),
                  onSelectedItemChanged: (value) {
                    if (value > 0 && value < verseCount) {
                      controller.selectedVerse.value = value + 1;
                    } else {
                      controller.selectedVerse.value = 1;
                    }
                    controller.verseNumber.value =
                        controller.selectedVerse.value;
                  },
                  children: List.generate(
                    verseCount,
                    (index) => Center(
                      child: Text(
                        '${index + 1}',
                        style: AppTextStyles.smallMidText,
                      ),
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            PrimaryButton(
              width: 300.w,
              onPressed: () {
                SharedPrefService.saveInt(
                  LocalVariables.surahNumber.name,
                  controller.selectedSurah.value,
                );
                SharedPrefService.saveInt(
                  LocalVariables.verseNumber.name,
                  controller.selectedVerse.value,
                );
                SharedPrefService.saveString(
                  LocalVariables.surahName.name,
                  controller.surahName.value,
                );
                SharedPrefService.saveInt(
                  LocalVariables.surahLength.name,
                  controller.surahLength.value,
                );
                Get.back();
              },
              label: "Select Surah",
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
    barrierColor: Colors.white.withAlpha(50),
  );
}
