import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class BatteryLowVoltageOneToThreeIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageOneToThree>
    with IsValueUpdateOrBufferRequestMixin {
  BatteryLowVoltageOneToThreeIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageOneToThree> get dataBytesToModelConverter =>
      BatteryLowVoltageOneToThreeConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageOneToThree;
}

class BatteryLowVoltageFourToSixIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageFourToSix>
    with IsValueUpdateOrBufferRequestMixin {
  BatteryLowVoltageFourToSixIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageFourToSix> get dataBytesToModelConverter =>
      BatteryLowVoltageFourToSixConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageFourToSix;
}

class BatteryLowVoltageSevenToNineIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageSevenToNine>
    with IsValueUpdateOrBufferRequestMixin {
  BatteryLowVoltageSevenToNineIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageSevenToNine> get dataBytesToModelConverter =>
      BatteryLowVoltageSevenToNineConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageSevenToNine;
}

class BatteryLowVoltageTenToTwelveIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageTenToTwelve>
    with IsValueUpdateOrBufferRequestMixin {
  BatteryLowVoltageTenToTwelveIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageTenToTwelve> get dataBytesToModelConverter =>
      BatteryLowVoltageTenToTwelveConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageTenToTwelve;
}

class BatteryLowVoltageThirteenToFifteenIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageThirteenToFifteen>
    with IsValueUpdateOrBufferRequestMixin {
  BatteryLowVoltageThirteenToFifteenIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageThirteenToFifteen>
      get dataBytesToModelConverter =>
          BatteryLowVoltageThirteenToFifteenConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageThirteenToFifteen;
}

class BatteryLowVoltageSixteenToEighteenIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageSixteenToEighteen>
    with IsValueUpdateOrBufferRequestMixin {
  BatteryLowVoltageSixteenToEighteenIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageSixteenToEighteen>
      get dataBytesToModelConverter =>
          BatteryLowVoltageSixteenToEighteenConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageSixteenToEighteen;
}

class BatteryLowVoltageNineteenToTwentyOneIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageNineteenToTwentyOne>
    with IsValueUpdateOrBufferRequestMixin {
  BatteryLowVoltageNineteenToTwentyOneIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageNineteenToTwentyOne>
      get dataBytesToModelConverter =>
          BatteryLowVoltageNineteenToTwentyOneConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageNineteenToTwentyOne;
}

class BatteryLowVoltageTwentyTwoToTwentyFourIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryLowVoltageTwentyTwoToTwentyFour>
    with IsValueUpdateOrBufferRequestMixin {
  BatteryLowVoltageTwentyTwoToTwentyFourIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryLowVoltageTwentyTwoToTwentyFour>
      get dataBytesToModelConverter =>
          BatteryLowVoltageTwentyTwoToTwentyFourConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageTwentyTwoToTwentyFour;
}
