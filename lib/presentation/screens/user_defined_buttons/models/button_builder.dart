import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_properties_manager.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/button_property_input_field.dart';

class ButtonBuilder<T extends UserDefinedButton> {
  ButtonBuilder({
    required this.fields,
    required this.builder,
  });

  final List<ButtonPropertyInputField<dynamic>> fields;

  final T Function(ButtonPropertiesManager manager) builder;
}
