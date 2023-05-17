import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/function_id_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class BatteryLowVoltageOneToThreeIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageOneToThree>
    with IsEventOrBufferRequestRequestTypeMixin, IsSuccessEventFunctionIdMixin {
  BatteryLowVoltageOneToThreeIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageOneToThree> get bytesConverter =>
      BatteryLowVoltageOneToThreeConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageOneToThree;
}

class BatteryLowVoltageFourToSixIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageFourToSix>
    with IsEventOrBufferRequestRequestTypeMixin, IsSuccessEventFunctionIdMixin {
  BatteryLowVoltageFourToSixIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageFourToSix> get bytesConverter =>
      BatteryLowVoltageFourToSixConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageFourToSix;
}

class BatteryLowVoltageSevenToNineIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageSevenToNine>
    with IsEventOrBufferRequestRequestTypeMixin, IsSuccessEventFunctionIdMixin {
  BatteryLowVoltageSevenToNineIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageSevenToNine> get bytesConverter =>
      BatteryLowVoltageSevenToNineConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageSevenToNine;
}

class BatteryLowVoltageTenToTwelveIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageTenToTwelve>
    with IsEventOrBufferRequestRequestTypeMixin, IsSuccessEventFunctionIdMixin {
  BatteryLowVoltageTenToTwelveIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageTenToTwelve> get bytesConverter =>
      BatteryLowVoltageTenToTwelveConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageTenToTwelve;
}

class BatteryLowVoltageThirteenToFifteenIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageThirteenToFifteen>
    with IsEventOrBufferRequestRequestTypeMixin, IsSuccessEventFunctionIdMixin {
  BatteryLowVoltageThirteenToFifteenIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageThirteenToFifteen> get bytesConverter =>
      BatteryLowVoltageThirteenToFifteenConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageThirteenToFifteen;
}

class BatteryLowVoltageSixteenToEighteenIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageSixteenToEighteen>
    with IsEventOrBufferRequestRequestTypeMixin, IsSuccessEventFunctionIdMixin {
  BatteryLowVoltageSixteenToEighteenIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageSixteenToEighteen> get bytesConverter =>
      BatteryLowVoltageSixteenToEighteenConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageSixteenToEighteen;
}

class BatteryLowVoltageNineteenToTwentyOneIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageNineteenToTwentyOne>
    with IsEventOrBufferRequestRequestTypeMixin, IsSuccessEventFunctionIdMixin {
  BatteryLowVoltageNineteenToTwentyOneIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageNineteenToTwentyOne> get bytesConverter =>
      BatteryLowVoltageNineteenToTwentyOneConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageNineteenToTwentyOne;
}

class BatteryLowVoltageTwentyTwoToTwentyFourIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageTwentyTwoToTwentyFour>
    with IsEventOrBufferRequestRequestTypeMixin, IsSuccessEventFunctionIdMixin {
  BatteryLowVoltageTwentyTwoToTwentyFourIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageTwentyTwoToTwentyFour> get bytesConverter =>
      BatteryLowVoltageTwentyTwoToTwentyFourConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageTwentyTwoToTwentyFour;
}
