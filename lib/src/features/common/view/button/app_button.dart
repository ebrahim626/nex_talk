import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/extensions/context.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonType buttonType;
  final double? width;
  final Color? color;
  final Color? textColor;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final Color? underlineColor;
  final BorderSide? borderSide;
  final double? height;
  final Color? outlineButtonBorderColor;
  final double? borderWidth;
  final double? borderRadius;
  final MaterialTapTargetSize? tapTargetSize;
  final VisualDensity? visualDensity;
  final OutlinedBorder? shape;

  const AppButton({
    super.key,
    required this.child,
    this.onPressed,
    this.buttonType = ButtonType.elevated,
    this.width,
    this.color,
    this.textColor,
    this.textStyle,
    this.padding,
    this.underlineColor,
    this.borderSide,
    this.height,
    this.outlineButtonBorderColor,
    this.borderWidth,
    this.borderRadius,
    this.tapTargetSize,
    this.visualDensity,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case ButtonType.elevated:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                color ?? context.theme.primaryColor, // Button color
            foregroundColor:
                textColor ??
                context.theme.scaffoldBackgroundColor, // Text color
            minimumSize: Size(
              width ?? double.infinity,
              height ?? 45.h,
            ), // Width of the button
            textStyle: textStyle ?? context.text.titleSmall,
            shape:
                shape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 12),
                ),
            padding:
                padding ?? EdgeInsets.symmetric(horizontal: 16.w), // Padding
          ),
          child: child,
        );
      case ButtonType.filled:
        return FilledButton(
          onPressed: onPressed,

          style: FilledButton.styleFrom(
            backgroundColor: color ?? Theme.of(context).primaryColor,
            foregroundColor: textColor ?? Colors.white,
            minimumSize: Size(
              width ?? double.infinity,
              height ?? 45.h,
            ), // Width of the button
            padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
            side: borderSide,
            shape:
                shape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 12),
                ),
          ),
          child: child,
        );
      case ButtonType.filledTonal:
        return FilledButton.tonal(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: color ?? Theme.of(context).primaryColor,
            foregroundColor: textColor ?? Colors.white,
            minimumSize: Size(width ?? double.infinity, 48),
            padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
            shape:
                shape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 12),
                ),
          ),
          child: child,
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor:
                color ?? context.theme.primaryColorDark, // Button color
            minimumSize: Size(width ?? double.infinity, height ?? 45.h),
            side: BorderSide(
              color:
                  outlineButtonBorderColor ??
                  context.theme.unselectedWidgetColor,
              width: borderWidth ?? 0.3,
            ), // Border color
            backgroundColor:
                color ??
                context.theme.scaffoldBackgroundColor, // Background color
            textStyle: textStyle ?? context.text.titleSmall,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
            shape:
                shape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 12),
                ),
          ),
          child: child,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: padding ?? const EdgeInsets.all(0),
            foregroundColor:
                color ?? context.theme.primaryColorDark, // Button color
            // minimumSize: Size(width ?? double.infinity, 48),
            tapTargetSize: tapTargetSize,
            visualDensity: visualDensity,
            textStyle:
                textStyle ??
                context.text.titleSmall?.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor:
                      underlineColor ?? context.theme.primaryColorDark,
                ),
            shape:
                shape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 12),
                ),
          ),
          child: child,
        );
    }
  }
}

enum ButtonType { elevated, filled, filledTonal, outlined, text }
