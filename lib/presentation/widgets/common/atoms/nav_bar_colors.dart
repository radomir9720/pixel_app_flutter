import 'package:flutter/material.dart';

class NavBarColors extends ThemeExtension<NavBarColors> {
  NavBarColors({
    required this.icon,
    required this.selectedBackground,
    required this.unselectedBackground,
    required this.selectedText,
    required this.unselectedText,
    required this.divider,
  });

  final Color icon;

  final Color selectedBackground;

  final Color unselectedBackground;

  final Color selectedText;

  final Color unselectedText;

  final Color divider;

  @override
  ThemeExtension<NavBarColors> copyWith({
    Color? icon,
    Color? selectedBackground,
    Color? unselectedBackground,
    Color? selectedText,
    Color? unselectedText,
    Color? divider,
  }) {
    return NavBarColors(
      icon: icon ?? this.icon,
      selectedText: selectedText ?? this.selectedText,
      unselectedText: unselectedText ?? this.unselectedText,
      selectedBackground: selectedBackground ?? this.selectedBackground,
      unselectedBackground: unselectedBackground ?? this.unselectedBackground,
      divider: divider ?? this.divider,
    );
  }

  @protected
  static const defaultColor = Colors.transparent;

  @override
  ThemeExtension<NavBarColors> lerp(
    ThemeExtension<NavBarColors>? other,
    double t,
  ) {
    if (other is! NavBarColors) {
      return this;
    }

    return NavBarColors(
      icon: Color.lerp(icon, other.icon, t) ?? defaultColor,
      selectedBackground:
          Color.lerp(selectedBackground, other.selectedBackground, t) ??
              defaultColor,
      unselectedBackground:
          Color.lerp(unselectedBackground, other.unselectedBackground, t) ??
              defaultColor,
      selectedText:
          Color.lerp(selectedText, other.selectedText, t) ?? defaultColor,
      unselectedText:
          Color.lerp(unselectedText, other.unselectedText, t) ?? defaultColor,
      divider: Color.lerp(divider, other.divider, t) ?? defaultColor,
    );
  }
}
