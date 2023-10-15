import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_properties_manager.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_check/button_property_validators.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/num_value_getter_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/properties_map.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/button_input_field_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/data_matchers_input_fileds_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/field_group_wrapper.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/num_value_getter_switcher_input_field_widget.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/molecules/responsive_grid_view.dart';

class NumValueGetterInputFormFieldWidget
    extends FormField<NumValueGetterParameters> {
  NumValueGetterInputFormFieldWidget({
    super.key,
    NumValueGetterParameters? initialParameters,
    required ButtonPropertiesManager manager,
    required String? Function(NumValueGetterParameters? params) validator,
  }) : super(
          validator: validator,
          builder: (field) {
            manager.addChangeListener<SerializablePropertiesMap,
                NumValueGetterInputField>(() {
              field.didChange(
                manager.numValueGetterHasPackageDataParams
                    ? manager.numValueGetterParameters
                    : null,
              );
            });

            return NumValueGetterInputFieldWidget(
              manager: manager,
              initialParameters: initialParameters,
              error: field.errorText,
            );
          },
        );
}

class NumValueGetterInputFieldWidget extends StatefulWidget {
  const NumValueGetterInputFieldWidget({
    super.key,
    this.initialParameters,
    required this.manager,
    this.error,
  });

  @protected
  final ButtonPropertiesManager manager;

  @protected
  final NumValueGetterParameters? initialParameters;

  @protected
  final String? error;

  @override
  State<NumValueGetterInputFieldWidget> createState() =>
      _NumValueGetterInputFieldWidgetState();
}

