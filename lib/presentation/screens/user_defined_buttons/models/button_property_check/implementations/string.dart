part of '../button_property_validators.dart';

/// [String]
sealed class StringButtonPropertyValidator
    extends ButtonPropertyValidator<String> {
  const StringButtonPropertyValidator(super.hintCallback);

  const factory StringButtonPropertyValidator.notEmpty(
    HintCallback<String> onInvalidDataCallback,
  ) = StringNotEmptyButtonPropertyValidator;
}

final class StringNotEmptyButtonPropertyValidator
    extends StringButtonPropertyValidator {
  const StringNotEmptyButtonPropertyValidator(super.onInvalidData);

  @override
  String? validate(String? data) {
    if (data?.isNotEmpty ?? false) return null;
    return hintCallback(data);
  }
}

final class IntOrNullStringButtonPropertyValidator
    extends StringButtonPropertyValidator {
  const IntOrNullStringButtonPropertyValidator(super.hintCallback);

  @override
  String? validate(String? data) {
    if (data == null) return null;
    if (data.isEmpty) return null;
    if (int.tryParse(data) != null) return null;
    return hintCallback(data);
  }
}

final class DoubleOrNullStringButtonPropertyValidator
    extends StringButtonPropertyValidator {
  const DoubleOrNullStringButtonPropertyValidator(super.hintCallback);

  @override
  String? validate(String? data) {
    if (data == null) return null;
    if (data.isEmpty) return null;
    if (double.tryParse(data) != null) return null;
    return hintCallback(data);
  }
}
