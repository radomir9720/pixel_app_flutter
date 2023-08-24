import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_builder.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/button_title_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/color_and_status_matchers_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/color_matcher_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/incoming_package_getter_input_fields.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/status_matcher_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/buttons/button_decoration_wrapper.dart';

class IndicatorButton extends StatefulWidget {
  const IndicatorButton(this.button, {super.key});

  @protected
  final IndicatorUserDefinedButton button;

  static ButtonBuilder<IndicatorUserDefinedButton> builder([
    IndicatorUserDefinedButton? initialValue,
  ]) {
    return ButtonBuilder(
      fields: [
        ButtonTitleInputField(initialValue: initialValue?.title),
        IncomingPackageGetterInputFields(
          initialValues: initialValue?.incomingPackageGetter,
        ),
        ColorAndStatusMatchersInputFields(
          initialColorMatcher: initialValue?.colorMatcher,
          initialStatusMatcher: initialValue?.statusMatcher,
        ),
      ],
      builder: (manager, id) {
        return IndicatorUserDefinedButton(
          id: id,
          title: manager.getTitle,
          incomingPackageGetter: manager.incomingPackageGetter,
          colorMatcher: manager.colorMatcher,
          statusMatcher: manager.statusMatcher,
        );
      },
    );
  }

  @override
  State<IndicatorButton> createState() => _IndicatorButtonState();
}

class _IndicatorButtonState extends State<IndicatorButton> {
  Set<DataSourceParameterId> get subscriptionParameter => {
        DataSourceParameterId.custom(
          widget.button.incomingPackageGetter.parameterId,
        ),
      };
  late final OutgoingPackagesCubit cubit;
  late final bool subscribed;

  @override
  void initState() {
    super.initState();
    cubit = context.read<OutgoingPackagesCubit>();
    subscribed = cubit.subscribeTo(subscriptionParameter);
  }

  @override
  void didUpdateWidget(covariant IndicatorButton oldWidget) {
    final oldParameterId = oldWidget.button.incomingPackageGetter.parameterId;
    final newParameterId = widget.button.incomingPackageGetter.parameterId;
    if (newParameterId != oldParameterId) {
      cubit
        ..unsubscribeFrom({DataSourceParameterId.custom(oldParameterId)})
        ..subscribeTo(subscriptionParameter);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (subscribed) {
      cubit.unsubscribeFrom(subscriptionParameter);
    }
    super.dispose();
  }

  T? getProperty<T>(List<int>? data, Matcher<T>? matcher) {
    if (data == null) return null;
    if (data.isEmpty) return null;
    if (matcher == null) return null;

    try {
      for (final m in matcher.ifMatchers) {
        if (m.satisfies(data)) return m.result;
      }

      return matcher.elseResult;
    } catch (e) {
      Future<void>.error(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DataSourceIncomingPackage?>(
      stream: context.read<IncomingPackagesCubit>().stream.where(
        (event) {
          if (event == null) return false;
          return widget.button.incomingPackageGetter.satisfies(
            requestType: event.requestType.value,
            parameterId: event.parameterId.value,
            functionId: event.data.isEmpty ? null : event.data[0],
          );
        },
      ),
      builder: (context, snapshot) {
        final data = snapshot.data?.data;
        final color = getProperty(data, widget.button.colorMatcher);
        final status = getProperty(data, widget.button.statusMatcher);

        return ButtonDecorationWrapper(
          button: widget.button,
          border: Border.all(
            color: color ?? Colors.transparent,
            width: 2,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.button.title + (status == null ? '' : ': $status'),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
