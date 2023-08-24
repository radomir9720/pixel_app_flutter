import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_check/button_property_validators.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/button_input_field_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/incoming_package_getter_input_fields_widget.dart';

class ParameterIdInputField extends ButtonInputFieldWidget<int?> {
  ParameterIdInputField({
    super.key,
    required super.title,
    required super.onChanged,
    super.enabled,
    super.helperText,
    super.hintText,
    super.isRequired,
    super.initialValue,
    super.preMapValidators,
    List<ButtonPropertyValidator<int?>> Function(BuildContext)?
        postMapValidators,
  }) : super(
          mapper: IntParseNullable.tryParseNullable,
          postMapValidators: (context) => [
            context.notNullValidator(),
            context.minValueValidator(0),
            ...?postMapValidators?.call(context),
          ],
        );
}
