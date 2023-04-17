import 'package:pixel_app_flutter/domain/data_source/extensions/double.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';

class BatteryLowVoltageOneToThree extends BytesConvertibleWithStatus {
  const BatteryLowVoltageOneToThree({
    required this.first,
    required this.second,
    required this.third,
    required super.status,
  });

  const BatteryLowVoltageOneToThree.zero()
      : first = 0,
        second = 0,
        third = 0,
        super.normal();

  BatteryLowVoltageOneToThree.fromId(
    super.id, {
    required this.first,
    required this.second,
    required this.third,
  }) : super.fromId();

  final double first;
  final double second;
  final double third;

  @override
  List<Object?> get props => [status, first, second, third];

  @override
  BytesConverter<BatteryLowVoltageOneToThree> get bytesConverter =>
      BatteryLowVoltageOneToThreeConverter();
}

class BatteryLowVoltageFourToSix extends BytesConvertibleWithStatus {
  const BatteryLowVoltageFourToSix({
    required this.fourth,
    required this.fifth,
    required this.sixth,
    required super.status,
  });

  const BatteryLowVoltageFourToSix.zero()
      : fourth = 0,
        fifth = 0,
        sixth = 0,
        super.normal();

  BatteryLowVoltageFourToSix.fromId(
    super.id, {
    required this.fourth,
    required this.fifth,
    required this.sixth,
  }) : super.fromId();

  final double fourth;
  final double fifth;
  final double sixth;

  @override
  BytesConverter<BatteryLowVoltageFourToSix> get bytesConverter =>
      BatteryLowVoltageFourToSixConverter();
  @override
  List<Object?> get props => [status, fourth, fifth, sixth];
}

class BatteryLowVoltageSevenToNine extends BytesConvertibleWithStatus {
  const BatteryLowVoltageSevenToNine({
    required this.seventh,
    required this.eighth,
    required this.ninth,
    required super.status,
  });

  const BatteryLowVoltageSevenToNine.zero()
      : seventh = 0,
        eighth = 0,
        ninth = 0,
        super.normal();

  BatteryLowVoltageSevenToNine.fromId(
    super.id, {
    required this.seventh,
    required this.eighth,
    required this.ninth,
  }) : super.fromId();

  final double seventh;
  final double eighth;
  final double ninth;

  @override
  BytesConverter<BatteryLowVoltageSevenToNine> get bytesConverter =>
      BatteryLowVoltageSevenToNineConverter();
  @override
  List<Object?> get props => [status, seventh, eighth, ninth];
}

class BatteryLowVoltageTenToTwelve extends BytesConvertibleWithStatus {
  const BatteryLowVoltageTenToTwelve({
    required this.tenth,
    required this.eleventh,
    required this.twelfth,
    required super.status,
  });

  const BatteryLowVoltageTenToTwelve.zero()
      : tenth = 0,
        eleventh = 0,
        twelfth = 0,
        super.normal();

  BatteryLowVoltageTenToTwelve.fromId(
    super.id, {
    required this.tenth,
    required this.eleventh,
    required this.twelfth,
  }) : super.fromId();

  final double tenth;
  final double eleventh;
  final double twelfth;

  @override
  BytesConverter<BatteryLowVoltageTenToTwelve> get bytesConverter =>
      BatteryLowVoltageTenToTwelveConverter();
  @override
  List<Object?> get props => [status, tenth, eleventh, twelfth];
}

class BatteryLowVoltageThirteenToFifteen extends BytesConvertibleWithStatus {
  const BatteryLowVoltageThirteenToFifteen({
    required this.thirteenth,
    required this.fourteenth,
    required this.fifteenth,
    required super.status,
  });

  const BatteryLowVoltageThirteenToFifteen.zero()
      : thirteenth = 0,
        fourteenth = 0,
        fifteenth = 0,
        super.normal();

  BatteryLowVoltageThirteenToFifteen.fromId(
    super.id, {
    required this.thirteenth,
    required this.fourteenth,
    required this.fifteenth,
  }) : super.fromId();

  final double thirteenth;
  final double fourteenth;
  final double fifteenth;

  @override
  BytesConverter<BatteryLowVoltageThirteenToFifteen> get bytesConverter =>
      BatteryLowVoltageThirteenToFifteenConverter();
  @override
  List<Object?> get props => [status, thirteenth, fourteenth, fifteenth];
}

class BatteryLowVoltageSixteenToEighteen extends BytesConvertibleWithStatus {
  const BatteryLowVoltageSixteenToEighteen({
    required this.sixteenth,
    required this.seventeenth,
    required this.eighteenth,
    required super.status,
  });

  const BatteryLowVoltageSixteenToEighteen.zero()
      : sixteenth = 0,
        seventeenth = 0,
        eighteenth = 0,
        super.normal();

