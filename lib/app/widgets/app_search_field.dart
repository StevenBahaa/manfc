import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class AppSearchField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Duration debounceDuration;
  final bool autofocus;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onClear;
  final TextInputAction textInputAction;

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search',
    this.onChanged,
    this.onSubmitted,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.autofocus = false,
    this.margin,
    this.onClear,
    this.textInputAction = TextInputAction.search,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller;
  Timer? _debounce;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _showClear = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (_showClear != hasText) {
      setState(() => _showClear = hasText);
    }

    if (widget.onChanged != null) {
      _debounce?.cancel();
      _debounce = Timer(widget.debounceDuration, () {
        widget.onChanged!(_controller.text.trim());
      });
    }
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
    setState(() => _showClear = false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_handleTextChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

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

    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: palette.inputFill,
        borderRadius: AppRadius.input,
        border: Border.all(color: palette.inputBorder, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(CupertinoIcons.search, size: 18, color: palette.iconSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: widget.autofocus,
              textInputAction: widget.textInputAction,
              style: textStyles.body,
              cursorColor: palette.primary,
              decoration: InputDecoration(
                isDense: true,
                hintText: widget.hintText,
                hintStyle: textStyles.body.copyWith(
                  color: palette.textTertiary,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onSubmitted: widget.onSubmitted,
            ),
          ),
          if (_showClear)
            GestureDetector(
              onTap: _clear,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  CupertinoIcons.clear_circled_solid,
                  size: 18,
                  color: palette.textTertiary,
                ),
              ),
            )
          else
            const SizedBox(width: 12),
        ],
      ),
    );
  }
}
