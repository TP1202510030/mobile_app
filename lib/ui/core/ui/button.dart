import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/app_accent_colors.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';

/// A customizable button widget supporting primary, secondary, text, and accent variants.
///
/// The [CustomButton] widget provides a flexible button implementation with
/// support for loading state, full width display, and variant-based styling.
///
/// - [onTap]: Callback invoked when the button is pressed. If null, the button is disabled.
/// - [child]: The widget displayed inside the button.
/// - [isLoading]: If true, displays a loading indicator and disables the button.
/// - [isFullWidth]: If true, the button expands to fill the available width.
/// - [variant]: Determines the button style (primary, secondary, or text).
///
/// Use the [CustomButton.text] factory for a convenient way to create a button with a text label.
///
/// Example usage:
/// ```dart
/// CustomButton(
///   onTap: () {},
///   child: Text('Submit'),
///   isLoading: false,
///   variant: ButtonVariant.primary,
/// )
/// ```
///
/// See also:
/// - [ButtonVariant] for available button styles.
/// - [ElevatedButton], [OutlinedButton], [TextButton] for underlying implementations.

enum ButtonVariant { primary, secondary, text, accent }

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final bool isLoading;
  final bool isFullWidth;
  final ButtonVariant variant;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.child,
    this.isLoading = false,
    this.isFullWidth = true,
    this.variant = ButtonVariant.primary,
  });

  factory CustomButton.text({
    required VoidCallback? onTap,
    required String text,
    bool isLoading = false,
    bool isFullWidth = true,
    ButtonVariant variant = ButtonVariant.primary,
  }) {
    return CustomButton(
      onTap: onTap,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      variant: variant,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null || isLoading;

    Widget buttonContent = isLoading
        ? SizedBox(
            height: AppSizes.iconSizeSmall,
            width: AppSizes.iconSizeSmall,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: _getForegroundColor(context),
            ),
          )
        : child;

    Widget button;
    switch (variant) {
      case ButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onTap,
          style: _getButtonStyle(context),
          child: buttonContent,
        );
        break;
      case ButtonVariant.secondary:
        button = OutlinedButton(
          onPressed: isDisabled ? null : onTap,
          style: _getButtonStyle(context),
          child: buttonContent,
        );
        break;
      case ButtonVariant.accent:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onTap,
          style: _getButtonStyle(context),
          child: buttonContent,
        );
        break;
      case ButtonVariant.text:
        button = TextButton(
          onPressed: isDisabled ? null : onTap,
          style: _getButtonStyle(context),
          child: buttonContent,
        );
        break;
    }

    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: button,
          )
        : button;
  }

  Color? _getForegroundColor(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
        return Theme.of(context).colorScheme.onPrimary;
      case ButtonVariant.accent:
        return Theme.of(context).colorScheme.onPrimary;
      case ButtonVariant.secondary:
      case ButtonVariant.text:
        return Theme.of(context).colorScheme.primary;
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final baseStyle = ButtonStyle(
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: AppSizes.spacingMedium,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return Theme.of(context).colorScheme.onSurface.withAlpha(31);
          }
          return _getForegroundColor(context);
        },
      ),
    );

    switch (variant) {
      case ButtonVariant.primary:
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(WidgetState.disabled)) {
                return Theme.of(context).colorScheme.onSurface.withAlpha(31);
              }
              return Theme.of(context).colorScheme.primary;
            },
          ),
        );
      case ButtonVariant.secondary:
        return baseStyle.copyWith(
          side: WidgetStateProperty.resolveWith<BorderSide?>(
            (states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(31),
                );
              }
              return BorderSide(color: Theme.of(context).colorScheme.primary);
            },
          ),
        );
      case ButtonVariant.accent:
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(WidgetState.disabled)) {
                return Theme.of(context).colorScheme.onSurface.withAlpha(31);
              }

              return Theme.of(context).extension<AppAccentColors>()!.accent;
            },
          ),
        );
      case ButtonVariant.text:
        return baseStyle;
    }
  }
}
