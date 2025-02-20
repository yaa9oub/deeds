// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:blur/blur.dart';
import 'package:deeds/app/routes/app_urls.dart';
import 'package:deeds/core/constants/colors.dart';
import 'package:deeds/core/constants/text.dart';
import 'package:deeds/core/utils/shared_prefs.dart';
import 'package:deeds/domain/entities/surah_entity.dart';
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
        return Future.value(true);
      },
      child: Scaffold(
        body: Stack(
          children: [
            Background(),
            Column(
              children: [
                //app bar
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60.h,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  margin: EdgeInsets.only(top: 30.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButtonWidget(
                            onTap: () {
                              Get.offNamedUntil(
                                  AppRoutes.home, (route) => false);
                            },
                            icon: Icon(
                              CupertinoIcons.back,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "Reading",
                            style: AppTextStyles.mediumBoldText,
                          ),
                        ],
                      ),
                      IconButtonWidget(
                        onTap: () {
                          controller.favoriteVerses =
                              SharedPrefService.getFavoriteVerses();

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
                                        itemCount:
                                            controller.favoriteVerses.length,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 30.h,
                                            child: Center(
                                              child: Divider(
                                                color: AppColors.secondary
                                                    .withAlpha(100),
                                                thickness: 2.h,
                                              ),
                                            ),
                                          );
                                        },
                                        itemBuilder: (context, index) {
                                          var verse =
                                              controller.favoriteVerses[index];
                                          return SizedBox(
                                            width: double.infinity,
                                            height: 60.h,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    verse.text,
                                                    style: AppTextStyles
                                                        .mediumBoldText,
                                                    textAlign: TextAlign.start,
                                                    textDirection:
                                                        TextDirection.rtl,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Text(
                                                  verse.number.toString(),
                                                  style: AppTextStyles
                                                      .mediumBoldText,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                            isScrollControlled: true,
                            barrierColor: Colors.white.withAlpha(50),
                          );
                        },
                        icon: Icon(
                          CupertinoIcons.heart,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.w,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: CardWidget(
                    width: MediaQuery.of(context).size.width,
                    height: 60.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    content: Container(
                      alignment: Alignment.center,
                      height: 60.h,
                      child: Obx(
                        () => Text(
                          "${controller.surah.value?.englishName ?? "Surah name"}   •   ${controller.verseNumber.value} / ${controller.surah.value?.ayahs.length ?? 0}   •   ${controller.surah.value?.number ?? 0} / 114",
                          style: AppTextStyles.smallMidText,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.w,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Row(
                    children: [
                      Obx(
                        () => Expanded(
                          child: CardWidget(
                            width: MediaQuery.of(context).size.width,
                            height: 60.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                            ),
                            content: SizedBox(
                              height: 60.h,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "💕 ${controller.deeds.value}",
                                        style: AppTextStyles.mediumBoldText,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "📖 ${controller.surahs.value}",
                                        style: AppTextStyles.mediumBoldText,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "📄 ${controller.page.value}",
                                        style: AppTextStyles.mediumBoldText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                                  controller.readVerse(value);
                                  // controller.isFavorite.value =
                                  //     SharedPrefService.isFavorite(controller
                                  //         .surah.value!.ayahs[value - 1].number);
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
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14.w,
                                        vertical: 5.h,
                                      ),
                                      child: CardWidget(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 20.h,
                                        ),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 14.w,
                                          vertical: 5.h,
                                        ),
                                        content: SizedBox(
                                          width: double.infinity,
                                          child: Scrollbar(
                                            thumbVisibility: true,
                                            radius: Radius.circular(999),
                                            thickness: 2.w,
                                            controller: scrollController,
                                            child: SingleChildScrollView(
                                              controller: scrollController,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      verse!.text.replaceFirst(
                                                          "\n", ""),
                                                      style: AppTextStyles
                                                          .mediumBoldText,
                                                      textAlign:
                                                          TextAlign.center,
                                                      textDirection:
                                                          TextDirection.rtl,
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Text(
                                                      verse.translation,
                                                      style: AppTextStyles
                                                          .midBoldText,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return null;
                                },
                              ),
                              //buttons
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  height: 50.h,
                                  margin: EdgeInsets.only(
                                    bottom: 15.h,
                                    right: 22.w,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButtonWidget(
                                        onTap: () {
                                          controller.fetchTafsir(
                                            controller
                                                .surah
                                                .value!
                                                .ayahs[controller
                                                        .verseNumber.value -
                                                    1]
                                                .translation,
                                          );
                                          Get.bottomSheet(
                                            TafssirBottomSheet(
                                              verse: controller
                                                      .surah.value!.ayahs[
                                                  controller.verseNumber.value -
                                                      1],
                                              controller: controller,
                                            ),
                                            isScrollControlled: true,
                                          );
                                        },
                                        icon: Icon(
                                          CupertinoIcons.exclamationmark,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      IconButtonWidget(
                                        onTap: () {
                                          var verse = controller
                                                  .surah.value!.ayahs[
                                              controller.verseNumber.value - 1];
                                          if (!controller.isFavorite.value) {
                                            SharedPrefService.addFavoriteVerse(
                                              verse,
                                            );
                                            controller.isFavorite.value =
                                                SharedPrefService.isFavorite(
                                              verse.number,
                                            );
                                          } else {
                                            SharedPrefService
                                                .removeFavoriteVerse(
                                              verse.number,
                                            );
                                            controller.isFavorite.value =
                                                SharedPrefService.isFavorite(
                                              verse.number,
                                            );
                                          }
                                        },
                                        icon: Icon(
                                          controller.isFavorite.value
                                              ? CupertinoIcons.heart_fill
                                              : CupertinoIcons.heart,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      PrimaryButton(
                                          width: 70.w,
                                          onPressed: () {
                                            controller.readVerse(
                                                controller.currentVersePage +
                                                    1);
                                            controller.pageController
                                                .animateToPage(
                                              controller.currentVersePage,
                                              duration:
                                                  Duration(milliseconds: 400),
                                              curve: Curves.ease,
                                            );
                                          },
                                          label: "Next 👇🏻")
                                    ],
                                  ),
                                ),
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
}

class TafssirBottomSheet extends StatelessWidget {
  const TafssirBottomSheet({
    super.key,
    required this.verse,
    required this.controller,
  });

  final VerseEntity? verse;
  final ReadController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                width: 100.w,
                child: Divider(
                  height: 8.h,
                  thickness: 4.h,
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                verse!.text,
                style: AppTextStyles.mediumBoldText,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.h,
              ),
              controller.isLoading.value
                  ? Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 25.w,
                          height: 25.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 4.w,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    )
                  : Text(
                      controller.tafsirText.value,
                      style: AppTextStyles.smallBoldText,
                      textAlign: TextAlign.justify,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
