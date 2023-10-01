import 'package:equatable/equatable.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/double.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class BatteryLowVoltageOneToThree extends BytesConvertible {
  const BatteryLowVoltageOneToThree({
    required this.first,
    required this.second,
    required this.third,
  });

  const BatteryLowVoltageOneToThree.zero()
      : first = 0,
        second = 0,
        third = 0;

  final double first;
  final double second;
  final double third;

  @override
  List<Object?> get props => [first, second, third];

  @override
  BytesConverter<BatteryLowVoltageOneToThree> get bytesConverter =>
      BatteryLowVoltageOneToThreeConverter();
}

class BatteryLowVoltageFourToSix extends BytesConvertible with EquatableMixin {
  const BatteryLowVoltageFourToSix({
    required this.fourth,
    required this.fifth,
    required this.sixth,
  });

  const BatteryLowVoltageFourToSix.zero()
      : fourth = 0,
        fifth = 0,
        sixth = 0;

  final double fourth;
  final double fifth;
  final double sixth;

  @override
  BytesConverter<BatteryLowVoltageFourToSix> get bytesConverter =>
      BatteryLowVoltageFourToSixConverter();
  @override
  List<Object?> get props => [fourth, fifth, sixth];
}

class BatteryLowVoltageSevenToNine extends BytesConvertible
    with EquatableMixin {
  const BatteryLowVoltageSevenToNine({
    required this.seventh,
    required this.eighth,
    required this.ninth,
  });

  const BatteryLowVoltageSevenToNine.zero()
      : seventh = 0,
        eighth = 0,
        ninth = 0;

  final double seventh;
  final double eighth;
  final double ninth;

  @override
  BytesConverter<BatteryLowVoltageSevenToNine> get bytesConverter =>
      BatteryLowVoltageSevenToNineConverter();
  @override
  List<Object?> get props => [seventh, eighth, ninth];
}

class BatteryLowVoltageTenToTwelve extends BytesConvertible
    with EquatableMixin {
  const BatteryLowVoltageTenToTwelve({
    required this.tenth,
    required this.eleventh,
    required this.twelfth,
  });

  const BatteryLowVoltageTenToTwelve.zero()
      : tenth = 0,
        eleventh = 0,
        twelfth = 0;

  final double tenth;
  final double eleventh;
  final double twelfth;

  @override
  BytesConverter<BatteryLowVoltageTenToTwelve> get bytesConverter =>
      BatteryLowVoltageTenToTwelveConverter();
  @override
  List<Object?> get props => [tenth, eleventh, twelfth];
}

class BatteryLowVoltageThirteenToFifteen extends BytesConvertible
    with EquatableMixin {
  const BatteryLowVoltageThirteenToFifteen({
    required this.thirteenth,
    required this.fourteenth,
    required this.fifteenth,
  });

  const BatteryLowVoltageThirteenToFifteen.zero()
      : thirteenth = 0,
        fourteenth = 0,
        fifteenth = 0;

  final double thirteenth;
  final double fourteenth;
  final double fifteenth;

  @override
  BytesConverter<BatteryLowVoltageThirteenToFifteen> get bytesConverter =>
      BatteryLowVoltageThirteenToFifteenConverter();
  @override
  List<Object?> get props => [thirteenth, fourteenth, fifteenth];
}

class BatteryLowVoltageSixteenToEighteen extends BytesConvertible
    with EquatableMixin {
  const BatteryLowVoltageSixteenToEighteen({
    required this.sixteenth,
    required this.seventeenth,
    required this.eighteenth,
  });

  const BatteryLowVoltageSixteenToEighteen.zero()
      : sixteenth = 0,
        seventeenth = 0,
        eighteenth = 0;

  final double sixteenth;
  final double seventeenth;
  final double eighteenth;

  @override
  BytesConverter<BatteryLowVoltageSixteenToEighteen> get bytesConverter =>
      BatteryLowVoltageSixteenToEighteenConverter();
  @override
  List<Object?> get props => [sixteenth, seventeenth, eighteenth];
}

class BatteryLowVoltageNineteenToTwentyOne extends BytesConvertible
    with EquatableMixin {
  const BatteryLowVoltageNineteenToTwentyOne({
    required this.nineteenth,
    required this.twentieth,
    required this.twentyFirst,
  });

  const BatteryLowVoltageNineteenToTwentyOne.zero()
      : nineteenth = 0,
        twentieth = 0,
        twentyFirst = 0;

  final double nineteenth;
  final double twentieth;
  final double twentyFirst;

  @override
  BytesConverter<BatteryLowVoltageNineteenToTwentyOne> get bytesConverter =>
      BatteryLowVoltageNineteenToTwentyOneConverter();
  @override
  List<Object?> get props => [nineteenth, twentieth, twentyFirst];
}