  BatteryLowVoltageSixteenToEighteen.fromId(
    super.id, {
    required this.sixteenth,
    required this.seventeenth,
    required this.eighteenth,
  }) : super.fromId();

  final double sixteenth;
  final double seventeenth;
  final double eighteenth;

  @override
  BytesConverter<BatteryLowVoltageSixteenToEighteen> get bytesConverter =>
      BatteryLowVoltageSixteenToEighteenConverter();
  @override
  List<Object?> get props => [status, sixteenth, seventeenth, eighteenth];
}

class BatteryLowVoltageNineteenToTwentyOne extends BytesConvertibleWithStatus {
  const BatteryLowVoltageNineteenToTwentyOne({
    required this.nineteenth,
    required this.twentieth,
    required this.twentyFirst,
    required super.status,
  });

  const BatteryLowVoltageNineteenToTwentyOne.zero()
      : nineteenth = 0,
        twentieth = 0,
        twentyFirst = 0,
        super.normal();
  BatteryLowVoltageNineteenToTwentyOne.fromId(
    super.id, {
    required this.nineteenth,
    required this.twentieth,
    required this.twentyFirst,
  }) : super.fromId();

  final double nineteenth;
  final double twentieth;
  final double twentyFirst;

  @override
  BytesConverter<BatteryLowVoltageNineteenToTwentyOne> get bytesConverter =>
      BatteryLowVoltageNineteenToTwentyOneConverter();
  @override
  List<Object?> get props => [status, nineteenth, twentieth, twentyFirst];
}

class BatteryLowVoltageTwentyTwoToTwentyFour
    extends BytesConvertibleWithStatus {
  const BatteryLowVoltageTwentyTwoToTwentyFour({
    required this.twentySecond,
    required this.twentyThird,
    required this.twentyFourth,
    required super.status,
  });
  const BatteryLowVoltageTwentyTwoToTwentyFour.zero()
      : twentySecond = 0,
        twentyThird = 0,
        twentyFourth = 0,
        super.normal();

  BatteryLowVoltageTwentyTwoToTwentyFour.fromId(
    super.id, {
    required this.twentySecond,
    required this.twentyThird,
    required this.twentyFourth,
  }) : super.fromId();

  final double twentySecond;
  final double twentyThird;
  final double twentyFourth;

  @override
  BytesConverter<BatteryLowVoltageTwentyTwoToTwentyFour> get bytesConverter =>
      BatteryLowVoltageTwentyTwoToTwentyFourConverter();
  @override
  List<Object?> get props => [status, twentySecond, twentyThird, twentyFourth];
}

abstract class BatteryLowVoltageConverter<T extends BytesConvertible>
    extends BytesConverter<T> {
  const BatteryLowVoltageConverter({
    required this.toModelBuilder,
  });

  final T Function(
    int id,
    double first,
    double second,
    double third,
  ) toModelBuilder;

  @override
  T fromBytes(List<int> bytes) {
    return toModelBuilder(
      bytes[0],
      bytes.sublist(1, 3).toIntFromUint16.fromMilli,
      bytes.sublist(3, 5).toIntFromUint16.fromMilli,
      bytes.sublist(5, 7).toIntFromUint16.fromMilli,
    );
  }
}

class BatteryLowVoltageOneToThreeConverter
    extends BatteryLowVoltageConverter<BatteryLowVoltageOneToThree> {
  BatteryLowVoltageOneToThreeConverter()
      : super(
          toModelBuilder: (id, first, second, third) {
            return BatteryLowVoltageOneToThree.fromId(
              id,
              first: first,
              second: second,
              third: third,
            );
          },
        );

  @override
  List<int> toBytes(BatteryLowVoltageOneToThree model) {
    return [
      ...model.status.toBytes,
      ...model.first.toMilli.toBytesUint16,
      ...model.second.toMilli.toBytesUint16,
      ...model.third.toMilli.toBytesUint16,
    ];
  }
}

class BatteryLowVoltageFourToSixConverter
    extends BatteryLowVoltageConverter<BatteryLowVoltageFourToSix> {
  BatteryLowVoltageFourToSixConverter()
      : super(
          toModelBuilder: (id, first, second, third) {
            return BatteryLowVoltageFourToSix.fromId(
              id,
              fourth: first,
              fifth: second,
              sixth: third,
            );
          },
        );

  @override
  List<int> toBytes(BatteryLowVoltageFourToSix model) {
    return [
      ...model.status.toBytes,
      ...model.fourth.toMilli.toBytesUint16,
      ...model.fifth.toMilli.toBytesUint16,
      ...model.sixth.toMilli.toBytesUint16,
    ];
  }
}

