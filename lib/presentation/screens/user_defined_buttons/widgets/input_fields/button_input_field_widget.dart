import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_check/button_property_validators.dart';

class ButtonInputFieldWidget<T> extends StatefulWidget {
  const ButtonInputFieldWidget({
    super.key,
    required this.title,
    required this.onChanged,
    required this.mapper,
    this.formatIntToHex = true,
    this.isRequired = true,
    this.postMapValidators,
    this.preMapValidators,
    this.enabled = true,
    this.helperText,
    this.hintText,
    this.keyboardType,
    this.suffix,
    this.controller,
    this.border,
    this.isDense,
    this.contentPadding,
    this.initialValue,
  });

  @protected
  final String title;

  @protected
  final void Function(T value) onChanged;

  @protected
  final T Function(String value) mapper;

  @protected
  final bool enabled;

  @protected
  final String? helperText;

  @protected
  final String? hintText;

  @protected
  final bool isRequired;

  @protected
  final Widget? suffix;

  @protected
  final TextInputType? keyboardType;

  @protected
  final TextEditingController? controller;

  @protected
  final List<ButtonPropertyValidator<String>> Function(BuildContext context)?
      preMapValidators;

  @protected
  final List<ButtonPropertyValidator<T>> Function(BuildContext context)?
      postMapValidators;

  @protected
  final bool? isDense;

  @protected
  final EdgeInsets? contentPadding;

  @protected
  final InputBorder? border;

  @protected
  final String? initialValue;

  @protected
  final bool formatIntToHex;

  @override
  State<ButtonInputFieldWidget<T>> createState() =>
      _ButtonInputFieldWidgetState<T>();
}

class _ButtonInputFieldWidgetState<T> extends State<ButtonInputFieldWidget<T>> {
  late final TextEditingController controller;

  Type getType<R>() => R;

  @override
  void initState() {
    super.initState();
    String? initialValue = widget.initialValue ?? '';

    if (initialValue.isNotEmpty && widget.formatIntToHex) {
      if (T == getType<int?>()) {
        final integer = int.tryParse(initialValue);
        if (integer != null) initialValue = '0x${integer.toRadixString(16)}';
      } else if (T == getType<List<int>?>()) {
        final parsed = initialValue.parseListOfInts();
        if ((parsed?.isNotEmpty ?? false) &&
            !initialValue.hasUnparsedSegments) {
          initialValue =
              parsed?.map((e) => '0x${e.toRadixString(16)}').join(', ');
        }
      }
    }

    controller = widget.controller ?? TextEditingController(text: initialValue);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onChanged(widget.mapper(widget.initialValue ?? ''));
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        final preValidators = <ButtonPropertyValidator<String?>>[
          if (widget.isRequired) context.notEmptyValidator(),
          ...?widget.preMapValidators?.call(context),
        ];
        for (final validator in preValidators) {
          final error = validator.validate(value);
          if (error != null) return error;
        }
        final mapped = widget.mapper(value ?? '');
        for (final validator in widget.postMapValidators?.call(context) ??
            <ButtonPropertyValidator<T>>[]) {
          final error = validator.validate(mapped);
          if (error != null) return error;
        }
        return null;
      },
      enabled: widget.enabled,
      decoration: InputDecoration(
        label: Text(widget.isRequired ? '${widget.title}*' : widget.title),
        hintText: widget.hintText,
        enabledBorder: widget.border?.copyWith(
          borderSide: BorderSide(color: context.colors.border),
        ),
        errorBorder: widget.border?.copyWith(
          borderSide: BorderSide(color: context.colors.error),
        ),
        focusedErrorBorder: widget.border?.copyWith(
          borderSide: BorderSide(color: context.colors.error),
        ),
        border: widget.border,
        focusedBorder: widget.border?.copyWith(
          borderSide: BorderSide(color: context.colors.primary),
        ),
        disabledBorder: widget.border?.copyWith(
          borderSide: BorderSide(color: context.colors.disabled),
        ),
        isDense: widget.isDense,
        contentPadding: widget.contentPadding,
        helperText: widget.enabled ? widget.helperText : null,
        helperMaxLines: 2,
        errorMaxLines: 5,
        suffix: widget.suffix,
      ),
      keyboardType: widget.keyboardType,
      onChanged: (value) => widget.onChanged(widget.mapper(value)),
    );
  }
}
