import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/incoming/incoming_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:re_seedwork/re_seedwork.dart';

@sealed
@immutable
class BatteryDataState with EquatableMixin {
  const BatteryDataState({
    required this.maxTemperature,
    required this.highCurrent,
    required this.highVoltage,
    required this.lowVoltageMinMaxDelta,
    required this.temperatureFirstBatch,
    required this.temperatureSecondBatch,
    required this.temperatureThirdBatch,
    required this.lowVoltageOneToThree,
    required this.lowVoltageFourToSix,
    required this.lowVoltageSevenToNine,
    required this.lowVoltageTenToTwelve,
    required this.lowVoltageThirteenToFifteen,
    required this.lowVoltageSixteenToEighteen,
    required this.lowVoltageNineteenToTwentyOne,
    required this.lowVoltageTwentyTwoToTwentyFour,
  });
  const BatteryDataState.initial()
      : maxTemperature = const MaxTemperature.zero(),
        highCurrent = const HighCurrent.zero(),
        highVoltage = const HighVoltage.zero(),
        lowVoltageMinMaxDelta = const LowVoltageMinMaxDelta.zero(),
        temperatureFirstBatch = const BatteryTemperatureFirstBatch.zero(),
        temperatureSecondBatch = const BatteryTemperatureSecondBatch.zero(),
        temperatureThirdBatch = const BatteryTemperatureThirdBatch.zero(),
        lowVoltageOneToThree = const BatteryLowVoltageOneToThree.zero(),
        lowVoltageFourToSix = const BatteryLowVoltageFourToSix.zero(),
        lowVoltageSevenToNine = const BatteryLowVoltageSevenToNine.zero(),
        lowVoltageTenToTwelve = const BatteryLowVoltageTenToTwelve.zero(),
        lowVoltageThirteenToFifteen =
            const BatteryLowVoltageThirteenToFifteen.zero(),
        lowVoltageSixteenToEighteen =
            const BatteryLowVoltageSixteenToEighteen.zero(),
        lowVoltageNineteenToTwentyOne =
            const BatteryLowVoltageNineteenToTwentyOne.zero(),
        lowVoltageTwentyTwoToTwentyFour =
            const BatteryLowVoltageTwentyTwoToTwentyFour.zero();

  final MaxTemperature maxTemperature;
  final HighCurrent highCurrent;
  final HighVoltage highVoltage;
  final LowVoltageMinMaxDelta lowVoltageMinMaxDelta;
  //
  final BatteryTemperatureFirstBatch temperatureFirstBatch;
  final BatteryTemperatureSecondBatch temperatureSecondBatch;
  final BatteryTemperatureThirdBatch temperatureThirdBatch;
  //
  final BatteryLowVoltageOneToThree lowVoltageOneToThree;
  final BatteryLowVoltageFourToSix lowVoltageFourToSix;
  final BatteryLowVoltageSevenToNine lowVoltageSevenToNine;
  final BatteryLowVoltageTenToTwelve lowVoltageTenToTwelve;
  final BatteryLowVoltageThirteenToFifteen lowVoltageThirteenToFifteen;
  final BatteryLowVoltageSixteenToEighteen lowVoltageSixteenToEighteen;
  final BatteryLowVoltageNineteenToTwentyOne lowVoltageNineteenToTwentyOne;
  final BatteryLowVoltageTwentyTwoToTwentyFour lowVoltageTwentyTwoToTwentyFour;

  BatteryDataState copyWith({
    MaxTemperature? maxTemperature,
    HighCurrent? highCurrent,
    HighVoltage? highVoltage,
    LowVoltageMinMaxDelta? lowVoltageMinMaxDelta,
    BatteryTemperatureFirstBatch? temperatureFirstBatch,
    BatteryTemperatureSecondBatch? temperatureSecondBatch,
    BatteryTemperatureThirdBatch? temperatureThirdBatch,
    BatteryLowVoltageOneToThree? lowVoltageOneToThree,
    BatteryLowVoltageFourToSix? lowVoltageFourToSix,
    BatteryLowVoltageSevenToNine? lowVoltageSevenToNine,
    BatteryLowVoltageTenToTwelve? lowVoltageTenToTwelve,
    BatteryLowVoltageThirteenToFifteen? lowVoltageThirteenToFifteen,
    BatteryLowVoltageSixteenToEighteen? lowVoltageSixteenToEighteen,
    BatteryLowVoltageNineteenToTwentyOne? lowVoltageNineteenToTwentyOne,
    BatteryLowVoltageTwentyTwoToTwentyFour? lowVoltageTwentyTwoToTwentyFour,
  }) {
    return BatteryDataState(
      maxTemperature: maxTemperature ?? this.maxTemperature,
      highCurrent: highCurrent ?? this.highCurrent,
      highVoltage: highVoltage ?? this.highVoltage,
      lowVoltageMinMaxDelta:
          lowVoltageMinMaxDelta ?? this.lowVoltageMinMaxDelta,
      temperatureFirstBatch:
          temperatureFirstBatch ?? this.temperatureFirstBatch,
      temperatureSecondBatch:
          temperatureSecondBatch ?? this.temperatureSecondBatch,
      temperatureThirdBatch:
          temperatureThirdBatch ?? this.temperatureThirdBatch,
      lowVoltageOneToThree: lowVoltageOneToThree ?? this.lowVoltageOneToThree,
      lowVoltageFourToSix: lowVoltageFourToSix ?? this.lowVoltageFourToSix,
      lowVoltageSevenToNine:
          lowVoltageSevenToNine ?? this.lowVoltageSevenToNine,
      lowVoltageTenToTwelve:
          lowVoltageTenToTwelve ?? this.lowVoltageTenToTwelve,
      lowVoltageThirteenToFifteen:
          lowVoltageThirteenToFifteen ?? this.lowVoltageThirteenToFifteen,
      lowVoltageSixteenToEighteen:
          lowVoltageSixteenToEighteen ?? this.lowVoltageSixteenToEighteen,
      lowVoltageNineteenToTwentyOne:
          lowVoltageNineteenToTwentyOne ?? this.lowVoltageNineteenToTwentyOne,
      lowVoltageTwentyTwoToTwentyFour: lowVoltageTwentyTwoToTwentyFour ??
          this.lowVoltageTwentyTwoToTwentyFour,
    );
  }