class BatteryLowVoltageSevenToNineConverter
    extends BatteryLowVoltageConverter<BatteryLowVoltageSevenToNine> {
  BatteryLowVoltageSevenToNineConverter()
      : super(
          toModelBuilder: (id, first, second, third) {
            return BatteryLowVoltageSevenToNine.fromId(
              id,
              seventh: first,
              eighth: second,
              ninth: third,
            );
          },
        );

  @override
  List<int> toBytes(BatteryLowVoltageSevenToNine model) {
    return [
      ...model.status.toBytes,
      ...model.seventh.toMilli.toBytesUint16,
      ...model.eighth.toMilli.toBytesUint16,
      ...model.ninth.toMilli.toBytesUint16,
    ];
  }
}

class BatteryLowVoltageTenToTwelveConverter
    extends BatteryLowVoltageConverter<BatteryLowVoltageTenToTwelve> {
  BatteryLowVoltageTenToTwelveConverter()
      : super(
          toModelBuilder: (id, first, second, third) {
            return BatteryLowVoltageTenToTwelve.fromId(
              id,
              tenth: first,
              eleventh: second,
              twelfth: third,
            );
          },
        );

  @override
  List<int> toBytes(BatteryLowVoltageTenToTwelve model) {
    return [
      ...model.status.toBytes,
      ...model.tenth.toMilli.toBytesUint16,
      ...model.eleventh.toMilli.toBytesUint16,
      ...model.twelfth.toMilli.toBytesUint16,
    ];
  }
}

class BatteryLowVoltageThirteenToFifteenConverter
    extends BatteryLowVoltageConverter<BatteryLowVoltageThirteenToFifteen> {
  BatteryLowVoltageThirteenToFifteenConverter()
      : super(
          toModelBuilder: (id, first, second, third) {
            return BatteryLowVoltageThirteenToFifteen.fromId(
              id,
              thirteenth: first,
              fourteenth: second,
              fifteenth: third,
            );
          },
        );
  @override
  List<int> toBytes(BatteryLowVoltageThirteenToFifteen model) {
    return [
      ...model.status.toBytes,
      ...model.thirteenth.toMilli.toBytesUint16,
      ...model.fourteenth.toMilli.toBytesUint16,
      ...model.fifteenth.toMilli.toBytesUint16,
    ];
  }
}

class BatteryLowVoltageSixteenToEighteenConverter
    extends BatteryLowVoltageConverter<BatteryLowVoltageSixteenToEighteen> {
  BatteryLowVoltageSixteenToEighteenConverter()
      : super(
          toModelBuilder: (id, first, second, third) {
            return BatteryLowVoltageSixteenToEighteen.fromId(
              id,
              sixteenth: first,
              seventeenth: second,
              eighteenth: third,
            );
          },
        );
  @override
  List<int> toBytes(BatteryLowVoltageSixteenToEighteen model) {
    return [
      ...model.status.toBytes,
      ...model.sixteenth.toMilli.toBytesUint16,
      ...model.seventeenth.toMilli.toBytesUint16,
      ...model.eighteenth.toMilli.toBytesUint16,
    ];
  }
}

class BatteryLowVoltageNineteenToTwentyOneConverter
    extends BatteryLowVoltageConverter<BatteryLowVoltageNineteenToTwentyOne> {
  BatteryLowVoltageNineteenToTwentyOneConverter()
      : super(
          toModelBuilder: (id, first, second, third) {
            return BatteryLowVoltageNineteenToTwentyOne.fromId(
              id,
              nineteenth: first,
              twentieth: second,
              twentyFirst: third,
            );
          },
        );
  @override
  List<int> toBytes(BatteryLowVoltageNineteenToTwentyOne model) {
    return [
      ...model.status.toBytes,
      ...model.nineteenth.toMilli.toBytesUint16,
      ...model.twentieth.toMilli.toBytesUint16,
      ...model.twentyFirst.toMilli.toBytesUint16,
    ];
  }
}

class BatteryLowVoltageTwentyTwoToTwentyFourConverter
    extends BatteryLowVoltageConverter<BatteryLowVoltageTwentyTwoToTwentyFour> {
  BatteryLowVoltageTwentyTwoToTwentyFourConverter()
      : super(
          toModelBuilder: (id, first, second, third) {
            return BatteryLowVoltageTwentyTwoToTwentyFour.fromId(
              id,
              twentySecond: first,
              twentyThird: second,
              twentyFourth: third,
            );
          },
        );
  @override
  List<int> toBytes(BatteryLowVoltageTwentyTwoToTwentyFour model) {
    return [
      ...model.status.toBytes,
      ...model.twentySecond.toMilli.toBytesUint16,
      ...model.twentyThird.toMilli.toBytesUint16,
      ...model.twentyFourth.toMilli.toBytesUint16,
    ];
  }
}
