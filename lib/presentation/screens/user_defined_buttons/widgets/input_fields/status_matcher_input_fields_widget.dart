import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/status_matcher_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/properties_map.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/button_input_field_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/data_matchers_input_fileds_widget.dart';

class StatusMatcherInputFieldsWidget extends DataMatchersInputFormFieldsWidget<
    String, StringMatcherProrpertiesMap, StatusMatcherInputField> {
  StatusMatcherInputFieldsWidget({
    super.key,
    required super.manager,
    required super.validators,
    required super.title,
    super.initialMatchersCount = 0,
    super.initialIfMatchersValues,
    super.initialElseValue,
  }) : super(
          matcherField: (context, id, intialValue) {
            final _initialValue =
                intialValue ?? (id == 0 ? context.l10n.unknownMessage : '');

            return IntrinsicWidth(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
                child: ButtonInputFieldWidget<String>(
                  title: context.l10n.titleFieldTitle,
                  initialValue: _initialValue,
                  border: const OutlineInputBorder(),
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  onChanged: (value) {
                    manager.updateValue<StringMatcherProrpertiesMap,
                        StatusMatcherInputField>((currentValue) {
                      return (currentValue ?? StringMatcherProrpertiesMap({}))
                          .updateItem(id, (current) {
                        return (current ?? SerializablePropertiesMap({}))
                            .addProperty(StringPropertyEntry(value));
                      });
                    });
                  },
                  mapper: (value) => value,
                ),
              ),
            );
          },
        );
}

class StringMatcherProrpertiesMap
    extends PropertiesMap<SerializablePropertiesMap> {
  StringMatcherProrpertiesMap(super.map);

  @override
  Y builder<Y extends PropertiesMap<SerializablePropertiesMap>>(
    Map<int, SerializablePropertiesMap> items,
  ) {
    return StringMatcherProrpertiesMap(items) as Y;
  }
}
