import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/incoming/incoming_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:re_seedwork/re_seedwork.dart';

@sealed
@immutable
class GeneralDataState with EquatableMixin {
  const GeneralDataState({
    required this.speed,
    required this.current,
    required this.voltage,
  });

  const GeneralDataState.initial()
      : speed = 0,
        current = 0,
        voltage = 0;

  final int speed;
  final double current;
  final double voltage;

  GeneralDataState copyWith({
    int? speed,
    double? current,
    double? voltage,
  }) {
    return GeneralDataState(
      speed: speed ?? this.speed,
      current: current ?? this.current,
      voltage: voltage ?? this.voltage,
    );
  }

  @override
  List<Object?> get props => [speed, current, voltage];
}

class GeneralDataCubit extends Cubit<GeneralDataState> with ConsumerBlocMixin
// , BlocLoggerMixin<DataSourcePackage, GeneralDataState>
{
  GeneralDataCubit({
    required this.dataSource,
  }) : super(const GeneralDataState.initial()) {
    subscribe<DataSourceIncomingPackage>(dataSource.packageStream, (value) {
      value
        ..voidOnModel<Speed, SpeedIncomingDataSourcePackage>((model) {
          emit(state.copyWith(speed: model.speed));
        })
        ..voidOnModel<Voltage, VoltageIncomingDataSourcePackage>((model) {
          emit(state.copyWith(voltage: model.value));
        })
        ..voidOnModel<Current, CurrentIncomingDataSourcePackage>((model) {
          emit(state.copyWith(current: model.value));
        });
    });
  }

  static Set<DataSourceParameterId> kDefaultSubscribeParameters = {
    const DataSourceParameterId.speed(),
    const DataSourceParameterId.voltage(),
    const DataSourceParameterId.current(),
  };

  @protected
  final DataSource dataSource;
}
