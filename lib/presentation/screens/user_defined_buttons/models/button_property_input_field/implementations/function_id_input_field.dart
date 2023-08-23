import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_check/button_property_validators.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/button_input_field_widget.dart';

class FunctionIdInputField extends ButtonInputFieldWidget<int?> {
  FunctionIdInputField({
    super.key,
    required super.title,
    required super.onChanged,
    super.enabled,
    super.helperText,
    super.hintText,
    super.isRequired,
    List<ButtonPropertyValidator<String>> Function(BuildContext)?
        preMapValidators,
    super.postMapValidators,
  }) : super(
          mapper: int.tryParse,
          preMapValidators: (context) {
            return [
              context.intOrNullStringValidator(),
              //
              ...?preMapValidators?.call(context),
            ];
          },
        );
}
