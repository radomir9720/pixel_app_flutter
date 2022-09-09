enum AppBrightness { dark, light }

extension OppositeExtension on AppBrightness {
  AppBrightness get opposite {
    return when(
      dark: () => AppBrightness.light,
      light: () => AppBrightness.dark,
    );
  }
}

extension BoolExtension on AppBrightness {
  bool get isDark => this == AppBrightness.dark;

  bool get isLight => this == AppBrightness.light;
}

extension WhenExtension on AppBrightness {
  R when<R>({
    required R Function() dark,
    required R Function() light,
  }) {
    switch (this) {
      case AppBrightness.dark:
        return dark();
      case AppBrightness.light:
        return light();
    }
  }
}

extension AppBrightnessFromStringExt on AppBrightness {
  static AppBrightness fromString({
    required String? value,
    required AppBrightness ifAbsent,
  }) {
    return AppBrightness.values.firstWhere(
      (element) => element.name == value,
      orElse: () => ifAbsent,
    );
  }
}