  @override
  List<Object?> get props => [
        maxTemperature,
        highCurrent,
        highVoltage,
        lowVoltageMinMaxDelta,
        temperatureFirstBatch,
        temperatureSecondBatch,
        temperatureThirdBatch,
        lowVoltageOneToThree,
        lowVoltageFourToSix,
        lowVoltageSevenToNine,
        lowVoltageTenToTwelve,
        lowVoltageThirteenToFifteen,
        lowVoltageSixteenToEighteen,
        lowVoltageNineteenToTwentyOne,
        lowVoltageTwentyTwoToTwentyFour,
      ];
}

class BatteryDataCubit extends Cubit<BatteryDataState>
    with
        ConsumerBlocMixin,
        BlocLoggerMixin<DataSourcePackage, BatteryDataState> {
  BatteryDataCubit({
    required this.dataSource,
  }) : super(const BatteryDataState.initial()) {
    subscribe<DataSourceIncomingPackage>(dataSource.packageStream, (value) {
      value
        ..voidOnModel<HighCurrent, HighCurrentIncomingDataSourcePackage>(
          (model) => emit(state.copyWith(highCurrent: model)),
        )
        ..voidOnModel<HighVoltage, HighVoltageIncomingDataSourcePackage>(
          (model) => emit(state.copyWith(highVoltage: model)),
        )
        ..voidOnModel<MaxTemperature, MaxTemperatureIncomingDataSourcePackage>(
          (model) => emit(state.copyWith(maxTemperature: model)),
        )
        ..voidOnModel<BatteryTemperatureFirstBatch,
            BatteryTemperatureFirstBatchIncomingDataSourcePackage>(
          (model) => emit(
            state.copyWith(temperatureFirstBatch: model),
          ),
        )
        ..voidOnModel<BatteryTemperatureSecondBatch,
            BatteryTemperatureSecondBatchIncomingDataSourcePackage>(
          (model) => emit(
            state.copyWith(temperatureSecondBatch: model),
          ),
        )
        ..voidOnModel<BatteryTemperatureThirdBatch,
            BatteryTemperatureThirdBatchIncomingDataSourcePackage>(
          (model) => emit(
            state.copyWith(temperatureThirdBatch: model),
          ),
        )
        ..voidOnModel<BatteryLowVoltageOneToThree,
            BatteryLowVoltageOneToThreeIncomingDataSourcePackage>(
          (model) => emit(
            state.copyWith(lowVoltageOneToThree: model),
          ),
        )
        ..voidOnModel<BatteryLowVoltageFourToSix,
            BatteryLowVoltageFourToSixIncomingDataSourcePackage>(
          (model) => emit(
            state.copyWith(lowVoltageFourToSix: model),
          ),
        )
        ..voidOnModel<LowVoltageMinMaxDelta,
            LowVoltageMinMaxDeltaIncomingDataSourcePackage>(
          (model) => emit(
            state.copyWith(lowVoltageMinMaxDelta: model),
          ),
        )
        ..voidOnModel<BatteryLowVoltageSevenToNine,
            BatteryLowVoltageSevenToNineIncomingDataSourcePackage>(
          (model) => emit(
            state.copyWith(lowVoltageSevenToNine: model),
          ),
        )
        ..voidOnModel<BatteryLowVoltageTenToTwelve,
            BatteryLowVoltageTenToTwelveIncomingDataSourcePackage>(
          (model) => emit(
            state.copyWith(lowVoltageTenToTwelve: model),
          ),
        )
        ..voidOnModel<BatteryLowVoltageThirteenToFifteen,
            BatteryLowVoltageThirteenToFifteenIncomingDataSourcePackage>(
          (model) => emit(
            state.copyWith(lowVoltageThirteenToFifteen: model),
          ),
        )
        ..voidOnModel<BatteryLowVoltageSixteenToEighteen,
            BatteryLowVoltageSixteenToEighteenIncomingDataSourcePackage>(
          (model) => emit(
            state.copyWith(lowVoltageSixteenToEighteen: model),
          ),
        )
        ..voidOnModel<BatteryLowVoltageNineteenToTwentyOne,
            BatteryLowVoltageNineteenToTwentyOneIncomingDataSourcePackage>(
          (model) => emit(
            state.copyWith(lowVoltageNineteenToTwentyOne: model),
          ),
        )
        ..voidOnModel<BatteryLowVoltageTwentyTwoToTwentyFour,
            BatteryLowVoltageTwentyTwoToTwentyFourIncomingDataSourcePackage>(
          (model) => emit(
            state.copyWith(lowVoltageTwentyTwoToTwentyFour: model),
          ),
        );
    });
  }

  static Set<DataSourceParameterId> kDefaultSubscribeParameters = {
    const DataSourceParameterId.highCurrent(),
    const DataSourceParameterId.highVoltage(),
    const DataSourceParameterId.maxTemperature(),
  };

  @protected
  final DataSource dataSource;
}
