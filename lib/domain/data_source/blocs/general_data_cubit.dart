import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/incoming/incoming_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';
import 'package:re_seedwork/re_seedwork.dart';

@immutable
final class IntWithStatus {
  const IntWithStatus({
    required this.value,
    required this.status,
  });

  const IntWithStatus.initial()
      : value = 0,
        status = PeriodicValueStatus.normal;

  factory IntWithStatus.fromMap(Map<String, dynamic> map) {
    return IntWithStatus(
      value: map.parse('value'),
      status: PeriodicValueStatus.fromId(map.parse('status')),
    );
  }

  final int value;
  final PeriodicValueStatus status;

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'status': status.id,
    };
  }
}

extension on IntBytesConvertibleWithStatus {
  IntWithStatus toIntWithStatus([int? customValue]) =>
      IntWithStatus(value: customValue ?? value, status: status);
}

@sealed
@immutable
final class GeneralDataState with EquatableMixin {
  const GeneralDataState({
    required this.power,
    required this.batteryLevel,
    required this.odometer,
    required this.speed,
    required this.gear,
  });

  const GeneralDataState.initial()
      : power = const IntWithStatus.initial(),
        batteryLevel = const IntWithStatus.initial(),
        odometer = const IntWithStatus.initial(),
        speed = const IntWithStatus.initial(),
        gear = MotorGear.unknown;

  factory GeneralDataState.fromMap(Map<String, dynamic> map) {
    return GeneralDataState(
      power: map.parseAndMap('power', IntWithStatus.fromMap),
      batteryLevel: map.parseAndMap('batteryLevel', IntWithStatus.fromMap),
      odometer: map.parseAndMap('odometer', IntWithStatus.fromMap),
      speed: map.parseAndMap('speed', IntWithStatus.fromMap),
      gear: map.parseAndMap('gear', MotorGear.fromId),
    );
  }

  final IntWithStatus power;
  final IntWithStatus batteryLevel;
  final IntWithStatus odometer;
  final IntWithStatus speed;
  final MotorGear gear;

  @override
  List<Object?> get props => [
        power,
        batteryLevel,
        odometer,
        speed,
        gear,
      ];

  GeneralDataState copyWith({
    IntWithStatus? power,
    IntWithStatus? batteryLevel,
    IntWithStatus? odometer,
    IntWithStatus? speed,
    MotorGear? gear,
  }) {
    return GeneralDataState(
      power: power ?? this.power,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      odometer: odometer ?? this.odometer,
      speed: speed ?? this.speed,
      gear: gear ?? this.gear,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'power': power.toMap(),
      'batteryLevel': batteryLevel.toMap(),
      'odometer': odometer.toMap(),
      'speed': speed.toMap(),
      'gear': gear.id,
    };
  }
}

class GeneralDataCubit extends Cubit<GeneralDataState> with ConsumerBlocMixin {
  GeneralDataCubit({required this.dataSource})
      : super(const GeneralDataState.initial()) {
    subscribe<DataSourceIncomingPackage>(dataSource.packageStream, (package) {
      package
        ..voidOnModel<Uint8WithStatusBody,
            BatteryLevelIncomingDataSourcePackage>((model) {
          emit(state.copyWith(batteryLevel: model.toIntWithStatus()));
        })
        ..voidOnModel<Int16WithStatusBody,
            BatteryPowerIncomingDataSourcePackage>((model) {
          emit(state.copyWith(power: model.toIntWithStatus()));
        })
        ..voidOnModel<MotorGearAndRoll,
            MotorGearAndRollIncomingDataSourcePackage>((model) {
          emit(state.copyWith(gear: model.gear));
        })
        ..voidOnModel<TwoUint16WithStatusBody,
            MotorSpeedIncomingDataSourcePackage>((model) {
          final avgHundredMetersPerHour = (model.first + model.second) / 2;
          final avgKmPerHour = avgHundredMetersPerHour ~/ 10;
          emit(state.copyWith(speed: model.toIntWithStatus(avgKmPerHour)));
        })
        ..voidOnModel<Uint32WithStatusBody, OdometerIncomingDataSourcePackage>(
            (model) {
          final km = model.value ~/ 10;
          emit(state.copyWith(odometer: model.toIntWithStatus(km)));
        });
    });
  }

  static Set<DataSourceParameterId> kDefaultSubscribeParameters = {
    const DataSourceParameterId.motorSpeed(),
    const DataSourceParameterId.odometer(),
    const DataSourceParameterId.gearAndRoll(),
    const DataSourceParameterId.batteryLevel(),
    const DataSourceParameterId.batteryPower(),
  };

  @protected
  final DataSource dataSource;
}
