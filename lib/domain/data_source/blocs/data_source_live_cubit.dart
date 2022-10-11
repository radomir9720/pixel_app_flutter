import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

@immutable
class DataSourceLiveState {
  const DataSourceLiveState({
    required this.speed,
    required this.odometer,
    required this.sunCharging,
    required this.wireCharging,
    required this.battery,
    required this.leftDoorOpened,
    required this.rightDoorOpened,
    required this.frontTrunkOpened,
    required this.trunkOpened,
    required this.lightOn,
  });

  final int speed;

  final int odometer;

  final int sunCharging;

  final bool wireCharging;

  final int battery;

  final bool leftDoorOpened;

  final bool rightDoorOpened;

  final bool frontTrunkOpened;

  final bool trunkOpened;

  final bool lightOn;

  @override
  int get hashCode => Object.hash(
        speed,
        odometer,
        sunCharging,
        wireCharging,
        battery,
        leftDoorOpened,
        rightDoorOpened,
        frontTrunkOpened,
        trunkOpened,
        lightOn,
      );

  @override
  bool operator ==(dynamic other) {
    return other is DataSourceLiveState &&
        other.speed == speed &&
        other.odometer == odometer &&
        other.sunCharging == sunCharging &&
        other.wireCharging == wireCharging &&
        other.battery == battery &&
        other.leftDoorOpened == leftDoorOpened &&
        other.rightDoorOpened == rightDoorOpened &&
        other.frontTrunkOpened == frontTrunkOpened &&
        other.trunkOpened == trunkOpened &&
        other.lightOn == lightOn;
  }

  DataSourceLiveState copyWith({
    int? speed,
    int? odometer,
    int? sunCharging,
    bool? wireCharging,
    int? battery,
    bool? leftDoorOpened,
    bool? rightDoorOpened,
    bool? frontTrunkOpened,
    bool? trunkOpened,
    bool? lightOn,
  }) {
    return DataSourceLiveState(
      speed: speed ?? this.speed,
      odometer: odometer ?? this.odometer,
      sunCharging: sunCharging ?? this.sunCharging,
      wireCharging: wireCharging ?? this.wireCharging,
      battery: battery ?? this.battery,
      leftDoorOpened: leftDoorOpened ?? this.leftDoorOpened,
      rightDoorOpened: rightDoorOpened ?? this.rightDoorOpened,
      frontTrunkOpened: frontTrunkOpened ?? this.frontTrunkOpened,
      trunkOpened: trunkOpened ?? this.trunkOpened,
      lightOn: lightOn ?? this.lightOn,
    );
  }
}

class DataSourceLiveCubit extends Cubit<DataSourceLiveState>
    with ConsumerBlocMixin {
  DataSourceLiveCubit({required this.dataSource})
      : super(
          const DataSourceLiveState(
            speed: 0,
            battery: 0,
            odometer: 0,
            sunCharging: 0,
            lightOn: false,
            trunkOpened: false,
            wireCharging: false,
            leftDoorOpened: false,
            rightDoorOpened: false,
            frontTrunkOpened: false,
          ),
        ) {
    subscribe<DataSourceIncomingEvent>(dataSource.eventStream, (event) {
      event.maybeWhen(
        updateValue: (id) => _onValueUpdated(id, event.package.data.first),
        getParameterValue: (id) =>
            _onValueUpdated(id, event.package.data.first),
        handshake: () {
          dataSource.sendEvent(const DataSourceHandshakeOutgoingEvent());
        },
        orElse: () {},
      );
    });
  }

  void _onValueUpdated(ParameterId id, int value) {
    emit(
      id.when(
        speed: () => state.copyWith(speed: value),
        light: () => state.copyWith(lightOn: value == 1),
        voltage: () => state.copyWith(battery: value),
        current: () => state.copyWith(sunCharging: value),
      ),
    );
  }

  @visibleForTesting
  final DataSource dataSource;

  void handshake() {
    dataSource.sendEvent(const DataSourceHandshakeOutgoingEvent());
  }

  void subscribeTo(List<ParameterId> ids) {
    for (final id in ids) {
      dataSource.sendEvent(DataSourceSubscribeOutgoingEvent(id));
    }
  }

  void getValue(ParameterId id) {
    dataSource.sendEvent(DataSourceGetParameterValueOutgoingEvent(id));
  }
}
