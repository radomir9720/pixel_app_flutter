import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_properties_manager.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/button_property_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/properties_map.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/data_matchers_input_fileds_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/num_value_getter_input_filed_widget.dart';

class NumValueGetterInputField
    extends ButtonPropertyInputField<SerializablePropertiesMap> {
  NumValueGetterInputField({
    required NumValueGetterParameters? initialParameters,
  }) : super(
          widgetBuilder: (context, manager) {
            return NumValueGetterInputFieldWidget(
              manager: manager,
              initialParameters: initialParameters,
            );
          },
        );
}

extension GetNumValueGetterParametersExtension on ButtonPropertiesManager {
  bool get numValueGetterHasPackageDataParams {
    final serializableMap =
        getValue<SerializablePropertiesMap, NumValueGetterInputField>();
    return serializableMap.getOptionalValue<PackageDataParameters,
            PackageDataParametersPropertyEntry>() !=
        null;
  }

  NumValueGetterParameters? get numValueGetterParameters {
    final serializableMap =
        getValue<SerializablePropertiesMap, NumValueGetterInputField>();
    final enabled = serializableMap.getValue<bool, BoolPropertyEntry>();
    if (!enabled) return null;
    return NumValueGetterParameters(
      parameters: serializableMap.getValue<PackageDataParameters,
          PackageDataParametersPropertyEntry>(),
      fractionDigits: serializableMap
          .getOptionalValue<int?, FractionsDigitsPropertyEntry>(),
      multiplier:
          serializableMap.getOptionalValue<double?, MultiplierPropertyEntry>(),
      suffix: serializableMap
          .getOptionalValue<String?, OptionalStringPropertyEntry>(),
    );
  }
}
