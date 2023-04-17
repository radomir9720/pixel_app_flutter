import 'package:meta/meta.dart';

@immutable
abstract class DataSourceParameterId {
  const DataSourceParameterId(this.value);

  factory DataSourceParameterId.fromInt(int id) {
    return all.firstWhere(
      (element) => element.value == id,
      orElse: () => DataSourceParameterId.custom(id),
    );
  }

  const factory DataSourceParameterId.speed() = SpeedParameterId;
  const factory DataSourceParameterId.light() = LightParameterId;
  const factory DataSourceParameterId.voltage() = VoltageParameterId;
  const factory DataSourceParameterId.current() = CurrentParameterId;
  const factory DataSourceParameterId.lowVoltageMinMaxDelta() =
      LowVoltageMinMaxDeltaParameterId;
  const factory DataSourceParameterId.highVoltage() = HighVoltageParameterId;
  const factory DataSourceParameterId.highCurrent() = HighCurrentParameterId;
  const factory DataSourceParameterId.maxTemperature() =
      MaxTemperatureParameterId;
  const factory DataSourceParameterId.custom(int id) = CustomParameterId;

  const factory DataSourceParameterId.temperatureFirstBatch() =
      TemperatureFirstBatchParameterId;
  const factory DataSourceParameterId.temperatureSecondBatch() =
      TemperatureSecondBatchParameterId;
  const factory DataSourceParameterId.temperatureThirdBatch() =
      TemperatureThirdBatchParameterId;
  //
  const factory DataSourceParameterId.lowVoltageOneToThree() =
      LowVoltageOneToThreeParameterId;

  const factory DataSourceParameterId.lowVoltageFourToSix() =
      LowVoltageFourToSixParameterId;
  const factory DataSourceParameterId.lowVoltageSevenToNine() =
      LowVoltageSevenToNineParameterId;
  const factory DataSourceParameterId.lowVoltageTenToTwelve() =
      LowVoltageTenToTwelveParameterId;
  const factory DataSourceParameterId.lowVoltageThirteenToFifteen() =
      LowVoltageThirteenToFifteenParameterId;
  const factory DataSourceParameterId.lowVoltageSixteenToEighteen() =
      LowVoltageSixteenToEighteenParameterId;
  const factory DataSourceParameterId.lowVoltageNineteenToTwentyOne() =
      LowVoltageNineteenToTwentyOneParameterId;
  const factory DataSourceParameterId.lowVoltageTwentyTwoToTwentyFour() =
      LowVoltageTwentyTwoToTwentyFourParameterId;

  bool get isSpeed => this is SpeedParameterId;

  bool get isLight => this is LightParameterId;

  bool get isCurrent => this is CurrentParameterId;

  bool get isVoltage => this is VoltageParameterId;

  bool get isLowVoltage => this is LowVoltageMinMaxDeltaParameterId;

  bool get isHighVoltage => this is HighVoltageParameterId;

  bool get isHighCurrent => this is HighCurrentParameterId;

  bool get isMaxTemperature => this is MaxTemperatureParameterId;

  bool get isTemperatureFirst => this is TemperatureFirstBatchParameterId;
  bool get isTemperatureSecond => this is TemperatureSecondBatchParameterId;
  bool get isTemperatureThird => this is TemperatureThirdBatchParameterId;

//

  bool get isLowVoltageOneToThree => this is LowVoltageOneToThreeParameterId;
  bool get isLowVoltageFourToSix => this is LowVoltageFourToSixParameterId;
  bool get isLowVoltageSevenToNine => this is LowVoltageSevenToNineParameterId;
  bool get isLowVoltageTenToTwelve => this is LowVoltageTenToTwelveParameterId;
  bool get isLowVoltageThirteenToFifteen =>
      this is LowVoltageThirteenToFifteenParameterId;
  bool get isLowVoltageSixteenToEighteen =>
      this is LowVoltageSixteenToEighteenParameterId;
  bool get isLowVoltageNineteenToTwentyOne =>
      this is LowVoltageNineteenToTwentyOneParameterId;
  bool get isLowVoltageTwentyTwoToTwentyFour =>
      this is LowVoltageTwentyTwoToTwentyFourParameterId;

