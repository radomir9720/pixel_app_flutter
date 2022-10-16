import 'package:meta/meta.dart';

@immutable
abstract class DataSourceParameterId {
  const DataSourceParameterId(this.value);

  const factory DataSourceParameterId.speed() = _SpeedParameterId;
  const factory DataSourceParameterId.light() = _LightParameterId;
  const factory DataSourceParameterId.voltage() = _VoltageParameterId;
  const factory DataSourceParameterId.current() = _CurrentParameterId;
  const factory DataSourceParameterId.custom(int id) = _CustomParameterId;

  factory DataSourceParameterId.fromInt(int id) {
    return all.firstWhere(
      (element) => element.value == id,
      orElse: () => DataSourceParameterId.custom(id),
    );
  }

  static List<DataSourceParameterId> get all {
    return const [
      DataSourceParameterId.speed(),
      DataSourceParameterId.light(),
      DataSourceParameterId.voltage(),
      DataSourceParameterId.current(),
    ];
  }

  final int value;

  R when<R>({
    required R Function() speed,
    required R Function() light,
    required R Function() voltage,
    required R Function() current,
    required R Function(int id) custom,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DataSourceParameterId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class _SpeedParameterId extends DataSourceParameterId {
  const _SpeedParameterId() : super(125);

  @override
  R when<R>({
    required R Function() speed,
    required R Function() light,
    required R Function() voltage,
    required R Function() current,
    required R Function(int id) custom,
  }) {
    return speed();
  }
}

class _LightParameterId extends DataSourceParameterId {
  const _LightParameterId() : super(513);

  @override
  R when<R>({
    required R Function() speed,
    required R Function() light,
    required R Function() voltage,
    required R Function() current,
    required R Function(int id) custom,
  }) {
    return light();
  }
}

class _VoltageParameterId extends DataSourceParameterId {
  const _VoltageParameterId() : super(174);

  @override
  R when<R>({
    required R Function() speed,
    required R Function() light,
    required R Function() voltage,
    required R Function() current,
    required R Function(int id) custom,
  }) {
    return voltage();
  }
}

class _CurrentParameterId extends DataSourceParameterId {
  const _CurrentParameterId() : super(239);

  @override
  R when<R>({
    required R Function() speed,
    required R Function() light,
    required R Function() voltage,
    required R Function() current,
    required R Function(int id) custom,
  }) {
    return current();
  }
}

class _CustomParameterId extends DataSourceParameterId {
  const _CustomParameterId(super.id);

  @override
  R when<R>({
    required R Function() speed,
    required R Function() light,
    required R Function() voltage,
    required R Function() current,
    required R Function(int id) custom,
  }) {
    return custom(value);
  }
}
