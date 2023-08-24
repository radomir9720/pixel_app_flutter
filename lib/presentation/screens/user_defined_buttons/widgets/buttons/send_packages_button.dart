import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_builder.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_check/button_property_validators.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/button_outgoing_packages_input_fields.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/button_title_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/buttons/button_decoration_wrapper.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/button_outgoing_packages_input_fields_widget.dart';

class SendPackagesButton extends StatelessWidget {
  const SendPackagesButton(this.button, {super.key});

  @protected
  final SendPackagesUserDefinedButton button;

  static ButtonBuilder<SendPackagesUserDefinedButton> builder(
    BuildContext context, [
    SendPackagesUserDefinedButton? initialValue,
  ]) {
    return ButtonBuilder(
      fields: [
        ButtonTitleInputField(initialValue: initialValue?.title),
        TapOutgoingPackagesInputFields(
          initialPackagesCount: 1,
          validators: [
            context.minPropertyEntriesValidator<OutgoingPackagesMap>(1)
          ],
          initialPackages: initialValue?.onTap,
        ),
      ],
      builder: (manager, id) {
        return SendPackagesUserDefinedButton(
          id: id,
          title: manager.getTitle,
          onTap: manager.getOnTap,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: ButtonDecorationWrapper.kBorderRadius,
      onTap: () {
        for (final package in button.onTap) {
          context.read<OutgoingPackagesCubit>().sendPackage(
                DataSourceOutgoingPackage.raw(
                  requestType: package.requestType,
                  parameterId: package.parameterId,
                  data: package.data,
                ),
              );
        }
      },
      child: ButtonDecorationWrapper(
        button: button,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              button.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
