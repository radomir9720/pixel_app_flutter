import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_properties_manager.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/function_id_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/incoming_package_getter_input_fields.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/parameter_id_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/request_type_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/field_group_wrapper.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/molecules/responsive_grid_view.dart';

class IncomingPackageGetterInputFieldsWidget extends StatelessWidget {
  const IncomingPackageGetterInputFieldsWidget({
    super.key,
    required this.manager,
    this.initialValues,
  });

  @protected
  final ButtonPropertiesManager manager;

  @protected
  final IncomingPackageGetter? initialValues;

  @override
  Widget build(BuildContext context) {
    return FieldGroupWrapper(
      title: context.l10n.inputPackageParametersFieldTitle,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveGridView(
            minWidth: 200,
            maxWidth: 400,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              RequestTypeInputField(
                title: context.l10n.requestTypeListTileLabel,
                onChanged: manager.setRequestType,
                initialValue: initialValues?.requestType.toString(),
              ),
              ParameterIdInputField(
                title: context.l10n.parameterIdListTileLabel,
                onChanged: manager.setParameterId,
                initialValue: initialValues?.parameterId.toString(),
              ),
              FunctionIdInputField(
                title: context.l10n.functionIdFieldTitle,
                onChanged: manager.setFunctionId,
                initialValue: initialValues?.functionId?.toString(),
                isRequired: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

extension IntParseNullable on int {
  static int? tryParseNullable(String? value) {
    return int.tryParse(value ?? '');
  }
}

class IncomingPackageGetterModel {
  IncomingPackageGetterModel({
    this.requestType,
    this.parameterId,
    this.functionId,
  });

  int? requestType;
  int? parameterId;
  int? functionId;
}

extension on ButtonPropertiesManager {
  void setRequestType(int? requestType) {
    updateValue<IncomingPackageGetterModel, IncomingPackageGetterInputFields>(
      (currentValue) {
        return IncomingPackageGetterModel(
          functionId: currentValue?.functionId,
          parameterId: currentValue?.parameterId,
          requestType: requestType,
        );
      },
    );
  }

  void setParameterId(int? parameterId) {
    updateValue<IncomingPackageGetterModel, IncomingPackageGetterInputFields>(
      (currentValue) {
        return IncomingPackageGetterModel(
          functionId: currentValue?.functionId,
          parameterId: parameterId,
          requestType: currentValue?.requestType,
        );
      },
    );
  }

  void setFunctionId(int? functionId) {
    updateValue<IncomingPackageGetterModel, IncomingPackageGetterInputFields>(
      (currentValue) {
        return IncomingPackageGetterModel(
          functionId: functionId,
          parameterId: currentValue?.parameterId,
          requestType: currentValue?.requestType,
        );
      },
    );
  }
}
