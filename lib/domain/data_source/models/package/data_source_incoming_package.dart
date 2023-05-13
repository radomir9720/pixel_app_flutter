import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_package_exceptions.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/incoming/incoming_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/function_id_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/set_uint8_result_body_bytes_converter_mixin.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/uint8_with_status_body_bytes_converter_mixin.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/implementations/set_uint8_body.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

abstract class DataSourceIncomingPackage<T extends BytesConvertible>
    extends DataSourcePackage {
  DataSourceIncomingPackage(super.source);

  static DataSourceIncomingPackage parse(List<int> source) {
    final builders = DataSourceIncomingPackage.getBuilders();

    for (final builder in builders) {
      final package = builder(source);
      if (package.isValid()) return package;
    }

    throw ParserNotFoundDataSourceIncomingPackageException(source);
  }

  static DataSourceIncomingPackage fromConvertible({
    int firstConfigByte = 0x00,
    required int secondConfigByte,
    required int parameterId,
    required BytesConvertible convertible,
  }) {
    return parse(
      [
        DataSourcePackage.startingByte,
        ...DataSourcePackage.getBodyAndCheckSum(
          secondConfigByte: secondConfigByte,
          parameterId: parameterId,
          convertible: convertible,
          firstConfigByte: firstConfigByte,
        ),
        DataSourcePackage.endingByte,
      ],
    );
  }

  static DataSourceIncomingPackage? instanceOrNUll(List<int> package) {
    try {
      return DataSourceIncomingPackage.parse(package);
    } catch (e) {
      return null;
    }
  }

  bool isValid() {
    return directionFlag == DataSourceRequestDirection.incoming &&
        validRequestType &&
        validParameterId &&
        validFunctionId;
  }

  bool get validRequestType;

  bool get validParameterId;

  bool get validFunctionId;

  BytesConverter<T> get bytesConverter;

  static List<DataSourceIncomingPackage Function(List<int> source)>
      getBuilders<T extends BytesConvertible>() {
    return [
      SpeedIncomingDataSourcePackage.new,
      VoltageIncomingDataSourcePackage.new,
      CurrentIncomingDataSourcePackage.new,
      //
      HandshakeInitialIncomingDataSourcePackage.new,
      HandshakePingIncomingDataSourcePackage.new,
      LowVoltageMinMaxDeltaIncomingDataSourcePackage.new,
      HighCurrentIncomingDataSourcePackage.new,
      HighVoltageIncomingDataSourcePackage.new,
      MaxTemperatureIncomingDataSourcePackage.new,
      BatteryTemperatureFirstBatchIncomingDataSourcePackage.new,
      BatteryTemperatureSecondBatchIncomingDataSourcePackage.new,
      BatteryTemperatureThirdBatchIncomingDataSourcePackage.new,
      BatteryLowVoltageOneToThreeIncomingDataSourcePackage.new,
      BatteryLowVoltageFourToSixIncomingDataSourcePackage.new,
      BatteryLowVoltageSevenToNineIncomingDataSourcePackage.new,
      BatteryLowVoltageTenToTwelveIncomingDataSourcePackage.new,
      BatteryLowVoltageThirteenToFifteenIncomingDataSourcePackage.new,
      BatteryLowVoltageSixteenToEighteenIncomingDataSourcePackage.new,
      BatteryLowVoltageNineteenToTwentyOneIncomingDataSourcePackage.new,
      BatteryLowVoltageTwentyTwoToTwentyFourIncomingDataSourcePackage.new,
      //
      TailSideBeamSetIncomingDataSourcePackage.new,
      FrontSideBeamSetIncomingDataSourcePackage.new,
      //
      LowBeamSetIncomingDataSourcePackage.new,
      HighBeamSetIncomingDataSourcePackage.new,
      //
      FrontHazardBeamSetIncomingDataSourcePackage.new,
      TailHazardBeamSetIncomingDataSourcePackage.new,
      //
      FrontLeftTurnSignalIncomingDataSourcePackage.new,
      FrontRightTurnSignalIncomingDataSourcePackage.new,
      TailLeftTurnSignalIncomingDataSourcePackage.new,
      TailRightTurnSignalIncomingDataSourcePackage.new,
      //
      ErrorWithCodeAndSectionIncomingDataSourcePackage.new,
    ];
  }

  T get dataModel => bytesConverter.fromBytes(data);
}

extension VoidOnModelExtension on DataSourceIncomingPackage {
  void voidOnModel<Y extends BytesConvertible,
      T extends DataSourceIncomingPackage<Y>>(
    void Function(Y model) fn,
  ) {
    if (this is T) fn((this as T).dataModel);
  }
}

abstract class SetUint8ResultIncomingDataSourcePackage
    extends DataSourceIncomingPackage<SetUint8ResultBody>
    with
        IsEventOrSubscriptionAnswerRequestTypeMixin,
        IsSetResponseFunctionIdMixin,
        SetUint8ResultBodyBytesConverterMixin {
  SetUint8ResultIncomingDataSourcePackage(super.source);
}

abstract class Uint8WithstatusIncomingDataSourcePackage
    extends DataSourceIncomingPackage<Uint8WithStatusBody>
    with
        IsEventOrBufferRequestOrSubscriptionAnswerRequestTypeMixin,
        IsPeriodicValueStatusFunctionIdMixin,
        Uint8WithStatusBodyBytesConverterMixin {
  Uint8WithstatusIncomingDataSourcePackage(super.source);
}
