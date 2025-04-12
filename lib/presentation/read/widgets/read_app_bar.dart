import 'package:deeds/app/routes/app_urls.dart';
import 'package:deeds/core/constants/colors.dart';
import 'package:deeds/core/constants/text.dart';
import 'package:deeds/core/utils/shared_prefs.dart';
import 'package:deeds/presentation/widgets/bottom_sheet.dart';
import 'package:deeds/presentation/widgets/icon_btn_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../read_controller.dart';

class ReadAppBar extends StatelessWidget {
  final ReadController controller;

  const ReadAppBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  controller.saveProgress();
                  Get.offNamedUntil(AppRoutes.home, (route) => false);
                },
                icon: const Icon(CupertinoIcons.back),
              ),
              SizedBox(width: 10.w),
              Text(
                "Reading",
                style: AppTextStyles.mediumBoldText,
              ),
            ],
          ),
          Row(
            children: [
              IconButtonWidget(
                onTap: () {
                  _showFavoriteVerses(controller);
                },
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.primary.withOpacity(0.63),
                    AppColors.primary,
                  ],
                ),
                icon: const Icon(
                  CupertinoIcons.heart,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 5.w),
              IconButtonWidget(
                onTap: () {
                  controller.isReadOnly.value = !controller.isReadOnly.value;
                },
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.primary.withOpacity(0.63),
                    AppColors.primary,
                  ],
                ),
                icon: Obx(
                  () => Icon(
                    controller.isReadOnly.value
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFavoriteVerses(ReadController controller) {
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${verse.surahNumber} - ${verse.number}",
                              style: AppTextStyles.mediumBoldText,
                            ),
                            Text(
                              verse.translation,
                              style: AppTextStyles.smallBoldText,
                              textAlign: TextAlign.start,
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
