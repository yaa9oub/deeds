import 'package:deeds/app/routes/app_urls.dart';
import 'package:deeds/core/constants/assets.dart';
import 'package:deeds/core/constants/text.dart';
import 'package:deeds/presentation/chat/chat_page.dart';
import 'package:deeds/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constants/colors.dart';
import '../widgets/background.dart';
import './splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<SplashController>();
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Background(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  SizedBox(
                    width: 150.w,
                    height: 150.w,
                    child: Image.asset(
                      AppAssets.logo,
                      fit: BoxFit.fitWidth,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                  Text(
                    'Deeds',
                    style: AppTextStyles.mediumBoldText,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    width: 280.w,
                    height: 150.h,
                    child: TypingText(
                      text:
                          'Whoever recites a letter from the book of Allah, will have a (Hasana) and a (Hasana) is rewarded tenfold like it.\n"Prophet Muhammed (PBUH)"',
                      textStyle: AppTextStyles.smallMidText,
                    ),
                  ),
                  Spacer(),
                  PrimaryButton(
                    width: 240.w,
                    label: "Continue",
                    onPressed: () {
                      Get.toNamed(AppRoutes.home);
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
