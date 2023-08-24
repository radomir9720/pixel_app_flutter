import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_check/button_property_validators.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/color_matcher_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/properties_map.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/button_input_field_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/data_matchers_input_fileds_widget.dart';

class ColorMatcherInputFieldsWidget extends DataMatchersInputFormFieldsWidget<
    Color, ColorMatcherProrpertiesMap, ColorMatcherInputField> {
  ColorMatcherInputFieldsWidget({
    super.key,
    required super.manager,
    required super.validators,
    super.initialMatchersCount = 0,
    required super.title,
    super.initialIfMatchersValues,
    super.initialElseValue,
  }) : super(
          matcherField: (context, id, initialValue) => IntrinsicWidth(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 100),
              child: ColorSelectorFormField(
                initialColor: initialValue ?? (id == 0 ? Colors.grey : null),
                onColorChanged: (value) {
                  manager.updateValue<ColorMatcherProrpertiesMap,
                      ColorMatcherInputField>((currentValue) {
                    return (currentValue ?? ColorMatcherProrpertiesMap({}))
                        .updateItem(id, (current) {
                      return (current ?? SerializablePropertiesMap({}))
                          .addProperty(ColorPropertyEntry(value));
                    });
                  });
                },
              ),
            ),
          ),
        );
}

class ColorMatcherProrpertiesMap
    extends PropertiesMap<SerializablePropertiesMap> {
  ColorMatcherProrpertiesMap(super.map);

  @override
  Y builder<Y extends PropertiesMap<SerializablePropertiesMap>>(
    Map<int, SerializablePropertiesMap> items,
  ) {
    return ColorMatcherProrpertiesMap(items) as Y;
  }
}

class ColorSelectorFormField extends StatefulWidget {
  const ColorSelectorFormField({
    super.key,
    required this.onColorChanged,
    this.initialColor,
  });

  @protected
  final ValueSetter<Color> onColorChanged;

  @protected
  final Color? initialColor;

  @override
  State<ColorSelectorFormField> createState() => _ColorSelectorFormFieldState();
}

class _ColorSelectorFormFieldState extends State<ColorSelectorFormField> {
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    final initialColor = widget.initialColor;
    controller = TextEditingController(text: initialColor?.hexAlpha);
    if (initialColor != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.onColorChanged(initialColor);
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Color? color =
            controller.text.isEmpty ? Colors.blue : controller.text.toColor;
        final selected = await ColorPicker(
          onColorChanged: (c) {
            color = c;
          },
          pickersEnabled: const {ColorPickerType.wheel: true},
          pickerTypeLabels: {
            ColorPickerType.primary: context.l10n.primaryColorsPickerTypeLabel,
            ColorPickerType.accent: context.l10n.accentColorsPickerTypeLabel,
            ColorPickerType.wheel: context.l10n.wheelColorsPickerTypeLabel,
          },
          color: color,
        ).showPickerDialog(context);
        final _color = color;
        if (_color == null) return;
        if (selected) {
          if (controller.text == _color.hexAlpha) return;
          widget.onColorChanged(_color);
          controller.text = _color.hexAlpha;
        }
      },
      child: IgnorePointer(
        child: ButtonInputFieldWidget<String?>(
          controller: controller,
          mapper: (value) => value,
          title: context.l10n.colorFieldTitle,
          border: const OutlineInputBorder(),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 4,
          ),
          onChanged: (value) {},
          postMapValidators: (context) {
            return [context.notNullValidator()];
          },
          suffix: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              return ColorIndicator(
                color: value.text.toColor,
                width: 10,
                height: 10,
              );
            },
          ),
        ),
      ),
    );
  }
}
