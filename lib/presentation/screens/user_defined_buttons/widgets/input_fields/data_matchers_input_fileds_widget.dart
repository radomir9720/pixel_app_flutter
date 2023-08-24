import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_properties_manager.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_check/button_property_validators.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/button_property_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/properties_map.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/buttons/field_group_wrapper.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/buttons/tile_manager_wrapper.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/button_input_field_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/input_fields/incoming_package_getter_input_fields_widget.dart';
import 'package:re_widgets/re_widgets.dart';

typedef MatcherFieldBuilder = Widget Function(BuildContext, int id);

class DataMatchersInputFormFieldsWidget<
    Y extends PropertiesMap<SerializablePropertiesMap>,
    T extends ButtonPropertyInputField<Y>> extends FormField<Y> {
  DataMatchersInputFormFieldsWidget({
    super.key,
    required ButtonPropertiesManager manager,
    required String title,
    required MatcherFieldBuilder matcherField,
    required int initialMatchersCount,
    required List<ButtonPropertyValidator<Y?>> validators,
  }) : super(
          validator: (value) {
            for (final validator in validators) {
              final error = validator.validate(value);
              if (error != null) return error;
            }
            return null;
          },
          builder: (field) {
            manager.addChangeListener<Y, T>(() {
              field.didChange(manager.getOptional<Y, T>());
            });
            return DataMatchersInputFieldsWidget<Y, T>(
              manager: manager,
              title: title,
              matcherField: matcherField,
              error: field.errorText,
              initialMatchersCount: initialMatchersCount,
            );
          },
        );
}

