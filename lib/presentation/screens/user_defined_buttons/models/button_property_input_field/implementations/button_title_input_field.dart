import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_properties_manager.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/button_property_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/button_input_field_widget.dart';

class ButtonTitleInputField extends StringButtonPropertyInputField {
  ButtonTitleInputField()
      : super(
          widgetBuilder: (context, manager) {
            return ButtonInputFieldWidget(
              title: context.l10n.theNameOfTheButtonFieldTitle,
              onChanged: manager.setValue<String, ButtonTitleInputField>,
              mapper: (value) => value,
            );
          },
        );
}

extension GetTitleExtension on ButtonPropertiesManager {
  String get getTitle => getValue<String, ButtonTitleInputField>();
}
