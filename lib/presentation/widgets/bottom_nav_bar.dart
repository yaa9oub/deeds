import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/routes/app_urls.dart';
import '../../core/constants/colors.dart';
import 'bottom_nav_button.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    this.isHome = false,
    this.isRead = false,
    this.isFavorites = false,
    this.isSettings = false,
  });
  final bool isHome, isRead, isFavorites, isSettings;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 90.h,
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  child: RepaintBoundary(
                    child: Blur(
                      blur: 5,
                      blurColor: AppColors.whiteColor,
                      colorOpacity: 0.3,
                      child: Container(),
                    ),
                  ),
                ),
              ),
              Row(
                spacing: 6.w,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomNavButton(
                    icon: CupertinoIcons.house_fill,
                    title: "Home",
                    route: AppRoutes.home,
                    isSelected: isHome,
                  ),
                  BottomNavButton(
                    icon: CupertinoIcons.book,
                    title: "Quran",
                    route: AppRoutes.read,
                    isSelected: isRead,
                  ),
                  BottomNavButton(
                    icon: CupertinoIcons.chat_bubble,
                    title: "Qna",
                    route: AppRoutes.chat,
                    isSelected: isFavorites,
                  ),
                  // BottomNavButton(
                  //   icon: CupertinoIcons.settings,
                  //   title: "Settings",
                  //   route: AppRoutes.home,
                  //   isSelected: isSettings,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