class DataMatchersInputFieldsWidget<
    Y extends PropertiesMap<SerializablePropertiesMap>,
    T extends ButtonPropertyInputField<Y>> extends StatelessWidget {
  const DataMatchersInputFieldsWidget({
    super.key,
    required this.manager,
    required this.matcherField,
    required this.title,
    required this.initialMatchersCount,
    this.error,
  });

  @protected
  final ButtonPropertiesManager manager;

  @protected
  final MatcherFieldBuilder matcherField;

  @protected
  final String title;

  @protected
  final String? error;

  @protected
  final int initialMatchersCount;

  @protected
  static const kTextStyle = TextStyle(
    height: 2,
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    final colors =
        context.extensionColors<DataMatchersColors>('DataMatchersColors');

    return FieldGroupWrapper(
      title: title,
      error: error,
      children: [
        TilesManagerWrapper(
          initialCount: initialMatchersCount,
          tileBuilder: (index, deleteCallback) {
            final id = DateTime.now().millisecondsSinceEpoch;
            return _Tile<Y, T>(
              id: id,
              manager: manager,
              matcherField: matcherField(context, id),
              deleteCallback: () => deleteCallback(id),
            );
          },
          bottom: (generateNewTile, itemsCount) {
            return Column(
              children: [
                if (itemsCount > 0) ...[
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          '${context.l10n.elseStatement} ',
                          style: kTextStyle.copyWith(
                            color: colors.statement,
                          ),
                        ),
                        matcherField(context, 0),
                      ],
                    ),
                  ),
                ],
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: FilledButton.icon(
                      onPressed: generateNewTile,
                      icon: const Icon(Icons.add),
                      label: Text(context.l10n.addIfStatementButtonCaption),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Tile<Y extends PropertiesMap<SerializablePropertiesMap>,
        T extends ButtonPropertyInputField<Y>> extends StatefulWidget
    implements TileWidget {
  const _Tile({
    super.key,
    required this.id,
    required this.deleteCallback,
    required this.manager,
    required this.matcherField,
  });

  @override
  @protected
  final int id;

  @protected
  final VoidCallback deleteCallback;

  @protected
  final ButtonPropertiesManager manager;

  @protected
  final Widget matcherField;

  @override
  State<_Tile<Y, T>> createState() => _TileState<Y, T>();
}

class _TileState<Y extends PropertiesMap<SerializablePropertiesMap>,
    T extends ButtonPropertyInputField<Y>> extends State<_Tile<Y, T>> {
  late PackageDataParameters parameters;
  ComparisonOperation operation = ComparisonOperation.equalsTo;

  @override
  void initState() {
    super.initState();
    final lastPackageParameters = widget.manager
        .getOptional<Y, T>()
        ?.values
        .lastOrNull
        ?.getOptionalValue<PackageDataParameters,
            PackageDataParametersPropertyEntry>();
    parameters = lastPackageParameters ?? const PackageDataParameters.initial();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.manager.updateValue<Y, T>((currentValue) {
        return currentValue?.updateItem(
          widget.id,
          (current) => SerializablePropertiesMap({})
              .addProperty(PackageDataParametersPropertyEntry(parameters))
              .addProperty(ComparisonOperationPropertyEntry(operation)),
        );
      });
    });
  }

  void appendEntry(PropertyEntry<dynamic> entry) {
    widget.manager.updateValue<Y, T>((currentValue) {
      return currentValue?.updateItem(widget.id, (current) {
        return (current ?? SerializablePropertiesMap({})).addProperty(
          entry,
        );
      });
    });
  }

  @protected
  static const kTextStyle = TextStyle(
    height: 2,
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  @protected
  static const kDataParamsTextStyle = TextStyle(
    height: 1.2,
    fontSize: 10,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    final colors =
        context.extensionColors<DataMatchersColors>('DataMatchersColors');
    final statementTextStyle = kTextStyle.copyWith(color: colors.statement);

    return Padding(
      padding: const EdgeInsets.all(16).copyWith(top: 0),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${context.l10n.ifStatement} (',
                    style: statementTextStyle,
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.top,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                final newParams =
                                    await showDialog<PackageDataParameters>(
                                  context: context,
                                  builder: (context) {
                                    return _SelectDataParametersDialog(
                                      initialValue: parameters,
                                    );
                                  },
                                );
                                if (newParams == null) return;
                                appendEntry(
                                  PackageDataParametersPropertyEntry(newParams),
                                );
                                setState(() => parameters = newParams);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${context.l10n.dataStatement}'
                                    '${parameters.range.when(
                                      all: (_) => '',
                                      manual: (range) {
                                        if (range.end - range.start == 1) {
                                          return '[${range.start}]';
                                        }
                                        return '[${range.start}-${range.end}]';
                                      },
                                    )}',
                                    style: kTextStyle.copyWith(
                                      color: colors.accent,
                                      height: 1.25,
                                    ),
                                  ),
                                  Text(
                                    parameters.sign.when(
                                      signed: () =>
                                          context.l10n.signedByteLabel,
                                      unsigned: () =>
                                          context.l10n.unsignedByteLabel,
                                    ),
                                    style: kDataParamsTextStyle.copyWith(
                                      color: context.colors.hintText,
                                    ),
                                  ),
                                  Text(
                                    !parameters.range.endianMatters
                                        ? ''
                                        : parameters.endian.when(
                                            big: () =>
                                                context.l10n.bigEndianStatement,
                                            little: () => context
                                                .l10n.littleEndianStatement,
                                          ),
                                    style: kDataParamsTextStyle.copyWith(
                                      color: context.colors.hintText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const TextSpan(text: ' '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.top,
                    child: _ComparisonOperationWidget(
                      onChange: (operation) {
                        setState(() {
                          this.operation = operation;
                        });
                        appendEntry(
                          ComparisonOperationPropertyEntry(operation),
                        );
                      },
                      value: operation,
                    ),
                  ),
                  const TextSpan(text: ' '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.top,
                    child: IntrinsicWidth(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 100),
                        child: ButtonInputFieldWidget<int?>(
                          title: context.l10n.valueFieldTitle,
                          mapper: IntParseNullable.tryParseNullable,
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 4,
                          ),
                          onChanged: (value) {
                            appendEntry(OptionalIntPropertyEntry(value));
                          },
                          postMapValidators: (context) {
                            return [context.notNullValidator()];
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ),
                  TextSpan(
                    text: ') ',
                    style: statementTextStyle,
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.top,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${context.l10n.thenStatement} ',
                          style: statementTextStyle.copyWith(height: 1.25),
                        ),
                        widget.matcherField,
                      ],
                    ),
                  ),
                ],
                style: kTextStyle.copyWith(color: colors.regular),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              widget.deleteCallback();
              widget.manager.updateValue<Y, T>((currentValue) {
                final a = currentValue?.removeEntry<Y>(widget.id);
                return a;
              });
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

class PackageDataParametersPropertyEntry
    extends PropertyEntry<PackageDataParameters> {
  const PackageDataParametersPropertyEntry(super.value);
}

class ComparisonOperationPropertyEntry
    extends PropertyEntry<ComparisonOperation> {
  const ComparisonOperationPropertyEntry(super.value);
}

class _SelectDataParametersDialog extends StatefulWidget {
  const _SelectDataParametersDialog({
    this.initialValue = const PackageDataParameters.initial(),
  });

  @protected
  final PackageDataParameters initialValue;

  @override
  State<_SelectDataParametersDialog> createState() =>
      _SelectDataParametersDialogState();
}

class _SelectDataParametersDialogState
    extends State<_SelectDataParametersDialog> {
  late PackageDataParameters parameters;

  @override
  void initState() {
    super.initState();
    parameters = widget.initialValue;
  }

  void updateRange(DataBytesRange range) {
    setState(() {
      parameters = parameters.copyWith(
        range: range,
      );
    });
  }

  @protected
  static const kTitleTextStyle = TextStyle(
    height: 1.2,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = kTitleTextStyle.copyWith(color: context.colors.text);

    return AlertDialog(
      title: Text(context.l10n.dataParametersDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.dataRangeCaption,
            style: titleTextStyle,
          ),
          const SizedBox(height: 8),
          Wrap(
            children: [
              IntrinsicWidth(
                child: RadioMenuButton<String>(
                  value: AllDataBytesRange.kKey,
                  groupValue: parameters.range.key,
                  child: Text(context.l10n.allDataRangeLabel),
                  onChanged: (value) {
                    if (value == null) return;
                    updateRange(const AllDataBytesRange());
                  },
                ),
              ),
              IntrinsicWidth(
                child: RadioMenuButton<String>(
                  value: ManualDataBytesRange.kKey,
                  groupValue: parameters.range.key,
                  child: Text(context.l10n.manualSelectionDataRangeLabel),
                  onChanged: (value) {
                    if (value == null) return;
                    updateRange(const ManualDataBytesRange.first());
                  },
                ),
              ),
            ],
          ),
          Center(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: parameters.range.when(
                all: (_) => const SizedBox.shrink(),
                manual: (r) {
                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '${context.l10n.fromDataRangeLabel} '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: _ByteIndexButton(
                            value: r.start,
                            onDecrement: () {
                              updateRange(r.decrementStart);
                            },
                            onIncrement: () {
                              updateRange(r.incrementStart);
                            },
                          ),
                        ),
                        TextSpan(text: '${context.l10n.toDataRangeLabel} '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: _ByteIndexButton(
                            value: r.end,
                            onDecrement: () {
                              updateRange(r.decrementEnd);
                            },
                            onIncrement: () {
                              updateRange(r.incrementEnd);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: double.infinity,
              child: parameters.range.endianMatters
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.endianCaption,
                          style: titleTextStyle,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          children: [
                            IntrinsicWidth(
                              child: RadioMenuButton<Endian>(
                                value: Endian.big,
                                groupValue: parameters.endian,
                                child: Text(context.l10n.bigEndianShortLabel),
                                onChanged: (value) {
                                  setState(() {
                                    parameters = parameters.copyWith(
                                      endian: value,
                                    );
                                  });
                                },
                              ),
                            ),
                            IntrinsicWidth(
                              child: RadioMenuButton<Endian>(
                                value: Endian.little,
                                groupValue: parameters.endian,
                                child:
                                    Text(context.l10n.littleEndianShortLabel),
                                onChanged: (value) {
                                  setState(() {
                                    parameters = parameters.copyWith(
                                      endian: value,
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          Text(
            context.l10n.signCaption,
            style: titleTextStyle,
          ),
          const SizedBox(height: 8),
          Wrap(
            children: [
              IntrinsicWidth(
                child: RadioMenuButton<Sign>(
                  value: Sign.unsigned,
                  groupValue: parameters.sign,
                  onChanged: (value) {
                    setState(() {
                      parameters = parameters.copyWith(
                        sign: value,
                      );
                    });
                  },
                  child: Text(context.l10n.unsignedByteLabel),
                ),
              ),
              IntrinsicWidth(
                child: RadioMenuButton<Sign>(
                  value: Sign.signed,
                  groupValue: parameters.sign,
                  onChanged: (value) {
                    setState(() {
                      parameters = parameters.copyWith(
                        sign: value,
                      );
                    });
                  },
                  child: Text(context.l10n.signedByteLabel),
                ),
              )
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.router.pop<PackageDataParameters>(parameters);
          },
          child: Text(context.l10n.saveButtonCaption),
        ),
      ],
    );
  }
}

class _ByteIndexButton extends StatelessWidget {
  const _ByteIndexButton({
    required this.onIncrement,
    required this.onDecrement,
    required this.value,
  });

  @protected
  final VoidCallback onIncrement;

  @protected
  final VoidCallback onDecrement;

  @protected
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(
            Icons.keyboard_arrow_up_rounded,
          ),
          iconSize: 20,
          splashRadius: 20,
          constraints: const BoxConstraints(),
        ),
        Text('$value'),
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          iconSize: 20,
          splashRadius: 20,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

class _ComparisonOperationWidget extends StatelessWidget {
  const _ComparisonOperationWidget({
    required this.onChange,
    required this.value,
  });

  @protected
  final ValueSetter<ComparisonOperation> onChange;

  @protected
  final ComparisonOperation value;

  @protected
  static const kTextStyle = TextStyle(
    height: 1.2,
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    final colors =
        context.extensionColors<DataMatchersColors>('DataMatchersColors');

    return InkWell(
      onTap: () async {
        final button = context.findRenderObject()! as RenderBox;
        final overlay = Navigator.of(context)
            .overlay!
            .context
            .findRenderObject()! as RenderBox;

        const offset = Offset.zero;

        final position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(offset, ancestor: overlay),
            button.localToGlobal(
              button.size.bottomRight(Offset.zero) + offset,
              ancestor: overlay,
            ),
          ),
          Offset.zero & overlay.size,
        );
        final result = await showMenu<ComparisonOperation>(
          context: context,
          position: position,
          items: ComparisonOperation.values
              .map(
                (e) => PopupMenuItem<ComparisonOperation>(
                  value: e,
                  child: Text(
                    e.toSign(),
                  ),
                ),
              )
              .toList(),
        );
        if (result == null) return;
        onChange(result);
      },
      child: Text(
        value.toSign(),
        style: kTextStyle.copyWith(color: colors.statement),
      ),
    );
  }
}

class DataMatchersColors extends ThemeExtension<DataMatchersColors> {
  const DataMatchersColors({
    required this.accent,
    required this.regular,
    required this.statement,
  });

  final Color accent;
  final Color regular;
  final Color statement;

  @override
  ThemeExtension<DataMatchersColors> copyWith({
    Color? accent,
    Color? regular,
    Color? statement,
  }) {
    return DataMatchersColors(
      accent: accent ?? this.accent,
      regular: regular ?? this.regular,
      statement: statement ?? this.statement,
    );
  }

  @override
  ThemeExtension<DataMatchersColors> lerp(
    covariant ThemeExtension<DataMatchersColors>? other,
    double t,
  ) {
    if (other is! DataMatchersColors) return this;

    return DataMatchersColors(
      accent: Color.lerp(accent, other.accent, t) ?? Colors.transparent,
      regular: Color.lerp(regular, other.regular, t) ?? Colors.transparent,
      statement:
          Color.lerp(statement, other.statement, t) ?? Colors.transparent,
    );
  }
}
