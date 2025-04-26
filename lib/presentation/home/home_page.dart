import 'package:deeds/app/routes/app_urls.dart';
import 'package:deeds/core/constants/colors.dart';
import 'package:deeds/core/constants/text.dart';
import 'package:deeds/presentation/currentPrayerWidget/current_prayer_ui.dart';
import 'package:deeds/presentation/home/widgets/cities_bottom_sheet.dart';
import 'package:deeds/presentation/home/widgets/overview_card.dart';
import 'package:deeds/presentation/home/widgets/prayer_item.dart';
import 'package:deeds/presentation/home/widgets/surah_picker.dart';
import 'package:deeds/presentation/widgets/bottom_nav_bar.dart';
import 'package:deeds/presentation/widgets/card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widgets/background.dart';
import '../widgets/bottom_sheet.dart';
import '../widgets/primary_button.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          _buildMainContent(context),
          const BottomNavBar(isHome: true),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: Obx(() => _buildBody(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
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
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        children: [
          SizedBox(height: 15.h),
          const CurrentPrayer(),
          SizedBox(height: 15.h),
          _buildDailyVerse(),
          SizedBox(height: 15.h),
          _buildLastRead(context),
          SizedBox(height: 15.h),
          _buildOverview(),
          SizedBox(height: 15.h),
          _buildPrayers(context),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildDailyVerse() {
    return CardWidget(
      width: double.infinity,
      height: 130.h,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your daily verse",
                style: AppTextStyles.midBoldText,
              ),
              Obx(
                () => InkWell(
                  onTap: () {
                    controller.loadDailyVerse();
                  },
                  child: SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: controller.isLoadingVerse.value
                        ? CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.secondary,
                          )
                        : Icon(
                            Icons.refresh,
                            color: AppColors.secondary,
                          ),
                  ),
                ),
              ),
            ],
          ),
          Obx(() {
            final verse = controller.dailyVerse.value;
            if (verse == null) {
              return Text(
                'Loading verse...',
                style: AppTextStyles.smallMidText,
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    verse.arabicText,
                    style: AppTextStyles.midBoldText.copyWith(
                      height: 1.5,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '~ ${verse.surahNameEnglish} ${verse.numberInSurah}:${verse.surahNumber}',
                  style: AppTextStyles.smallMidText.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLastRead(BuildContext context) {
    return CardWidget(
      width: double.infinity,
      height: 180.h,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15.h,
        children: [
          Text(
            "Last read",
            style: AppTextStyles.midBoldText.copyWith(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${controller.surahName.value}   •    ${controller.verseNumber.value} / ${controller.surahLength.value}   •   ${controller.surahNumber.value} / 114",
                style: AppTextStyles.smallMidText,
              ),
              SizedBox(width: 10.w),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => showSurahPicker(controller),
                  borderRadius: BorderRadius.circular(99),
                  child: const Icon(Icons.edit),
                ),
              ),
            ],
          ),
          PrimaryButton(
            width: double.infinity,
            onPressed: () => Get.toNamed(AppRoutes.read),
            label: "Read Quran",
          ),
        ],
      ),
    );
  }

  Widget _buildOverview() {
    return Row(
      spacing: 15.w,
      children: [
        buildOverviewCard(
          emoji: "💕",
          label: "Deeds",
          value: controller.deeds.value.toString(),
        ),
        buildOverviewCard(
          emoji: "📖",
          label: "Surahs",
          value: controller.surahsNumber.value.toString(),
        ),
        buildOverviewCard(
          emoji: "📄",
          label: "Pages",
          value: controller.pages.value.toString(),
        ),
      ],
    );
  }

  Widget _buildPrayers(BuildContext context) {
    return CardWidget(
      width: double.infinity,
      height: 380.h,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15.h,
        children: [
          _buildPrayersHeader(),
          _buildPrayersList(),
          SizedBox(height: 10.h),
          _buildPrayerSettings(),
        ],
      ),
    );
  }

  Widget _buildPrayersHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Prayers",
          style: AppTextStyles.midBoldText,
        ),
        Obx(() => InkWell(
              onTap: _showCityPicker,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.city.value,
                    style: AppTextStyles.smallMidText,
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.edit, size: 16.w),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildPrayersList() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => SizedBox(height: 17.h),
          itemCount: controller.prayers.length,
          itemBuilder: (context, index) =>
              buildPrayerItem(controller.prayers[index], index, controller),
        ));
  }

  Widget _buildPrayerSettings() {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.alarm),
              SizedBox(width: 8.w),
              Text(
                "Prayer alarm",
                style: AppTextStyles.smallMidText,
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_outlined),
              SizedBox(width: 8.w),
              Text(
                "Prayer reminder (15 minutes)",
                style: AppTextStyles.smallMidText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCityPicker() {
    Get.bottomSheet(
      GlassBottomSheet(
        content: CitiesBottomSheetContent(controller: controller),
      ),
      isScrollControlled: true,
      barrierColor: Colors.white.withAlpha(50),
    );
  }
}