class BatteryLowVoltageTwentyTwoToTwentyFour extends BytesConvertible
    with EquatableMixin {
  const BatteryLowVoltageTwentyTwoToTwentyFour({
    required this.twentySecond,
    required this.twentyThird,
    required this.twentyFourth,
  });
  const BatteryLowVoltageTwentyTwoToTwentyFour.zero()
      : twentySecond = 0,
        twentyThird = 0,
        twentyFourth = 0;

  final double twentySecond;
  final double twentyThird;
  final double twentyFourth;

  @override
  BytesConverter<BatteryLowVoltageTwentyTwoToTwentyFour> get bytesConverter =>
      BatteryLowVoltageTwentyTwoToTwentyFourConverter();
  @override
  List<Object?> get props => [twentySecond, twentyThird, twentyFourth];
}

class BatteryLowVoltageTwentyFiveToTwentySeven extends BytesConvertible {
  const BatteryLowVoltageTwentyFiveToTwentySeven({
    required this.twentyFifth,
    required this.twentySixth,
    required this.twentySeventh,
  });

  const BatteryLowVoltageTwentyFiveToTwentySeven.zero()
      : twentyFifth = 0,
        twentySixth = 0,
        twentySeventh = 0;

  final double twentyFifth;
  final double twentySixth;
  final double twentySeventh;

  @override
  List<Object?> get props => [twentyFifth, twentySixth, twentySeventh];

  @override
  BytesConverter<BatteryLowVoltageTwentyFiveToTwentySeven> get bytesConverter =>
      BatteryLowVoltageTwentyFiveToTwentySevenConverter();
}

class BatteryLowVoltageTwentyEightToThirty extends BytesConvertible {
  const BatteryLowVoltageTwentyEightToThirty({
    required this.twentyEighth,
    required this.twentyNinth,
    required this.thirtieth,
  });

  const BatteryLowVoltageTwentyEightToThirty.zero()
      : twentyEighth = 0,
        twentyNinth = 0,
        thirtieth = 0;

  final double twentyEighth;
  final double twentyNinth;
  final double thirtieth;

  @override
  List<Object?> get props => [twentyEighth, twentyNinth, thirtieth];

  @override
  BytesConverter<BatteryLowVoltageTwentyEightToThirty> get bytesConverter =>
      BatteryLowVoltageTwentyEightToThirtyConverter();
}

class BatteryLowVoltageThirtyOneToThirtyThree extends BytesConvertible {
  const BatteryLowVoltageThirtyOneToThirtyThree({
    required this.thirtyFirst,
    required this.thirtySecond,
    required this.thirtyThird,
  });

  const BatteryLowVoltageThirtyOneToThirtyThree.zero()
      : thirtyFirst = 0,
        thirtySecond = 0,
        thirtyThird = 0;

  final double thirtyFirst;
  final double thirtySecond;
  final double thirtyThird;

  @override
  List<Object?> get props => [thirtyFirst, thirtySecond, thirtyThird];

  @override
  BytesConverter<BatteryLowVoltageThirtyOneToThirtyThree> get bytesConverter =>
      BatteryLowVoltageThirtyOneToThirtyThreeConverter();
}

