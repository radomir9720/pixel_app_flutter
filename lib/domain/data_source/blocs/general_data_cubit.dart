import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/incoming/incoming_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:re_seedwork/re_seedwork.dart';

@sealed
@immutable
class GeneralDataState with EquatableMixin {
  const GeneralDataState({
    required this.power,
    required this.batteryLevel,
    required this.odometer,
    required this.speed,
  });

  const GeneralDataState.initial()
      : power = const Int16WithStatusBody.zero(),
        batteryLevel = const Uint8WithStatusBody.zero(),
        odometer = const Uint32WithStatusBody.zero(),
        speed = const TwoUint16WithStatusBody.zero();

  final Int16WithStatusBody power;
  final Uint8WithStatusBody batteryLevel;
  final Uint32WithStatusBody odometer;
  final TwoUint16WithStatusBody speed;

  @override
  List<Object?> get props => [
        power,
        batteryLevel,
        odometer,
        speed,
      ];

  GeneralDataState copyWith({
    Int16WithStatusBody? power,
    Uint8WithStatusBody? batteryLevel,
    Uint32WithStatusBody? odometer,
    TwoUint16WithStatusBody? speed,
  }) {
    return GeneralDataState(
      power: power ?? this.power,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      odometer: odometer ?? this.odometer,
      speed: speed ?? this.speed,
    );
  }
}

class GeneralDataCubit extends Cubit<GeneralDataState> with ConsumerBlocMixin {
  GeneralDataCubit({required this.dataSource})
      : super(const GeneralDataState.initial()) {
    subscribe<DataSourceIncomingPackage>(dataSource.packageStream, (package) {
      package
        ..voidOnModel<Uint8WithStatusBody,
            BatteryLevelIncomingDataSourcePackage>((model) {
          emit(state.copyWith(batteryLevel: model));
        })
        ..voidOnModel<Int16WithStatusBody,
            BatteryPowerIncomingDataSourcePackage>((model) {
          emit(state.copyWith(power: model));
        })
        ..voidOnModel<TwoUint16WithStatusBody,
            MotorSpeedIncomingDataSourcePackage>((model) {
          emit(state.copyWith(speed: model));
        })
        ..voidOnModel<Uint32WithStatusBody, OdometerIncomingDataSourcePackage>(
            (model) {
          emit(state.copyWith(odometer: model));
        });
    });
  }

  static Set<DataSourceParameterId> kDefaultSubscribeParameters = {
    const DataSourceParameterId.motorSpeed(),
    const DataSourceParameterId.odometer(),
    const DataSourceParameterId.batteryLevel(),
    const DataSourceParameterId.batteryPower(),
  };

  @protected
  final DataSource dataSource;
}
