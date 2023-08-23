import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/properties_map.dart';

part 'implementations/integer.dart';
part 'implementations/string.dart';
part 'implementations/properties_map.dart';

typedef HintCallback<T> = String Function(T? data);

sealed class ButtonPropertyValidator<T> {
  const ButtonPropertyValidator(this.hintCallback);

  final HintCallback<T> hintCallback;

  String? validate(T? data);
}

///
final class ButtonPropertyValidatorWrapper<T>
    extends ButtonPropertyValidator<T> {
  ButtonPropertyValidatorWrapper(
    this.validateCallback,
  ) : super((_) => '');

  @protected
  final String? Function(T? data) validateCallback;

  @override
  String? validate(T? data) => validateCallback(data);
}

///
final class NotNullButtonPropertyValidator<T>
    extends ButtonPropertyValidator<T> {
  const NotNullButtonPropertyValidator(super.hintCallback);

  @override
  String? validate(T? data) {
    if (data != null) return null;
    return hintCallback(data);
  }
}

abstract class ButtonPropertyValidators {
  static ButtonPropertyValidator<T> notNullValidator<T>(
    BuildContext context,
  ) {
    return NotNullButtonPropertyValidator<T>(
      (data) => context.l10n.theFieldShouldNotBeEmptyHintError,
    );
  }

  static ButtonPropertyValidator<String> intOrNullValidator(
    BuildContext context,
  ) {
    return IntOrNullStringButtonPropertyValidator(
      (data) => context.l10n.incorrectValueHintError,
    );
  }

  static ButtonPropertyValidator<String> notEmptyValidator(
    BuildContext context,
  ) {
    return StringButtonPropertyValidator.notEmpty(
      (data) => context.l10n.theFieldShouldNotBeEmptyHintError,
    );
  }

  static ButtonPropertyValidator<int> minValueValidator(
    BuildContext context,
    int minValue,
  ) {
    return IntButtonPropertyValidator.minValue(
      (data) => context.l10n.notLessThanHintError(minValue),
      min: minValue,
    );
  }

  static ButtonPropertyValidator<int> maxValueValidator(
    BuildContext context,
    int maxValue,
  ) {
    return IntButtonPropertyValidator.maxValue(
      (data) => context.l10n.notGreaterThanHintError(maxValue),
      max: maxValue,
    );
  }

  static ButtonPropertyValidator<T>
      minPropertyEntriesValidator<T extends PropertiesMap<dynamic>>(
    BuildContext context,
    int minEntries,
  ) {
    return PropertiesMapButtonPropertyValidator<T>.minEntries(
      (data) => context.l10n.theMinimumNumberOfPackagesHintError(minEntries),
      minEntries: minEntries,
    );
  }
}

extension ButtonPropertyValidatorExtension on BuildContext {
  ButtonPropertyValidator<int> maxValueValidator(int maxValue) {
    return ButtonPropertyValidators.maxValueValidator(this, maxValue);
  }

  ButtonPropertyValidator<int> minValueValidator(int minValue) {
    return ButtonPropertyValidators.minValueValidator(this, minValue);
  }

  ButtonPropertyValidator<String> intOrNullStringValidator() {
    return ButtonPropertyValidators.intOrNullValidator(this);
  }

  ButtonPropertyValidator<T> notNullValidator<T>() {
    return ButtonPropertyValidators.notNullValidator(this);
  }

  ButtonPropertyValidator<String> notEmptyValidator() {
    return ButtonPropertyValidators.notEmptyValidator(this);
  }

  ButtonPropertyValidator<T>
      minPropertyEntriesValidator<T extends PropertiesMap<dynamic>>(
    int minEntries,
  ) {
    return ButtonPropertyValidators.minPropertyEntriesValidator<T>(
      this,
      minEntries,
    );
  }
}
