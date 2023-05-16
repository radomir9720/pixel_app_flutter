import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/extensions.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/organisms/title_wrapper.dart';

class MotorScreen extends StatelessWidget {
  const MotorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TitleWrapper(
      title: context.l10n.motorScreenTitle,
      body: ListView(
        children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
            },
            border: TableBorder(
              horizontalInside:
                  BorderSide(color: Theme.of(context).dividerColor),
              verticalInside: BorderSide(color: Theme.of(context).dividerColor),
            ),
            children: [
              _TwoValuesTableRow.builder(
                builder: () => (
                  context.l10n.firstTileTitle,
                  context.l10n.secondTileTitle,
                  null,
                ),
                parameterName: context.l10n.parameterTileTitle,
                unitOfMeasurement: context.l10n.measurementUnitTileTitle,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 15),
              ),
              _TwoValuesTableRow.builder(
                parameterName: context.l10n.speedTileTitle,
                builder: () {
                  final state = context
                      .select((GeneralDataCubit cubit) => cubit.state.speed);

                  return (
                    '${state.first ~/ 10}',
                    '${state.second ~/ 10}',
                    context.colorFromStatus(state.status),
                  );
                },
                unitOfMeasurement: context.l10n.kmPerHourMeasurenentUnit,
              ),
              _TwoValuesTableRow.builder(
                parameterName: context.l10n.rpmTileTitle,
                builder: () {
                  final state =
                      context.select((MotorDataCubit cubit) => cubit.state.rpm);
                  return (
                    '${state.first}',
                    '${state.second}',
                    context.colorFromStatus(state.status),
                  );
                },
                unitOfMeasurement: context.l10n.rpmMeasurementUnit,
              ),
              _TwoValuesTableRow.builder(
                parameterName: context.l10n.voltageTileTitle,
                builder: () {
                  final state = context
                      .select((MotorDataCubit cubit) => cubit.state.voltage);
                  return (
                    '${state.first ~/ 10}',
                    '${state.second ~/ 10}',
                    context.colorFromStatus(state.status),
                  );
                },
                unitOfMeasurement: context.l10n.wattMeasurementUnit,
              ),
              _TwoValuesTableRow.builder(
                parameterName: context.l10n.currentTileTitle,
                builder: () {
                  final state = context
                      .select((MotorDataCubit cubit) => cubit.state.current);
                  return (
                    '${state.first ~/ 10}',
                    '${state.second ~/ 10}',
                    context.colorFromStatus(state.status),
                  );
                },
                unitOfMeasurement: context.l10n.amperMeasurementUnit,
              ),
              _TwoValuesTableRow.builder(
                parameterName: context.l10n.powerTileTitle,
                builder: () {
                  final state = context
                      .select((MotorDataCubit cubit) => cubit.state.power);
                  return (
                    '${state.first}',
                    '${state.second}',
                    context.colorFromStatus(state.status),
                  );
                },
                unitOfMeasurement: context.l10n.wattMeasurementUnit,
              ),
              _TwoValuesTableRow.builder(
                parameterName: context.l10n.motorsTemperatureTileTitle,
                builder: () {
                  final state = context.select(
                    (MotorDataCubit cubit) => cubit.state.temperature,
                  );
                  return (
                    '${state.firstMotor}',
                    '${state.secondMotor}',
                    context.colorFromStatus(state.status),
                  );
                },
                unitOfMeasurement: context.l10n.celsiusMeasurementUnit,
              ),
              _TwoValuesTableRow.builder(
                parameterName: context.l10n.controllersTemperatureTileTitle,
                builder: () {
                  final state = context.select(
                    (MotorDataCubit cubit) => cubit.state.temperature,
                  );
                  return (
                    '${state.firstController}',
                    '${state.secondController}',
                    context.colorFromStatus(state.status),
                  );
                },
                unitOfMeasurement: context.l10n.celsiusMeasurementUnit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TwoValuesTableRow extends TableRow {
  _TwoValuesTableRow({
    required String parameterName,
    required String firstValue,
    required String secondValue,
    required String unitOfMeasurement,
    Color? color,
    TextStyle? style,
  }) : super(
          decoration: BoxDecoration(
            color: color?.withOpacity(.5),
          ),
          children: [
            Text(parameterName),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(firstValue),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(secondValue),
            ),
            Text(
              unitOfMeasurement,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ]
              .map(
                (e) => DefaultTextStyle(
                  style: style ?? const TextStyle(),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: e,
                  ),
                ),
              )
              .toList(),
        );

  factory _TwoValuesTableRow.builder({
    required String parameterName,
    required String unitOfMeasurement,
    required (String, String, Color?) Function() builder,
    TextStyle? style,
  }) {
    final state = builder();

    return _TwoValuesTableRow(
      parameterName: parameterName,
      firstValue: state.$1,
      secondValue: state.$2,
      color: state.$3,
      unitOfMeasurement: unitOfMeasurement,
      style: style,
    );
  }
}
