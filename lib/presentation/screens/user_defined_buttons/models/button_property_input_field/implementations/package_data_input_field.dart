import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_check/button_property_validators.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/button_input_field_widget.dart';

class PackageDataInputField extends ButtonInputFieldWidget<List<int>?> {
  PackageDataInputField({
    super.key,
    required super.title,
    required super.onChanged,
    super.enabled,
    super.helperText,
    super.hintText,
    super.isRequired,
    super.postMapValidators,
    List<ButtonPropertyValidator<String>> Function(BuildContext)?
        preMapValidators,
  }) : super(
          mapper: (value) => value.parseListOfInts(),
          preMapValidators: (context) {
            return [
              ButtonPropertyValidatorWrapper(
                (data) {
                  if (data == null) return null;
                  if (data.isEmpty) return null;
                  if ((data.parseListOfInts()?.isEmpty ?? true) ||
                      data.hasUnparsedSegments) {
                    return context.l10n.incorrectFormatHintError;
                  }
                  return null;
                },
              ),
              ...?preMapValidators?.call(context),
            ];
          },
        );
}

extension on String {
  List<int>? parseListOfInts() {
    return replaceAll(',', ' ')
        .split(' ')
        .map((e) => int.tryParse(e.trim()))
        .whereNotNull()
        .toList();
  }

  bool get hasUnparsedSegments {
    return replaceAll(',', ' ')
        .split(' ')
        .map((e) => int.tryParse(e.trim()))
        .where((element) => element == null)
        .isNotEmpty;
  }
}
