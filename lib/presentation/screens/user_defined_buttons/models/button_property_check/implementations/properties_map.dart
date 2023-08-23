part of '../button_property_validators.dart';

sealed class PropertiesMapButtonPropertyValidator<
    T extends PropertiesMap<dynamic>> extends ButtonPropertyValidator<T> {
  const PropertiesMapButtonPropertyValidator(super.hintCallback);

  const factory PropertiesMapButtonPropertyValidator.minEntries(
    HintCallback<T> onInvalidDataCallback, {
    required int minEntries,
  }) = MinPropertyEntriesButtonPropertyValidator;
}

final class MinPropertyEntriesButtonPropertyValidator<
        T extends PropertiesMap<dynamic>>
    extends PropertiesMapButtonPropertyValidator<T> {
  const MinPropertyEntriesButtonPropertyValidator(
    super.hintCallback, {
    required this.minEntries,
  });

  @protected
  final int minEntries;

  @override
  String? validate(T? data) {
    if (data == null) return hintCallback(data);
    if (data.entries.length < minEntries) return hintCallback(data);

    return null;
  }
}
