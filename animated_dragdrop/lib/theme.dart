import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Using static variable for theme is not recommended for production use
/// since you won't be able to changes textTheme at runtime.
/// This is a shortcut used only for the purpose of this challenge.
abstract class AppColors {
  static const backgroundColor = Color(0xfff3f7fa);
  static const blue1 = Color(0xff626FE0);
  static const blue2 = Color(0xff4CC4F7);
  static const green1 = Color(0xff5ECC5C);
  static const green2 = Color(0xff69D1AC);
}

/// Using static variable for theme is not recommended for production use
/// since you won't be able to changes textTheme at runtime.
/// This is a shortcut used only for the purpose of this challenge.
abstract class TextStyles {
  static final base = GoogleFonts.inter();

  static final appTitle = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    textStyle: const TextStyle(
      fontSize: 28,
      color: Color(0xffEAFFFF),
    ),
  );

  static final appSubtitle = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    textStyle: const TextStyle(
      fontSize: 14,
      color: Color(0xffBCDEFF),
    ),
  );

  static final cardText = GoogleFonts.inter(
    fontWeight: FontWeight.bold,
    textStyle: const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
  );

  static final horizontalCardText = GoogleFonts.inter(
    fontWeight: FontWeight.bold,
    textStyle: const TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
  );

  static final cardNumber = GoogleFonts.inter(
    fontWeight: FontWeight.bold,
    textStyle: TextStyle(
      fontSize: 20,
      color: Colors.black.withOpacity(.7),
    ),
  );

  static final bottomCardText = GoogleFonts.inter(
    fontWeight: FontWeight.bold,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Color(0xff9D9DA0),
    ),
  );

  static final buttonText = GoogleFonts.inter(
    fontWeight: FontWeight.bold,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Colors.white,
    ),
  );
}

enum Dimensions with SpaceDimensionsMixin {
  xlarge,
  large,
  medium,
  small,
}

const dimensionsTheme = DimensionsTheme({
  Dimensions.xlarge: 30,
  Dimensions.large: 24,
  Dimensions.medium: 20,
  Dimensions.small: 12,
});
