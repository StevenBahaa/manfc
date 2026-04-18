import 'package:flutter/widgets.dart';

import 'app_breakpoints.dart';
import 'app_spacing.dart';

enum AppScreenSize { compact, medium, expanded }

abstract final class AppResponsive {
  static AppScreenSize getSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= AppBreakpoints.expanded) {
      return AppScreenSize.expanded;
    }
    if (width >= AppBreakpoints.medium) {
      return AppScreenSize.medium;
    }
    return AppScreenSize.compact;
  }

  static bool isCompact(BuildContext context) =>
      getSize(context) == AppScreenSize.compact;

  static bool isMedium(BuildContext context) =>
      getSize(context) == AppScreenSize.medium;

  static bool isExpanded(BuildContext context) =>
      getSize(context) == AppScreenSize.expanded;

  static double screenPadding(BuildContext context) {
    switch (getSize(context)) {
      case AppScreenSize.compact:
        return AppSpacing.screenPaddingCompact;
      case AppScreenSize.medium:
        return AppSpacing.screenPaddingMedium;
      case AppScreenSize.expanded:
        return AppSpacing.screenPaddingExpanded;
    }
  }

  static double maxContentWidth(BuildContext context) {
    switch (getSize(context)) {
      case AppScreenSize.compact:
        return double.infinity;
      case AppScreenSize.medium:
        return 720;
      case AppScreenSize.expanded:
        return 920;
    }
  }

  static int dashboardGridCount(BuildContext context) {
    switch (getSize(context)) {
      case AppScreenSize.compact:
        return 2;
      case AppScreenSize.medium:
        return 3;
      case AppScreenSize.expanded:
        return 4;
    }
  }
}
