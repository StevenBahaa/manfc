import 'package:flutter/material.dart';

TextStyle _style({
  required Color color,
  required double size,
  required FontWeight weight,
  double? letterSpacing,
  double? height,
}) {
  return TextStyle(
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
  );
}

@immutable
class AppTextStyleSet {
  final TextStyle largeTitle;
  final TextStyle title1;
  final TextStyle title2;
  final TextStyle title3;
  final TextStyle headline;
  final TextStyle body;
  final TextStyle bodyMedium;
  final TextStyle subhead;
  final TextStyle footnote;
  final TextStyle caption;
  final TextStyle button;
  final TextStyle amountLarge;
  final TextStyle amountMedium;
  final TextStyle amountSmall;

  const AppTextStyleSet({
    required this.largeTitle,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.headline,
    required this.body,
    required this.bodyMedium,
    required this.subhead,
    required this.footnote,
    required this.caption,
    required this.button,
    required this.amountLarge,
    required this.amountMedium,
    required this.amountSmall,
  });
}

abstract final class AppTextStyles {
  static AppTextStyleSet create({
    required Color primaryText,
    required Color secondaryText,
    required Color tertiaryText,
    required Color buttonText,
  }) {
    return AppTextStyleSet(
      largeTitle: _style(
        color: primaryText,
        size: 32,
        weight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.15,
      ),
      title1: _style(
        color: primaryText,
        size: 26,
        weight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      title2: _style(
        color: primaryText,
        size: 22,
        weight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.25,
      ),
      title3: _style(
        color: primaryText,
        size: 18,
        weight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
      ),
      headline: _style(
        color: primaryText,
        size: 16,
        weight: FontWeight.w600,
        height: 1.3,
      ),
      body: _style(
        color: primaryText,
        size: 15,
        weight: FontWeight.w400,
        height: 1.45,
      ),
      bodyMedium: _style(
        color: primaryText,
        size: 15,
        weight: FontWeight.w500,
        height: 1.45,
      ),
      subhead: _style(
        color: secondaryText,
        size: 14,
        weight: FontWeight.w500,
        height: 1.4,
      ),
      footnote: _style(
        color: secondaryText,
        size: 13,
        weight: FontWeight.w400,
        height: 1.35,
      ),
      caption: _style(
        color: tertiaryText,
        size: 12,
        weight: FontWeight.w400,
        height: 1.3,
      ),
      button: _style(
        color: buttonText,
        size: 16,
        weight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.2,
      ),
      amountLarge: _style(
        color: primaryText,
        size: 28,
        weight: FontWeight.w700,
        letterSpacing: -0.7,
        height: 1.15,
      ),
      amountMedium: _style(
        color: primaryText,
        size: 20,
        weight: FontWeight.w700,
        letterSpacing: -0.4,
        height: 1.2,
      ),
      amountSmall: _style(
        color: primaryText,
        size: 16,
        weight: FontWeight.w600,
        height: 1.25,
      ),
    );
  }
}
