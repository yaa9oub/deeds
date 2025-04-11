import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle mediumBoldText = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle midBoldText = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle smallBoldText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle smallMidText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle smallThinText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: Colors.black,
  );

  static const TextStyle smallText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  // static const TextStyle smallMidText = TextStyle(
  //   fontSize: 14,
  //   fontWeight: FontWeight.w500,
  // );

  // static const TextStyle mediumBoldText = TextStyle(
  //   fontSize: 16,
  //   fontWeight: FontWeight.w600,
  // );
}
