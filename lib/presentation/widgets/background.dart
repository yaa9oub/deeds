// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.secondary,
                Color(0xFFffffff).withOpacity(0.26),
                Color(0xFFA020F0).withOpacity(0.69),
              ],
            ),
          ),
        ),
        Positioned(
          left: 150,
          child: Container(
            width: MediaQuery.of(context).size.height,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              // color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.9),
                  blurRadius: 20,
                  spreadRadius: 10,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFA020F0).withOpacity(0),
                Color(0xFFFFABE2).withOpacity(0.6),
              ],
            ),
          ),
        ),
        // Positioned.fill(
        //   child: Blur(
        //     blur: 2,
        //     blurColor: Colors.white,
        //     colorOpacity: 0.1,
        //     child: Container(),
        //   ),
        // ),
      ],
    );
  }
}
