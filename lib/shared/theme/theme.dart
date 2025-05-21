import 'package:flutter/material.dart';

import '../constants/text_sizes.dart';

ThemeData getAppTheme(BuildContext context) {
  final textSizes = TextSizes();

  return ThemeData(
    fontFamily: 'Inter',
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: textSizes.headingLarge,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: textSizes.headingMedium,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: textSizes.headingSmall,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: textSizes.bodyLarge,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: textSizes.bodyMedium,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: textSizes.bodySmall,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: textSizes.labelLarge,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: textSizes.labelMedium,
      ),
      labelSmall: TextStyle(fontFamily: 'Inter', fontSize: textSizes.labelSmall),
    ),
    primarySwatch: Colors.blue,
  );
}
