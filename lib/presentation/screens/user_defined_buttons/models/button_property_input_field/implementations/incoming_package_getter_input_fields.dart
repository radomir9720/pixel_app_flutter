import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_properties_manager.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/button_property_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/incoming_package_getter_input_fields_widget.dart';
import 'package:re_seedwork/re_seedwork.dart';

class IncomingPackageGetterInputFields
    extends ButtonPropertyInputField<IncomingPackageGetterModel> {
  IncomingPackageGetterInputFields({
    IncomingPackageGetter? initialValues,
  }) : super(
          widgetBuilder: (context, manager) {
            return IncomingPackageGetterInputFieldsWidget(
              manager: manager,
              initialValues: initialValues,
            );
          },
        );
}

extension GetIncomingPackageGetterExtension on ButtonPropertiesManager {
  IncomingPackageGetter get incomingPackageGetter {
    final model = getValue<IncomingPackageGetterModel,
        IncomingPackageGetterInputFields>();

    return IncomingPackageGetter(
      requestType: model.requestType.checkNotNull('RequestType'),
      parameterId: model.parameterId.checkNotNull('ParameterID'),
      functionId: model.functionId,
    );
  }
}
