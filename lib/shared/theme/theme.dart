import 'package:flutter/material.dart';

import '../constants/text_sizes.dart';

ThemeData getAppTheme(BuildContext context) {
  final textSizes = TextSizes();

  return ThemeData(
    fontFamily: 'Poppins',
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: textSizes.headingLarge,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: textSizes.headingMedium,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: textSizes.headingSmall,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: textSizes.bodyLarge,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: textSizes.bodyMedium,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: textSizes.bodySmall,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: textSizes.labelLarge,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: textSizes.labelMedium,
      ),
      labelSmall: TextStyle(fontFamily: 'Poppins', fontSize: textSizes.labelSmall),
    ),
    primarySwatch: Colors.blue,
  );
}
