import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_properties_manager.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_check/button_property_validators.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/button_property_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/button_input_field_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/incoming_package_getter_input_fields_widget.dart';

class ButtonAxisUpdatePeriodMillisInputField
    extends IntButtonPropertyInputField {
  ButtonAxisUpdatePeriodMillisInputField({int? initialValue})
      : super(
          widgetBuilder: (context, manager) {
            return ButtonInputFieldWidget<int?>(
              title: context.l10n.updatePeriodInMillisecondsFiledTitle,
              onChanged: manager
                  .setValue<int?, ButtonAxisUpdatePeriodMillisInputField>,
              mapper: IntParseNullable.tryParseNullable,
              initialValue: initialValue?.toString(),
              formatIntToHex: false,
              postMapValidators: (context) => [
                context.notNullValidator(),
                context.minValueValidator(0),
                context.maxValueValidator(5000),
              ],
            );
          },
        );
}

extension GetUpdatePeriodExtension on ButtonPropertiesManager {
  int get getAxisUpdatePeriodMillis =>
      getValue<int, ButtonAxisUpdatePeriodMillisInputField>();
}
