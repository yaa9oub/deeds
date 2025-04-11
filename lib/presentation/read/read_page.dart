// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:blur/blur.dart';
import 'package:deeds/app/routes/app_urls.dart';
import 'package:deeds/core/constants/colors.dart';
import 'package:deeds/core/constants/text.dart';
import 'package:deeds/core/utils/shared_prefs.dart';
import 'package:deeds/domain/entities/surah_entity.dart';
import 'package:deeds/presentation/read/widgets/current_overview.dart';
import 'package:deeds/presentation/read/widgets/read_app_bar.dart';
import 'package:deeds/presentation/read/widgets/reading_progress_card.dart';
import 'package:deeds/presentation/read/widgets/tafssir_bottomsheet.dart';
import 'package:deeds/presentation/read/widgets/verse_content.dart';
import 'package:deeds/presentation/widgets/background.dart';
import 'package:deeds/presentation/widgets/bottom_sheet.dart';
import 'package:deeds/presentation/widgets/card_widget.dart';
import 'package:deeds/presentation/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constants/assets.dart';
import '../widgets/icon_btn_widget.dart';
import './read_controller.dart';

class ReadPage extends GetView<ReadController> {
  const ReadPage({super.key});
  @override
  Widget build(BuildContext context) {
    final ReadController controller = Get.find<ReadController>();

    return WillPopScope(
      onWillPop: () {
        Get.offNamedUntil(AppRoutes.home, (route) => false);
        controller.saveProgress();
        return Future.value(true);
      },
      child: Scaffold(
        body: Stack(
          children: [
            Background(),
            Column(
              children: [
                //app bar
                ReadAppBar(controller: controller),
                //reading progress card
                ReadingProgressCard(controller: controller),
                //current overview
                CurrentOverview(controller: controller),
                SizedBox(
                  height: 10.h,
                ),
                Obx(
                  () => Expanded(
                    child: controller.surah.value == null
                        ? Center(
                            child: SizedBox(
                              width: 25.w,
                              height: 25.w,
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2.w,
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              PageView.builder(
                                itemCount:
                                    controller.surah.value!.ayahs.length + 1,
                                scrollDirection: Axis.vertical,
                                physics: PageScrollPhysics(),
                                onPageChanged: (value) {
                                  controller.isSurahCompleted.value = value ==
                                      controller.surah.value!.ayahs.length;
                                  controller.readVerse(value);
                                  controller.verseIndex = value;
                                  if (value == 0) {
                                    controller.isFavorite.value =
                                        SharedPrefService.isFavorite(
                                      controller.surah.value!.ayahs[0].number,
                                      controller.surah.value!.name,
                                    );
                                  } else {
                                    controller.isFavorite.value =
                                        SharedPrefService.isFavorite(
                                      controller
                                          .surah.value!.ayahs[value].number,
                                      controller.surah.value!.name,
                                    );
                                  }
                                },
                                controller: controller.pageController,
                                itemBuilder: (context, index) {
                                  final ScrollController scrollController =
                                      ScrollController();
                                  if (index ==
                                      controller.surah.value!.ayahs.length) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 200.w,
                                          child: Text(
                                            "Great work! You've read all the verses of the surah. Keep reading to earn deeds!",
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.smallBoldText,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        PrimaryButton(
                                          width: 210.w,
                                          label: "Next Surah",
                                          onPressed: () {
                                            controller.nextSurah();
                                          },
                                        ),
                                      ],
                                    );
                                  } else if (index <
                                      controller.surah.value!.ayahs.length) {
                                    final verse =
                                        controller.surah.value?.ayahs[index];
                                    return VerseContent(
                                      scrollController: scrollController,
                                      verse: verse,
                                    );
                                  }
                                  return null;
                                },
                              ),
                              //buttons
                              Obx(
                                () {
                                  return (!controller.isSurahCompleted.value)
                                      ? Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            width: double.infinity,
                                            height: 50.h,
                                            margin: EdgeInsets.only(
                                              bottom: 15.h,
                                              right: 22.w,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButtonWidget(
                                                  size: 45,
                                                  gradient: LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      AppColors.primary
                                                          .withOpacity(0.63),
                                                      AppColors.primary,
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    controller.fetchTafsir(
                                                      controller
                                                          .surah
                                                          .value!
                                                          .ayahs[controller
                                                                  .verseNumber
                                                                  .value -
                                                              1]
                                                          .translation,
                                                    );
                                                    Get.bottomSheet(
                                                      GlassBottomSheet(
                                                        content:
                                                            TafssirBottomSheet(
                                                          verse: controller
                                                              .surah
                                                              .value!
                                                              .ayahs[controller
                                                                  .verseNumber
                                                                  .value -
                                                              1],
                                                          controller:
                                                              controller,
                                                        ),
                                                      ),
                                                      isScrollControlled: true,
                                                      barrierColor: Colors.white
                                                          .withAlpha(50),
                                                    );
                                                  },
                                                  icon: Icon(
                                                    CupertinoIcons.question,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Obx(
                                                  () => IconButtonWidget(
                                                    size: 45,
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                      colors: [
                                                        AppColors.primary
                                                            .withOpacity(0.63),
                                                        AppColors.primary,
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      toggleFavoriteVerse(
                                                          controller);
                                                    },
                                                    icon: Icon(
                                                      controller
                                                              .isFavorite.value
                                                          ? CupertinoIcons
                                                              .heart_fill
                                                          : CupertinoIcons
                                                              .heart,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                PrimaryButton(
                                                    width: 70.w,
                                                    onPressed: () {
                                                      controller.pageController
                                                          .animateToPage(
                                                        controller.verseIndex +
                                                            1,
                                                        duration: Duration(
                                                            milliseconds: 400),
                                                        curve: Curves.ease,
                                                      );
                                                    },
                                                    label: "Next 👇🏻")
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox();
                                },
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void toggleFavoriteVerse(ReadController controller) {
    var verse = controller.surah.value!.ayahs[controller.verseNumber.value - 1];
    verse.surahName = controller.surah.value!.name;
    verse.surahNumber = controller.surah.value!.number;
    if (!controller.isFavorite.value) {
      SharedPrefService.addFavoriteVerse(verse);
      controller.isFavorite.value = SharedPrefService.isFavorite(
        verse.number,
        verse.surahName!,
      );
    } else {
      SharedPrefService.removeFavoriteVerse(
        verse.number,
      );
      controller.isFavorite.value = SharedPrefService.isFavorite(
        verse.number,
        verse.surahName!,
      );
    }
  }

  void favoriteVerses() {
    controller.favoriteVerses = SharedPrefService.getFavoriteVerses();

    Get.bottomSheet(
      GlassBottomSheet(
        content: Expanded(
          child: controller.favoriteVerses.isEmpty
              ? Center(
                  child: Text(
                    "Add some favorite \nverses to earn deeds!",
                    style: AppTextStyles.smallBoldText,
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.favoriteVerses.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 30.h,
                      child: Center(
                        child: Divider(
                          color: AppColors.secondary.withAlpha(100),
                          thickness: 2.h,
                        ),
                      ),
                    );
                  },
                  itemBuilder: (context, index) {
                    var verse = controller.favoriteVerses[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                verse.text,
                                style: AppTextStyles.smallBoldText,
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              verse.number.toString(),
                              style: AppTextStyles.smallBoldText,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      isScrollControlled: true,
      barrierColor: Colors.white.withAlpha(50),
    );
  }
}
