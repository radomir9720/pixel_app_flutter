import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_properties_manager.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_check/button_property_validators.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/button_outgoing_packages_input_fields.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/package_data_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/parameter_id_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/request_type_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/properties_map.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/buttons/field_group_wrapper.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/buttons/tile_manager_wrapper.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/molecules/responsive_grid_view.dart';
import 'package:re_seedwork/re_seedwork.dart';

class ButtonOutgoingPackagesFormInputFieldsWidget<
        T extends ButtonOutgoingPackagesInputFields>
    extends FormField<OutgoingPackagesMap> {
  ButtonOutgoingPackagesFormInputFieldsWidget({
    super.key,
    bool dataIsAutofilled = false,
    required ButtonPropertiesManager manager,
    required String title,
    int initialPackagesCount = 0,
    required List<ButtonPropertyValidator<OutgoingPackagesMap>> validators,
    List<OutgoingPackageParameters>? initialPackages,
  }) : super(
          validator: (data) {
            for (final validator in validators) {
              final error = validator.validate(data);
              if (error != null) return error;
            }
            return null;
          },
          builder: (field) {
            manager.addChangeListener<OutgoingPackagesMap, T>(() {
              field.didChange(
                manager.getOptional<OutgoingPackagesMap, T>(),
              );
            });

            return ButtonOutgoingPackagesInputFieldsWidget<T>(
              manager: manager,
              title: title,
              dataIsAutofilled: dataIsAutofilled,
              error: field.errorText,
              initialCount: initialPackagesCount,
              initialPackages: initialPackages,
            );
          },
        );
}

class ButtonOutgoingPackagesInputFieldsWidget<
    T extends ButtonOutgoingPackagesInputFields> extends StatelessWidget {
  const ButtonOutgoingPackagesInputFieldsWidget({
    super.key,
    this.dataIsAutofilled = false,
    required this.manager,
    required this.title,
    required this.error,
    this.initialCount = 0,
    this.initialPackages,
  });

  @protected
  final bool dataIsAutofilled;

  @protected
  final ButtonPropertiesManager manager;

  @protected
  final String title;

  @protected
  final String? error;

  @protected
  final int initialCount;

  @protected
  final List<OutgoingPackageParameters>? initialPackages;

  void deleteCallback(void Function(int id) deleteCallback, int id) {
    manager.updateValue<OutgoingPackagesMap, T>((currentValue) {
      return currentValue?.removeEntry(id) ?? OutgoingPackagesMap({});
    });
    deleteCallback(id);
  }

  @override
  Widget build(BuildContext context) {
    return FieldGroupWrapper(
      title: title,
      error: error,
      children: [
        TilesManagerWrapper(
          initialTilesBuilder: (deleteCallback) {
            return List.generate(
              initialPackages?.length ?? 0,
              (index) {
                final item = (initialPackages ?? [])[index];
                final id = DateTime.now().millisecondsSinceEpoch + index;
                return _Tile<T>(
                  dataIsAutofilled: dataIsAutofilled,
                  manager: manager,
                  deleteCallback: () => this.deleteCallback(deleteCallback, id),
                  id: id,
                  dataInitialValue:
                      item.data.map((e) => e.toString()).join(','),
                  parameterIdInitialValue: item.parameterId.toString(),
                  requestTypeInitialValue: item.requestType.toString(),
                );
              },
            );
          },
          tileBuilder: (i, deleteCallback) {
            final id = DateTime.now().millisecondsSinceEpoch + i;

            return _Tile<T>(
              dataIsAutofilled: dataIsAutofilled,
              manager: manager,
              deleteCallback: () => this.deleteCallback(deleteCallback, id),
              id: id,
            );
          },
          initialCount: initialCount,
          bottom: (generateNewTile, itemsCount) {
            return SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FilledButton.icon(
                  onPressed: generateNewTile,
                  icon: const Icon(Icons.add),
                  label: Text(context.l10n.addAPackageButtonCaption),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Tile<T extends ButtonOutgoingPackagesInputFields> extends StatelessWidget
    implements TileWidget {
  const _Tile({
    super.key,
    required this.dataIsAutofilled,
    required this.manager,
    required this.deleteCallback,
    required this.id,
    this.dataInitialValue,
    this.parameterIdInitialValue,
    this.requestTypeInitialValue,
  });

  @override
  final int id;

  @protected
  final bool dataIsAutofilled;

  @protected
  final ButtonPropertiesManager manager;

  @protected
  final VoidCallback deleteCallback;

  @protected
  final String? requestTypeInitialValue;

  @protected
  final String? parameterIdInitialValue;

  @protected
  final String? dataInitialValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ResponsiveGridView(
              minWidth: 200,
              maxWidth: 400,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: <Widget>[
                RequestTypeInputField(
                  title: context.l10n.requestTypeListTileLabel,
                  initialValue: requestTypeInitialValue,
                  onChanged: (value) {
                    manager.updateValue<OutgoingPackagesMap, T>(
                      (currentValue) {
                        return (currentValue ?? OutgoingPackagesMap({}))
                            .updateRequestType(
                          id: id,
                          requestType: value,
                        );
                      },
                    );
                  },
                ),
                ParameterIdInputField(
                  title: context.l10n.parameterIdListTileLabel,
                  initialValue: parameterIdInitialValue,
                  onChanged: (value) {
                    manager.updateValue<OutgoingPackagesMap, T>(
                      (currentValue) {
                        return (currentValue ?? OutgoingPackagesMap({}))
                            .updateParameterId(
                          id: id,
                          parameterId: value,
                        );
                      },
                    );
                  },
                ),
                PackageDataInputField(
                  title: dataIsAutofilled
                      ? context.l10n.theDataIsAutofilledFieldLabel
                      : context.l10n.packageDataFieldLabel,
                  isRequired: false,
                  hintText: context.l10n.packageDataHint,
                  enabled: !dataIsAutofilled,
                  initialValue: dataInitialValue,
                  onChanged: (value) {
                    manager.updateValue<OutgoingPackagesMap, T>(
                      (currentValue) {
                        return (currentValue ?? OutgoingPackagesMap({}))
                            .updateData(
                          id: id,
                          data: value,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: deleteCallback,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

typedef OutgoingPackagesParamsRecord = (int?, int?, List<int>?);

class OutgoingPackagesMap extends PropertiesMap<OutgoingPackagesParamsRecord> {
  OutgoingPackagesMap(super.source);

  List<OutgoingPackageParameters> toList() => values.map(
        (e) {
          return OutgoingPackageParameters(
            requestType: e.$1.checkNotNull('RequestType'),
            parameterId: e.$2.checkNotNull('ParameterId'),
            data: e.$3 ?? [],
          );
        },
      ).toList();

  OutgoingPackagesMap updateParameterId({
    required int id,
    required int? parameterId,
  }) {
    return updateItem(id, (current) {
      return (current?.$1, parameterId, current?.$3);
    });
  }

  OutgoingPackagesMap updateRequestType({
    required int id,
    required int? requestType,
  }) {
    return updateItem(id, (current) {
      return (requestType, current?.$2, current?.$3);
    });
  }

  OutgoingPackagesMap updateData({
    required int id,
    required List<int>? data,
  }) {
    return updateItem(id, (current) {
      return (current?.$1, current?.$2, data);
    });
  }

  @override
  Y builder<Y extends PropertiesMap<OutgoingPackagesParamsRecord>>(
    Map<int, OutgoingPackagesParamsRecord> items,
  ) {
    return OutgoingPackagesMap(items) as Y;
  }
}
