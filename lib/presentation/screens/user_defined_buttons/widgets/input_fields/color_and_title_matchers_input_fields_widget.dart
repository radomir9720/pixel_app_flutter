import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_properties_manager.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_check/button_property_validators.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/color_matcher_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/status_matcher_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/properties_map.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/color_matcher_input_fields_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/status_matcher_input_fields_widget.dart';

class ColorAndStatusMatchersInputFieldsWidget extends StatelessWidget {
  const ColorAndStatusMatchersInputFieldsWidget({
    super.key,
    required this.manager,
    this.initialColorMatcher,
    this.initialStatusMatcher,
  });

  @protected
  final ButtonPropertiesManager manager;

  @protected
  final ColorMatcher? initialColorMatcher;

  @protected
  final StringMatcher? initialStatusMatcher;

  String? validate(
    BuildContext context, [
    ColorMatcherProrpertiesMap? colorMatcher,
    StringMatcherProrpertiesMap? titleMatcher,
  ]) {
    final _colorMatcher = {
      ...?colorMatcher ??
          manager
              .getOptional<ColorMatcherProrpertiesMap, ColorMatcherInputField>()
    }..remove(0);
    final _titleMatcher = {
      ...?titleMatcher ??
          manager.getOptional<StringMatcherProrpertiesMap,
              StatusMatcherInputField>()
    }..remove(0);
    if ({..._colorMatcher, ..._titleMatcher}.isEmpty) {
      return context.l10n.noColorAndStatusIfStatementsHintError;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColorMatcherInputFieldsWidget(
          manager: manager,
          validators: [
            ButtonPropertyValidatorWrapper((data) => validate(context, data)),
          ],
          initialIfMatchersValues: [
            for (final e in initialColorMatcher?.ifMatchers ??
                <ComparisonOperationMatcher<Color>>[])
              (
                e.parameters,
                e.operation,
                ColorPropertyEntry(e.result),
                e.value.toString()
              )
          ],
          initialElseValue: initialColorMatcher?.elseResult,
          title: context.l10n.colorFieldTitle,
        ),
        const SizedBox(height: 16),
        StatusMatcherInputFieldsWidget(
          manager: manager,
          title: context.l10n.statusFieldTitle,
          initialElseValue: initialStatusMatcher?.elseResult,
          initialIfMatchersValues: [
            for (final e in initialStatusMatcher?.ifMatchers ??
                <ComparisonOperationMatcher<String>>[])
              (
                e.parameters,
                e.operation,
                StringPropertyEntry(e.result),
                e.value.toString()
              )
          ],
          validators: [
            ButtonPropertyValidatorWrapper(
              (data) => validate(context, null, data),
            ),
          ],
        ),
      ],
    );
  }
}
