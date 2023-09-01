import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/button_property_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/color_matcher_input_fields_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/color_status_and_num_value_field_group.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/status_matcher_input_fields_widget.dart';

class ColorStatusAndNumValueFieldGroup extends ButtonPropertyInputField<void> {
  ColorStatusAndNumValueFieldGroup({
    ColorMatcher? initialColorMatcher,
    StringMatcher? initialStatusMatcher,
    NumValueGetterParameters? initialNumValueGetterParameters,
  }) : super(
          widgetBuilder: (context, manager) {
            manager
              ..addObjectInitializer<ColorMatcherProrpertiesMap>(
                () => ColorMatcherProrpertiesMap({}),
              )
              ..addObjectInitializer<StringMatcherProrpertiesMap>(
                () => StringMatcherProrpertiesMap({}),
              );

            return ColorStatusAndNumValueFieldGroupWidget(
              manager: manager,
              initialColorMatcher: initialColorMatcher,
              initialStatusMatcher: initialStatusMatcher,
              initialNumValueGetterParameters: initialNumValueGetterParameters,
            );
          },
        );
}
