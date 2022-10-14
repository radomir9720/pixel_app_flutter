import 'package:meta/meta.dart';

@immutable
abstract class ParameterId {
  const ParameterId(this.value);

  factory ParameterId.speed() => const _SpeedParameterId();
  factory ParameterId.light() => const _LightParameterId();
  factory ParameterId.voltage() => const _VoltageParameterId();
  factory ParameterId.current() => const _CurrentParameterId();
  factory ParameterId.custom(int id) => _CustomParameterId(id);

  factory ParameterId.fromInt(int id) {
    return all.firstWhere(
      (element) => element.value == id,
      orElse: () => ParameterId.custom(id),
    );
  }

  static List<ParameterId> get all {
    return [
      ParameterId.speed(),
      ParameterId.light(),
      ParameterId.voltage(),
      ParameterId.current(),
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

    return other is ParameterId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class _SpeedParameterId extends ParameterId {
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

class _LightParameterId extends ParameterId {
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

class _VoltageParameterId extends ParameterId {
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

class _CurrentParameterId extends ParameterId {
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

class _CustomParameterId extends ParameterId {
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

// enum ParameterId {
//   speed(125),
//   light(513),
//   voltage(174),
//   current(239);

//   const ParameterId(this.value);

//   final int value;

//   static ParameterId fromInt(int integer) {
//     return ParameterId.values.firstWhere((element) => 
//            element.value == integer);
//   }

//   R when<R>({
//     required R Function() speed,
//     required R Function() light,
//     required R Function() voltage,
//     required R Function() current,
//   }) {
//     switch (this) {
//       case ParameterId.speed:
//         return speed();
//       case ParameterId.light:
//         return light();
//       case ParameterId.voltage:
//         return voltage();
//       case ParameterId.current:
//         return current();
//     }
//   }
// }