abstract class BatteryLowVoltageConverter<T extends BytesConvertible>
    extends BytesConverter<T> {
  const BatteryLowVoltageConverter({
    required this.toModelBuilder,
  });

  final T Function(
    double first,
    double second,
    double third,
  ) toModelBuilder;

  @override
  T fromBytes(List<int> bytes) {
    return toModelBuilder(
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
          toModelBuilder: (first, second, third) {
            return BatteryLowVoltageOneToThree(
              first: first,
              second: second,
              third: third,
            );
          },
        );

  @override
  List<int> toBytes(BatteryLowVoltageOneToThree model) {
    return [
      FunctionId.okEventId,
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
          toModelBuilder: (first, second, third) {
            return BatteryLowVoltageFourToSix(
              fourth: first,
              fifth: second,
              sixth: third,
            );
          },
        );

  @override
  List<int> toBytes(BatteryLowVoltageFourToSix model) {
    return [
      FunctionId.okEventId,
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
          toModelBuilder: (first, second, third) {
            return BatteryLowVoltageSevenToNine(
              seventh: first,
              eighth: second,
              ninth: third,
            );
          },
        );

  @override
  List<int> toBytes(BatteryLowVoltageSevenToNine model) {
    return [
      FunctionId.okEventId,
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
          toModelBuilder: (first, second, third) {
            return BatteryLowVoltageTenToTwelve(
              tenth: first,
              eleventh: second,
              twelfth: third,
            );
          },
        );

  @override
  List<int> toBytes(BatteryLowVoltageTenToTwelve model) {
    return [
      FunctionId.okEventId,
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
          toModelBuilder: (first, second, third) {
            return BatteryLowVoltageThirteenToFifteen(
              thirteenth: first,
              fourteenth: second,
              fifteenth: third,
            );
          },
        );
  @override
  List<int> toBytes(BatteryLowVoltageThirteenToFifteen model) {
    return [
      FunctionId.okEventId,
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
          toModelBuilder: (first, second, third) {
            return BatteryLowVoltageSixteenToEighteen(
              sixteenth: first,
              seventeenth: second,
              eighteenth: third,
            );
          },
        );
  @override
  List<int> toBytes(BatteryLowVoltageSixteenToEighteen model) {
    return [
      FunctionId.okEventId,
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
          toModelBuilder: (first, second, third) {
            return BatteryLowVoltageNineteenToTwentyOne(
              nineteenth: first,
              twentieth: second,
              twentyFirst: third,
            );
          },
        );
  @override
  List<int> toBytes(BatteryLowVoltageNineteenToTwentyOne model) {
    return [
      FunctionId.okEventId,
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
          toModelBuilder: (first, second, third) {
            return BatteryLowVoltageTwentyTwoToTwentyFour(
              twentySecond: first,
              twentyThird: second,
              twentyFourth: third,
            );
          },
        );
  @override
  List<int> toBytes(BatteryLowVoltageTwentyTwoToTwentyFour model) {
    return [
      FunctionId.okEventId,
      ...model.twentySecond.toMilli.toBytesUint16,
      ...model.twentyThird.toMilli.toBytesUint16,
      ...model.twentyFourth.toMilli.toBytesUint16,
    ];
  }
}

class BatteryLowVoltageTwentyFiveToTwentySevenConverter
    extends BatteryLowVoltageConverter<
        BatteryLowVoltageTwentyFiveToTwentySeven> {
  BatteryLowVoltageTwentyFiveToTwentySevenConverter()
      : super(
          toModelBuilder: (twentyFifth, twentySixth, twentySeventh) {
            return BatteryLowVoltageTwentyFiveToTwentySeven(
              twentyFifth: twentyFifth,
              twentySixth: twentySixth,
              twentySeventh: twentySeventh,
            );
          },
        );

  @override
  List<int> toBytes(BatteryLowVoltageTwentyFiveToTwentySeven model) {
    return [
      FunctionId.okEventId,
      ...model.twentyFifth.toMilli.toBytesUint16,
      ...model.twentySixth.toMilli.toBytesUint16,
      ...model.twentySeventh.toMilli.toBytesUint16,
    ];
  }
}

class BatteryLowVoltageTwentyEightToThirtyConverter
    extends BatteryLowVoltageConverter<BatteryLowVoltageTwentyEightToThirty> {
  BatteryLowVoltageTwentyEightToThirtyConverter()
      : super(
          toModelBuilder: (twentyEighth, twentyNinth, thirtieth) {
            return BatteryLowVoltageTwentyEightToThirty(
              twentyEighth: twentyEighth,
              twentyNinth: twentyNinth,
              thirtieth: thirtieth,
            );
          },
        );

  @override
  List<int> toBytes(BatteryLowVoltageTwentyEightToThirty model) {
    return [
      FunctionId.okEventId,
      ...model.twentyEighth.toMilli.toBytesUint16,
      ...model.twentyNinth.toMilli.toBytesUint16,
      ...model.thirtieth.toMilli.toBytesUint16,
    ];
  }
}

class BatteryLowVoltageThirtyOneToThirtyThreeConverter
    extends BatteryLowVoltageConverter<
        BatteryLowVoltageThirtyOneToThirtyThree> {
  BatteryLowVoltageThirtyOneToThirtyThreeConverter()
      : super(
          toModelBuilder: (thirtyFirst, thirtySecond, thirtyThird) {
            return BatteryLowVoltageThirtyOneToThirtyThree(
              thirtyFirst: thirtyFirst,
              thirtySecond: thirtySecond,
              thirtyThird: thirtyThird,
            );
          },
        );

  @override
  List<int> toBytes(BatteryLowVoltageThirtyOneToThirtyThree model) {
    return [
      FunctionId.okEventId,
      ...model.thirtyFirst.toMilli.toBytesUint16,
      ...model.thirtySecond.toMilli.toBytesUint16,
      ...model.thirtyThird.toMilli.toBytesUint16,
    ];
  }
}
