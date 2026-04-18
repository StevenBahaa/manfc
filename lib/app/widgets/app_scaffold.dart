import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_responsive.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool useLargeTitle;
  final Widget? trailing;
  final Widget? leading;
  final bool safeTop;
  final bool safeBottom;
  final bool centerContent;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? materialAppBar;
  final List<Widget>? slivers;

  const AppScaffold({
    super.key,
    required this.child,
    this.title,
    this.useLargeTitle = false,
    this.trailing,
    this.leading,
    this.safeTop = true,
    this.safeBottom = true,
    this.centerContent = true,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
    this.padding,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.materialAppBar,
    this.slivers,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final textStyles = AppTextStyles.create(
      primaryText: palette.textPrimary,
      secondaryText: palette.textSecondary,
      tertiaryText: palette.textTertiary,
      buttonText: palette.textOnPrimary,
    );

    final horizontalPadding = AppResponsive.screenPadding(context);

    Widget wrappedChild(Widget value, {bool? overrideSafeTop}) {
      return SafeArea(
        top: overrideSafeTop ?? safeTop,
        bottom: safeBottom,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: centerContent
                  ? AppResponsive.maxContentWidth(context)
                  : double.infinity,
            ),
            child: Padding(
              padding:
                  padding ??
                  EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: value,
            ),
          ),
        ),
      );
    }

    if (materialAppBar != null) {
      return Scaffold(
        backgroundColor: backgroundColor ?? palette.background,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: materialAppBar,
        body: wrappedChild(child),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      );
    }

    if (slivers != null) {
      return Scaffold(
        backgroundColor: backgroundColor ?? palette.background,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        body: CupertinoPageScaffold(
          backgroundColor: backgroundColor ?? palette.background,
          navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            backgroundColor: (backgroundColor ?? palette.background).withValues(
              alpha: 0.96,
            ),
            border: Border(
              bottom: BorderSide(color: palette.divider, width: 0.6),
            ),
            middle: useLargeTitle
                ? null
                : (title != null
                      ? Text(title!, style: textStyles.headline)
                      : null),
            leading: leading,
            trailing: trailing,
          ),
          child: CustomScrollView(
            slivers: [
              if (useLargeTitle && title != null)
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: centerContent
                              ? AppResponsive.maxContentWidth(context)
                              : double.infinity,
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            AppSpacing.md,
                            horizontalPadding,
                            AppSpacing.lg,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title!,
                                  style: textStyles.largeTitle,
                                ),
                              ),
                              if (trailing != null) trailing!,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ...slivers!,
            ],
          ),
        ),
      );
    }

    if (title != null) {
      return Scaffold(
        backgroundColor: backgroundColor ?? palette.background,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        body: CupertinoPageScaffold(
          backgroundColor: backgroundColor ?? palette.background,
          navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            backgroundColor: (backgroundColor ?? palette.background).withValues(
              alpha: 0.96,
            ),
            border: Border(
              bottom: BorderSide(color: palette.divider, width: 0.6),
            ),
            middle: useLargeTitle
                ? null
                : Text(title!, style: textStyles.headline),
            leading: leading,
            trailing: useLargeTitle ? null : trailing,
          ),
          child: Column(
            children: [
              if (useLargeTitle)
                SafeArea(
                  bottom: false,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: centerContent
                            ? AppResponsive.maxContentWidth(context)
                            : double.infinity,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          AppSpacing.md,
                          horizontalPadding,
                          AppSpacing.lg,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(title!, style: textStyles.largeTitle),
                            ),
                            if (trailing != null) trailing!,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: wrappedChild(child, overrideSafeTop: !useLargeTitle),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? palette.background,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: wrappedChild(child),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
