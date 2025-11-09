
import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies1/Utls/colors.dart';

class AppStyle{
  static final TextStyle med14white=GoogleFonts.elMessiri(
    color: AppColors.whiteColor,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  static final TextStyle med16black=GoogleFonts.elMessiri(
    color: AppColors.blackColor,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );
  static final TextStyle med14primary=GoogleFonts.elMessiri(
    color: AppColors.prirmaryColor,
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );
  static final TextStyle med16white=GoogleFonts.elMessiri(
    color: AppColors.whiteColor,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );
  static final TextStyle med20black=GoogleFonts.elMessiri(
    color: AppColors.blackColor,
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );
}