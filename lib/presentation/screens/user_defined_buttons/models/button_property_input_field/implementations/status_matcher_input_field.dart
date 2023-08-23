import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_properties_manager.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_check/button_property_validators.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/button_property_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/properties_map.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/data_matchers_input_fileds_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/status_matcher_input_fields_widget.dart';
import 'package:re_seedwork/re_seedwork.dart';

class StatusMatcherInputField
    extends ButtonPropertyInputField<StringMatcherProrpertiesMap> {
  StatusMatcherInputField({
    List<ButtonPropertyValidator<StringMatcherProrpertiesMap?>> validators =
        const [],
    int initialMatchersCount = 0,
  }) : super(
          widgetBuilder: (context, manager) {
            manager.addObjectInitializer<StringMatcherProrpertiesMap>(
              () => StringMatcherProrpertiesMap({}),
            );

            return StatusMatcherInputFieldsWidget(
              manager: manager,
              validators: validators,
              initialMatchersCount: initialMatchersCount,
              title: context.l10n.statusFieldTitle,
            );
          },
        );
}

extension GetStatusMatcher on ButtonPropertiesManager {
  StringMatcher? get statusMatcher {
    final map = {
      ...?getOptional<StringMatcherProrpertiesMap, StatusMatcherInputField>()
    };
    final elseResult = map.remove(0);
    if (map.isEmpty) return null;

    final ifMatchers = map.values.map(
      (e) {
        return ComparisonOperationMatcher<String>(
          operation: e.getValue<ComparisonOperation,
              ComparisonOperationPropertyEntry>(),
          value: e
              .getValue<int?, OptionalIntPropertyEntry>()
              .checkNotNull('value'),
          result: e.getValue<String, StringPropertyEntry>(),
          parameters: e.getValue<PackageDataParameters,
              PackageDataParametersPropertyEntry>(),
        );
      },
    ).toList();

    if (ifMatchers.isEmpty) return null;

    return StringMatcher(
      ifMatchers: ifMatchers,
      elseResult: elseResult
          .checkNotNull('elseResult')
          .getValue<String, StringPropertyEntry>(),
    );
  }
}
