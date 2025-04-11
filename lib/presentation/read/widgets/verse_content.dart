import 'package:deeds/core/constants/text.dart';
import 'package:deeds/domain/entities/surah_entity.dart';
import 'package:deeds/presentation/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerseContent extends StatelessWidget {
  const VerseContent({
    super.key,
    required this.scrollController,
    required this.verse,
  });

  final ScrollController scrollController;
  final VerseEntity? verse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 5.h,
      ),
      child: CardWidget(
        width: MediaQuery.of(context).size.width,
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
                      verse!.text.replaceFirst("\n", ""),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      verse!.translation,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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
}
