import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

void main() {
  group('fromInt() method returns correct instance', () {
    test('(speed)', () {
      expect(
        DataSourceParameterId.fromInt(0x0106),
        equals(const DataSourceParameterId.motorSpeed()),
      );
    });
    test('(light)', () {
      expect(
        DataSourceParameterId.fromInt(513),
        equals(const DataSourceParameterId.light()),
      );
    });
    test('(voltage)', () {
      expect(
        DataSourceParameterId.fromInt(0x0107),
        equals(const DataSourceParameterId.motorVoltage()),
      );
    });
    test('(current)', () {
      expect(
        DataSourceParameterId.fromInt(0x0108),
        equals(const DataSourceParameterId.motorCurrent()),
      );
    });
    test('(custom)', () {
      expect(
        DataSourceParameterId.fromInt(23),
        equals(const DataSourceParameterId.custom(23)),
      );
    });
  });

  // group('triggers right callback in when() method', () {
  //   test('(speed)', () {
  //     expect(
  //       const DataSourceParameterId.speed().when(
  //         speed: () => true,
  //         light: () => false,
  //         voltage: () => false,
  //         current: () => false,
  //         custom: (v) => false,
  //       ),
  //       isTrue,
  //     );
  //   });
  //   test('(light)', () {
  //     expect(
  //       const DataSourceParameterId.light().when(
  //         speed: () => false,
  //         light: () => true,
  //         voltage: () => false,
  //         current: () => false,
  //         custom: (v) => false,
  //       ),
  //       isTrue,
  //     );
  //   });
  //   test('(voltage)', () {
  //     expect(
  //       const DataSourceParameterId.voltage().when(
  //         speed: () => false,
  //         light: () => false,
  //         voltage: () => true,
  //         current: () => false,
  //         custom: (v) => false,
  //       ),
  //       isTrue,
  //     );
  //   });
  //   test('(current)', () {
  //     expect(
  //       const DataSourceParameterId.current().when(
  //         speed: () => false,
  //         light: () => false,
  //         voltage: () => false,
  //         current: () => true,
  //         custom: (v) => false,
  //       ),
  //       isTrue,
  //     );
  //   });
  //   test('(custom)', () {
  //     expect(
  //       const DataSourceParameterId.custom(555).when(
  //         speed: () => 4,
  //         light: () => 3,
  //         voltage: () => 2,
  //         current: () => 1,
  //         custom: (v) => v,
  //       ),
  //       equals(555),
  //     );
  //   });
  // });

  test('hashCode getter returns correct value', () {
    expect(
      const DataSourceParameterId.motorSpeed().hashCode,
      equals(0x0106.hashCode),
    );
    expect(
      const DataSourceParameterId.custom(678).hashCode,
      equals(678.hashCode),
    );
  });

  group('equality operator', () {
    test('returns true when parameter id are equal', () {
      expect(
        const DataSourceParameterId.motorCurrent() ==
            const DataSourceParameterId.motorCurrent(),
        isTrue,
      );
      expect(
        const DataSourceParameterId.custom(263) ==
            const DataSourceParameterId.custom(263),
        isTrue,
      );
    });

    test('returns false when parameter id are not equal', () {
      expect(
        const DataSourceParameterId.motorCurrent() ==
            const DataSourceParameterId.motorSpeed(),
        isFalse,
      );
      expect(
        const DataSourceParameterId.custom(263) ==
            const DataSourceParameterId.custom(262),
        isFalse,
      );
    });
  });
}
