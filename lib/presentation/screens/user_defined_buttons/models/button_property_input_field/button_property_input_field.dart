import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_properties_manager.dart';

abstract class ButtonPropertyInputField<T> {
  ButtonPropertyInputField({
    required this.widgetBuilder,
  });

  T? data;

  final Widget Function(BuildContext context, ButtonPropertiesManager manager)
      widgetBuilder;
}

abstract class StringButtonPropertyInputField
    extends ButtonPropertyInputField<String> {
  StringButtonPropertyInputField({
    required super.widgetBuilder,
  });
}

abstract class IntButtonPropertyInputField
    extends ButtonPropertyInputField<int> {
  IntButtonPropertyInputField({
    required super.widgetBuilder,
  });
}
