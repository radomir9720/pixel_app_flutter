import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/button_property_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/color_and_title_matchers_input_fields_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/color_matcher_input_fields_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/status_matcher_input_fields_widget.dart';

class ColorAndStatusMatchersInputFields extends ButtonPropertyInputField<void> {
  ColorAndStatusMatchersInputFields()
      : super(
          widgetBuilder: (context, manager) {
            manager
              ..addObjectInitializer<ColorMatcherProrpertiesMap>(
                () => ColorMatcherProrpertiesMap({}),
              )
              ..addObjectInitializer<StringMatcherProrpertiesMap>(
                () => StringMatcherProrpertiesMap({}),
              );

            return ColorAndStatusMatchersInputFieldsWidget(manager: manager);
          },
        );
}