class _NumValueGetterInputFieldWidgetState
    extends State<NumValueGetterInputFieldWidget> {
  late final ValueNotifier<bool> enabledNotifier;
  late final ValueNotifier<bool> multiplierNotifier;

  @override
  void initState() {
    enabledNotifier = ValueNotifier(widget.initialParameters != null);
    multiplierNotifier =
        ValueNotifier(widget.initialParameters?.multiplier != null);

    super.initState();
  }

  @override
  void dispose() {
    enabledNotifier.dispose();
    multiplierNotifier.dispose();
    super.dispose();
  }

  void addProperty(PropertyEntry<dynamic> propertyEntry) {
    widget.manager
        .updateValue<SerializablePropertiesMap, NumValueGetterInputField>(
            (currentValue) {
      return (currentValue ?? SerializablePropertiesMap({}))
          .addProperty(propertyEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FieldGroupWrapper(
      title: context.l10n.valueFieldTitle,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      error: widget.error,
      children: [
        SizedBox(
          width: double.infinity,
          child: ValueListenableBuilder<bool>(
            valueListenable: enabledNotifier,
            builder: (context, value, child) {
              return NumValueGetterSwitcherInputFieldWidget(
                groupValue: value,
                onValueChanged: (value) {
                  enabledNotifier.value = value;
                  addProperty(BoolPropertyEntry(value));
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<bool>(
          valueListenable: enabledNotifier,
          builder: (context, value, child) {
            return AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: !value
                  ? const SizedBox.shrink()
                  : ResponsiveGridView(
                      minWidth: 200,
                      maxWidth: 400,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        PackageDataParametersInputFieldWidget(
                          onChanged: (value) {
                            addProperty(
                              PackageDataParametersPropertyEntry(value),
                            );
                          },
                          title: context.l10n.dataStatement,
                          initialValue: widget.initialParameters?.parameters,
                        ),
                        ButtonInputFieldWidget<String?>(
                          title: context.l10n.suffixFieldTitle,
                          isRequired: false,
                          onChanged: (value) {
                            addProperty(OptionalStringPropertyEntry(value));
                          },
                          mapper: (value) => value,
                          initialValue: widget.initialParameters?.suffix,
                        ),
                        ButtonInputFieldWidget<double?>(
                          title: context.l10n.multiplierFieldTitle,
                          isRequired: false,
                          onChanged: (value) {
                            multiplierNotifier.value = value != null;
                            addProperty(MultiplierPropertyEntry(value));
                          },
                          mapper: double.tryParse,
                          initialValue:
                              widget.initialParameters?.multiplier?.toString(),
                          preMapValidators: (context) {
                            return [
                              context.doubleOrNullStringValidator(),
                            ];
                          },
                          keyboardType: TextInputType.number,
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: multiplierNotifier,
                          builder: (context, value, child) {
                            return AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              child: value
                                  ? ButtonInputFieldWidget<int?>(
                                      title:
                                          context.l10n.fractionDigitsFieldTitle,
                                      isRequired: false,
                                      formatIntToUint8: false,
                                      onChanged: (value) {
                                        addProperty(
                                          FractionsDigitsPropertyEntry(value),
                                        );
                                      },
                                      mapper: int.tryParse,
                                      initialValue: widget
                                          .initialParameters?.fractionDigits
                                          ?.toString(),
                                      preMapValidators: (context) {
                                        return [
                                          context.intOrNullStringValidator(),
                                        ];
                                      },
                                      keyboardType: TextInputType.number,
                                    )
                                  : const SizedBox.shrink(),
                            );
                          },
                        ),
                      ],
                    ),
            );
          },
        ),
      ],
    );
  }
}

class MultiplierPropertyEntry extends PropertyEntry<double?> {
  const MultiplierPropertyEntry(super.value);
}

class FractionsDigitsPropertyEntry extends OptionalIntPropertyEntry {
  const FractionsDigitsPropertyEntry(super.value);
}

class PackageDataParametersInputFieldWidget extends StatefulWidget {
  const PackageDataParametersInputFieldWidget({
    super.key,
    required this.onChanged,
    required this.title,
    this.initialValue,
  });

  @protected
  final ValueSetter<PackageDataParameters> onChanged;

  @protected
  final PackageDataParameters? initialValue;

  @protected
  final String title;

  @override
  State<PackageDataParametersInputFieldWidget> createState() =>
      _PackageDataParametersInputFieldWidgetState();
}

class _PackageDataParametersInputFieldWidgetState
    extends State<PackageDataParametersInputFieldWidget> {
  late final TextEditingController controller;
  late PackageDataParameters parameters;

  @override
  void initState() {
    super.initState();
    parameters = widget.initialValue ?? const PackageDataParameters.initial();
    controller = TextEditingController(text: getTitle(parameters.range));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onChanged(parameters);
    });
  }

  String getTitle(DataBytesRange range) {
    return '${widget.title}${getRangeSuffix(range)}';
  }

  static String getRangeSuffix(DataBytesRange range) {
    return range.when(
      all: (_) => '',
      manual: (range) {
        if (range.end - range.start == 1) {
          return '[${range.start}]';
        }
        return '[${range.start}-${range.end}]';
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @protected
  static const kDataParamsTextStyle = TextStyle(
    height: 1.2,
    fontSize: 10,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final newParams = await showDialog<PackageDataParameters>(
          context: context,
          builder: (context) {
            return SelectDataParametersDialog(
              initialValue: parameters,
            );
          },
        );
        if (newParams == null) return;
        parameters = newParams;
        controller.text = getTitle(parameters.range);
        widget.onChanged(newParams);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IgnorePointer(
            child: ButtonInputFieldWidget<PackageDataParameters?>(
              controller: controller,
              mapper: (value) => null,
              title: widget.title,
              border: const OutlineInputBorder(),
              onChanged: (value) {},
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parameters.sign.when(
                        signed: () => context.l10n.signedByteLabel,
                        unsigned: () => context.l10n.unsignedByteLabel,
                      ),
                      style: kDataParamsTextStyle.copyWith(
                        color: context.colors.hintText,
                      ),
                    ),
                    if (parameters.range.endianMatters)
                      Text(
                        parameters.endian.when(
                          big: () => context.l10n.bigEndianStatement,
                          little: () => context.l10n.littleEndianStatement,
                        ),
                        style: kDataParamsTextStyle.copyWith(
                          color: context.colors.hintText,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
