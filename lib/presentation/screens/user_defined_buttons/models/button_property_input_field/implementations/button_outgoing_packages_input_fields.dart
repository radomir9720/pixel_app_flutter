import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_properties_manager.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_check/button_property_validators.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/button_property_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/button_outgoing_packages_input_fields_widget.dart';

class ButtonOutgoingPackagesInputFields
    extends ButtonPropertyInputField<OutgoingPackagesMap> {
  ButtonOutgoingPackagesInputFields({
    required super.widgetBuilder,
    this.initialPackages,
  });

  final List<OutgoingPackageParameters>? initialPackages;
}

class AxisUpdateOutgoingPackagesInputFields
    extends ButtonOutgoingPackagesInputFields {
  AxisUpdateOutgoingPackagesInputFields({
    super.initialPackages,
  }) : super(
          widgetBuilder: (context, manager) {
            return ButtonOutgoingPackagesFormInputFieldsWidget<
                AxisUpdateOutgoingPackagesInputFields>(
              manager: manager,
              title: context.l10n.sentPackagesWhenMovingJoystickFieldTitle,
              initialPackagesCount: 1,
              validators: [context.minPropertyEntriesValidator(1)],
              initialPackages: initialPackages,
            );
          },
        );
}

class TapOutgoingPackagesInputFields extends ButtonOutgoingPackagesInputFields {
  TapOutgoingPackagesInputFields({
    int initialPackagesCount = 0,
    List<ButtonPropertyValidator<OutgoingPackagesMap>> validators = const [],
    super.initialPackages,
  }) : super(
          widgetBuilder: (context, manager) {
            return ButtonOutgoingPackagesFormInputFieldsWidget<
                TapOutgoingPackagesInputFields>(
              manager: manager,
              title: context.l10n.sentPackagesWithAOneTimePressFieldTitle,
              initialPackagesCount: initialPackagesCount,
              validators: validators,
              initialPackages: initialPackages,
            );
          },
        );
}

extension GetInteractionPropertiesExtension on ButtonPropertiesManager {
  List<OutgoingPackageParameters> get getOnAxisMove =>
      getValue<OutgoingPackagesMap, AxisUpdateOutgoingPackagesInputFields>()
          .toList();
  List<OutgoingPackageParameters> get getOnTap =>
      getOptional<OutgoingPackagesMap, TapOutgoingPackagesInputFields>()
          ?.toList() ??
      [];
}
