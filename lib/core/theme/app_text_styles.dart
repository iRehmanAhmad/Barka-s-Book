import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get urduHeadline {
    try {
      return GoogleFonts.notoNastaliqUrdu(
        fontSize: 38,
        fontWeight: FontWeight.bold,
        color: AppColors.deepNavy,
        height: 1.8,
      );
    } catch (_) {
      return const TextStyle(
        fontFamily: 'NotoNastaliqUrdu',
        fontSize: 38,
        fontWeight: FontWeight.bold,
        color: AppColors.deepNavy,
        height: 1.8,
      );
    }
  }

  static TextStyle get urduWord {
    try {
      return GoogleFonts.notoNastaliqUrdu(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: AppColors.deepNavy,
        height: 1.7,
      );
    } catch (_) {
      return const TextStyle(
        fontFamily: 'NotoNastaliqUrdu',
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: AppColors.deepNavy,
        height: 1.7,
      );
    }
  }

  static TextStyle get englishAlphabetHero {
    try {
      return GoogleFonts.quicksand(
        fontSize: 72,
        fontWeight: FontWeight.w900,
        color: AppColors.deepNavy,
      );
    } catch (_) {
      return const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w900,
        color: AppColors.deepNavy,
      );
    }
  }

  static TextStyle get englishWordBadge {
    try {
      return GoogleFonts.quicksand(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );
    } catch (_) {
      return const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );
    }
  }

  static TextStyle get mathNumberHero {
    try {
      return GoogleFonts.quicksand(
        fontSize: 80,
        fontWeight: FontWeight.w900,
        color: AppColors.sunOrange,
      );
    } catch (_) {
      return const TextStyle(
        fontSize: 80,
        fontWeight: FontWeight.w900,
        color: AppColors.sunOrange,
      );
    }
  }
}
