import 'package:deeds/app/routes/app_urls.dart';
import 'package:deeds/core/constants/text.dart';
import 'package:deeds/domain/entities/surah_entity.dart';
import 'package:deeds/presentation/currentPrayerWidget/current_prayer_controller.dart';
import 'package:deeds/presentation/currentPrayerWidget/current_prayer_ui.dart';
import 'package:deeds/presentation/widgets/bottom_nav_bar.dart';
import 'package:deeds/presentation/widgets/card_widget.dart';
import 'package:deeds/presentation/widgets/icon_btn_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constants/all_surahs.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/shared_prefs.dart';
import '../widgets/background.dart';
import '../widgets/bottom_sheet.dart';
import '../widgets/primary_button.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
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
                      Text(
                        "Deeds",
                        style: AppTextStyles.mediumBoldText.copyWith(),
                      ),
                      IconButtonWidget(
                        icon: Icon(
                          CupertinoIcons.bell,
                        ),
                      ),
                    ],
                  ),
                ),
                //body
                Obx(
                  () {
                    return Expanded(
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            CurrentPrayer(),
                            SizedBox(
                              height: 15.h,
                            ),
                            //daily verse
                            CardWidget(
                              width: MediaQuery.of(context).size.width,
                              height: 130.h,
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 15.h,
                                children: [
                                  Text(
                                    "Your daily verse",
                                    style: AppTextStyles.midBoldText.copyWith(),
                                  ),
                                  Text(
                                    '"And He is with you wherever you are."\n~Quran 53:32',
                                    style: AppTextStyles.smallMidText,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            //goal
                            CardWidget(
                              width: MediaQuery.of(context).size.width,
                              height: 220.h,
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 15.h,
                                children: [
                                  Text(
                                    "Goal",
                                    style: AppTextStyles.midBoldText.copyWith(),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // "${controller.surah.value?.englishName ?? "Surah name"}   •   ${controller.verseNumber.value} / ${controller.surah.value?.ayahs.length ?? 0}   •   ${controller.surah.value?.number ?? 0} / 114",
                                      Text(
                                        "${controller.surah.value?.englishName ?? "Al-Fatihah"}   •    ${controller.verseNumber.value} / ${controller.surah.value?.ayahs.length ?? 7}   •   ${controller.surah.value?.number ?? 1} / 114",
                                        style: AppTextStyles.smallMidText,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Get.bottomSheet(
                                              GlassBottomSheet(
                                                content: Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Spacer(),
                                                      Text(
                                                        "Pick your surah",
                                                        style: AppTextStyles
                                                            .midBoldText,
                                                      ),
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                      CupertinoPicker(
                                                        itemExtent:
                                                            60, // Height of each item
                                                        onSelectedItemChanged:
                                                            (int index) {
                                                          controller
                                                              .updateSelectedValue(
                                                            index + 1,
                                                          );
                                                        },
                                                        children: List<
                                                            Widget>.generate(
                                                          surahs
                                                              .length, // Use the length of the surahs list
                                                          (int index) {
                                                            var surah =
                                                                surahs[index];
                                                            return Center(
                                                              child: Text(
                                                                '${surah['id']} - ${surah['name']} (${surah['verses']} Verses)',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16), // Adjust font size if needed
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      PrimaryButton(
                                                        onPressed: () {
                                                          SharedPrefService.saveInt(
                                                              "surahNumber",
                                                              controller
                                                                  .selectedValue
                                                                  .value);
                                                          SharedPrefService
                                                              .saveInt(
                                                                  "verseNumber",
                                                                  1);
                                                          Get.back();
                                                        },
                                                        label: "Bissmillah",
                                                      ),
                                                      SizedBox(
                                                        height: 30.h,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              isScrollControlled: true,
                                              barrierColor:
                                                  Colors.white.withAlpha(50),
                                            );
                                          },
                                          borderRadius:
                                              BorderRadius.circular(99),
                                          child: Icon(
                                            Icons.edit,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "0 / 20 • pages per day",
                                        style: AppTextStyles.smallMidText,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Get.toNamed(AppRoutes.home);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(99),
                                          child: Icon(
                                            Icons.edit,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  PrimaryButton(
                                    width: double.infinity,
                                    onPressed: () {
                                      Get.toNamed(AppRoutes.read);
                                    },
                                    label: "Read Quran",
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            //overview
                            Row(
                              spacing: 15.w,
                              children: [
                                CardWidget(
                                  height: 130.h,
                                  width:
                                      MediaQuery.of(context).size.width * 0.29,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 20.h,
                                  ),
                                  content: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.29,
                                    child: Column(
                                      spacing: 8.h,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "💕",
                                          style: AppTextStyles.mediumBoldText,
                                        ),
                                        Text(
                                          "Deeds",
                                          style: AppTextStyles.smallMidText,
                                        ),
                                        Text(
                                          controller.deeds.value.toString(),
                                          style: AppTextStyles.mediumBoldText,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CardWidget(
                                    height: 130.h,
                                    width: MediaQuery.of(context).size.width *
                                        0.29,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 20.h,
                                    ),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.29,
                                      child: Column(
                                        spacing: 8.h,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "📖",
                                            style: AppTextStyles.mediumBoldText,
                                          ),
                                          Text(
                                            "Surahs",
                                            style: AppTextStyles.smallMidText,
                                          ),
                                          Text(
                                            controller.surahs.value.toString(),
                                            style: AppTextStyles.mediumBoldText,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CardWidget(
                                    height: 130.h,
                                    width: MediaQuery.of(context).size.width *
                                        0.29,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 20.h,
                                    ),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.29,
                                      child: Column(
                                        spacing: 8.h,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "📄",
                                            style: AppTextStyles.mediumBoldText,
                                          ),
                                          Text(
                                            "Pages",
                                            style: AppTextStyles.smallMidText,
                                          ),
                                          Text(
                                            controller.pages.value.toString(),
                                            style: AppTextStyles.mediumBoldText,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            //prayers
                            CardWidget(
                              width: double.infinity,
                              height: 380.h,
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 15.h,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Prayers",
                                        style: AppTextStyles.midBoldText,
                                      ),
                                      Obx(
                                        () => InkWell(
                                          onTap: () {
                                            Get.bottomSheet(
                                              GlassBottomSheet(
                                                content:
                                                    CitiesBottomSheetContent(
                                                  controller: controller,
                                                ),
                                              ),
                                              isScrollControlled: true,
                                              barrierColor:
                                                  Colors.white.withAlpha(50),
                                            );
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                controller.city.value,
                                                style:
                                                    AppTextStyles.smallMidText,
                                              ),
                                              SizedBox(
                                                width: 4.w,
                                              ),
                                              Icon(
                                                Icons.edit,
                                                size: 16.w,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 17.h),
                                      itemCount: controller.prayers.length,
                                      itemBuilder: (context, index) {
                                        final prayer =
                                            controller.prayers[index];

                                        return SizedBox(
                                          width: double.infinity,
                                          height: 50.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 45.h,
                                                    height: 45.h,
                                                    child: Center(
                                                      child: Image.asset(
                                                          prayer.icon,
                                                          fit: BoxFit.fitWidth,
                                                          width: 30.h,
                                                          height: 30.h),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(prayer.time,
                                                          style: AppTextStyles
                                                              .smallMidText),
                                                      Text(prayer.label,
                                                          style: AppTextStyles
                                                              .smallBoldText),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    height: 45.h,
                                                    width: 40.h,
                                                    child: Center(
                                                      child: InkWell(
                                                        onTap: () => controller
                                                            .toggleAlarm(index),
                                                        child: Icon(
                                                          prayer.isAlarm
                                                              ? Icons.alarm_on
                                                              : Icons.alarm_off,
                                                          color: prayer.isAlarm
                                                              ? Colors.green
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 45.h,
                                                    width: 40.h,
                                                    child: Center(
                                                      child: InkWell(
                                                        onTap: () => controller
                                                            .toggleReminder(
                                                                index),
                                                        child: Icon(
                                                          prayer.isReminder
                                                              ? Icons
                                                                  .timer_outlined
                                                              : Icons
                                                                  .timer_off_outlined,
                                                          color:
                                                              prayer.isReminder
                                                                  ? Colors.blue
                                                                  : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50.h,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.alarm,
                                            ),
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Text(
                                              "Prayer alarm",
                                              style: AppTextStyles.smallMidText,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.timer_outlined,
                                            ),
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Text(
                                              "Prayer reminder (15 minutes)",
                                              style: AppTextStyles.smallMidText,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100.h,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          BottomNavBar(
            isHome: true,
          ),
        ],
      ),
    );
  }
}

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
        itemCount: controller.tunisianGovernorates.length,
        itemBuilder: (context, index) {
          bool isSelected = controller.city.value.toLowerCase() ==
              controller.tunisianGovernorates[index].toLowerCase();

          return ListTile(
            onTap: () {
              controller.city.value = controller.tunisianGovernorates[index];
              controller.searchForLocation(
                controller.city.value,
              );
              Get.back();
            },
            title: Text(
              controller.tunisianGovernorates[index],
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