  void voidOn<T extends DataSourceParameterId>(void Function() function) {
    if (this is T) function();
  }

  static List<DataSourceParameterId> get all {
    return const [
      DataSourceParameterId.speed(),
      DataSourceParameterId.light(),
      DataSourceParameterId.voltage(),
      DataSourceParameterId.current(),
      //
      DataSourceParameterId.highCurrent(),
      DataSourceParameterId.highVoltage(),
      DataSourceParameterId.maxTemperature(),
      DataSourceParameterId.lowVoltageMinMaxDelta(),
      //
      DataSourceParameterId.temperatureFirstBatch(),
      DataSourceParameterId.temperatureSecondBatch(),
      DataSourceParameterId.temperatureThirdBatch(),
      //
      DataSourceParameterId.lowVoltageOneToThree(),
      DataSourceParameterId.lowVoltageFourToSix(),
      DataSourceParameterId.lowVoltageSevenToNine(),
      DataSourceParameterId.lowVoltageTenToTwelve(),
      DataSourceParameterId.lowVoltageThirteenToFifteen(),
      DataSourceParameterId.lowVoltageSixteenToEighteen(),
      DataSourceParameterId.lowVoltageNineteenToTwentyOne(),
      DataSourceParameterId.lowVoltageTwentyTwoToTwentyFour(),
    ];
  }

  final int value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DataSourceParameterId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class SpeedParameterId extends DataSourceParameterId {
  const SpeedParameterId() : super(125);
}

class LightParameterId extends DataSourceParameterId {
  const LightParameterId() : super(513);
}

class VoltageParameterId extends DataSourceParameterId {
  const VoltageParameterId() : super(174);
}

class CurrentParameterId extends DataSourceParameterId {
  const CurrentParameterId() : super(239);
}

class LowVoltageMinMaxDeltaParameterId extends DataSourceParameterId {
  const LowVoltageMinMaxDeltaParameterId() : super(0x0047);
}

class CustomParameterId extends DataSourceParameterId {
  const CustomParameterId(super.id);
}

class HighVoltageParameterId extends DataSourceParameterId {
  const HighVoltageParameterId() : super(0x0044);
}

class HighCurrentParameterId extends DataSourceParameterId {
  const HighCurrentParameterId() : super(0x0045);
}

class MaxTemperatureParameterId extends DataSourceParameterId {
  const MaxTemperatureParameterId() : super(0x0046);
}

class TemperatureFirstBatchParameterId extends DataSourceParameterId {
  const TemperatureFirstBatchParameterId() : super(0x0048);
}

class TemperatureSecondBatchParameterId extends DataSourceParameterId {
  const TemperatureSecondBatchParameterId() : super(0x0049);
}

class TemperatureThirdBatchParameterId extends DataSourceParameterId {
  const TemperatureThirdBatchParameterId() : super(0x004A);
}

class LowVoltageOneToThreeParameterId extends DataSourceParameterId {
  const LowVoltageOneToThreeParameterId() : super(0x004B);
}

class LowVoltageFourToSixParameterId extends DataSourceParameterId {
  const LowVoltageFourToSixParameterId() : super(0x004C);
}

class LowVoltageSevenToNineParameterId extends DataSourceParameterId {
  const LowVoltageSevenToNineParameterId() : super(0x004D);
}

class LowVoltageTenToTwelveParameterId extends DataSourceParameterId {
  const LowVoltageTenToTwelveParameterId() : super(0x004E);
}

class LowVoltageThirteenToFifteenParameterId extends DataSourceParameterId {
  const LowVoltageThirteenToFifteenParameterId() : super(0x004F);
}

class LowVoltageSixteenToEighteenParameterId extends DataSourceParameterId {
  const LowVoltageSixteenToEighteenParameterId() : super(0x0050);
}

class LowVoltageNineteenToTwentyOneParameterId extends DataSourceParameterId {
  const LowVoltageNineteenToTwentyOneParameterId() : super(0x0051);
}

class LowVoltageTwentyTwoToTwentyFourParameterId extends DataSourceParameterId {
  const LowVoltageTwentyTwoToTwentyFourParameterId() : super(0x0052);
}
