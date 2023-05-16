import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/incoming/incoming_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:re_seedwork/re_seedwork.dart';

@sealed
@immutable
class MotorDataState with EquatableMixin {
  const MotorDataState({
    required this.current,
    required this.voltage,
    required this.temperature,
    required this.gearAndRoll,
    required this.rpm,
    required this.power,
  });

  MotorDataState.initial()
      : current = const TwoInt16WithStatusBody.zero(),
        voltage = const TwoUint16WithStatusBody.zero(),
        temperature = const MotorTemperature.zero(),
        gearAndRoll = MotorGearAndRoll.unknown(),
        rpm = const TwoUint16WithStatusBody.zero(),
        power = const TwoInt16WithStatusBody.zero();

  final TwoInt16WithStatusBody current;
  final TwoUint16WithStatusBody voltage;
  final MotorTemperature temperature;
  final MotorGearAndRoll gearAndRoll;
  final TwoUint16WithStatusBody rpm;
  final TwoInt16WithStatusBody power;

  MotorDataState copyWith({
    TwoInt16WithStatusBody? current,
    TwoUint16WithStatusBody? voltage,
    MotorTemperature? temperature,
    MotorGearAndRoll? gearAndRoll,
    TwoUint16WithStatusBody? rpm,
    TwoInt16WithStatusBody? power,
  }) {
    return MotorDataState(
      current: current ?? this.current,
      voltage: voltage ?? this.voltage,
      temperature: temperature ?? this.temperature,
      gearAndRoll: gearAndRoll ?? this.gearAndRoll,
      rpm: rpm ?? this.rpm,
      power: power ?? this.power,
    );
  }

  @override
  List<Object?> get props => [
        current,
        voltage,
        temperature,
        gearAndRoll,
        rpm,
        power,
      ];
}

class MotorDataCubit extends Cubit<MotorDataState> with ConsumerBlocMixin {
  MotorDataCubit({
    required this.dataSource,
  }) : super(MotorDataState.initial()) {
    subscribe<DataSourceIncomingPackage>(dataSource.packageStream, (value) {
      value
        ..voidOnModel<TwoUint16WithStatusBody,
            MotorVoltageIncomingDataSourcePackage>((model) {
          emit(state.copyWith(voltage: model));
        })
        ..voidOnModel<TwoInt16WithStatusBody,
            MotorCurrentIncomingDataSourcePackage>((model) {
          emit(state.copyWith(current: model));
        })
        ..voidOnModel<MotorTemperature,
            MotorTemperatureIncomingDataSourcePackage>((model) {
          emit(state.copyWith(temperature: model));
        })
        ..voidOnModel<MotorGearAndRoll,
            MotorGearAndRollIncomingDataSourcePackage>((model) {
          emit(state.copyWith(gearAndRoll: model));
        })
        ..voidOnModel<TwoUint16WithStatusBody, RPMIncomingDataSourcePackage>(
            (model) {
          emit(state.copyWith(rpm: model));
        })
        ..voidOnModel<TwoInt16WithStatusBody,
            MotorPowerIncomingDataSourcePackage>((model) {
          emit(state.copyWith(power: model));
        });
    });
  }

  static Set<DataSourceParameterId> kDefaultSubscribeParameters = {
    const DataSourceParameterId.motorVoltage(),
    const DataSourceParameterId.motorCurrent(),
    const DataSourceParameterId.rpm(),
    const DataSourceParameterId.gearAndRoll(),
    const DataSourceParameterId.motorPower(),
    const DataSourceParameterId.motorTemperature(),
  };

  @protected
  final DataSource dataSource;
}
