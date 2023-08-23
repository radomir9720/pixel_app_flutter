part of '../button_property_validators.dart';

sealed class IntButtonPropertyValidator extends ButtonPropertyValidator<int> {
  const IntButtonPropertyValidator(super.hintCallback);

  const factory IntButtonPropertyValidator.minMaxValues(
    HintCallback<int> onInvalidDataCallback, {
    required int min,
    required int max,
  }) = IntMinMaxValuesPropertyValidator;

  const factory IntButtonPropertyValidator.minValue(
    HintCallback<int> onInvalidDataCallback, {
    required int min,
  }) = IntMinValuePropertyValidator;

  const factory IntButtonPropertyValidator.maxValue(
    HintCallback<int> onInvalidDataCallback, {
    required int max,
  }) = IntMaxValuePropertyValidator;
}

final class IntMinMaxValuesPropertyValidator
    extends IntButtonPropertyValidator {
  const IntMinMaxValuesPropertyValidator(
    super.hintCallback, {
    required this.min,
    required this.max,
  });

  final int min;

  final int max;

  @override
  String? validate(int? data) {
    if (data == null) return hintCallback(data);
    if (data < min || data > max) return hintCallback(data);
    return null;
  }
}

final class IntMinValuePropertyValidator extends IntButtonPropertyValidator {
  const IntMinValuePropertyValidator(
    super.hintCallback, {
    required this.min,
  });

  final int min;

  @override
  String? validate(int? data) {
    if (data == null) return hintCallback(data);
    if (data < min) return hintCallback(data);
    return null;
  }
}

final class IntMaxValuePropertyValidator extends IntButtonPropertyValidator {
  const IntMaxValuePropertyValidator(
    super.hintCallback, {
    required this.max,
  });

  final int max;

  @override
  String? validate(int? data) {
    if (data == null) return hintCallback(data);
    if (data > max) return hintCallback(data);
    return null;
  }
}
