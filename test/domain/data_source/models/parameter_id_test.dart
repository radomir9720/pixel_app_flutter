import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

void main() {
  group('fromInt() method returns correct instance', () {
    test('(speed)', () {
      expect(ParameterId.fromInt(125), equals(ParameterId.speed()));
    });
    test('(light)', () {
      expect(ParameterId.fromInt(513), equals(ParameterId.light()));
    });
    test('(voltage)', () {
      expect(ParameterId.fromInt(174), equals(ParameterId.voltage()));
    });
    test('(current)', () {
      expect(ParameterId.fromInt(239), equals(ParameterId.current()));
    });
    test('(custom)', () {
      expect(ParameterId.fromInt(23), equals(ParameterId.custom(23)));
    });
  });

  group('triggers right callback in when() method', () {
    test('(speed)', () {
      expect(
        ParameterId.speed().when(
          speed: () => true,
          light: () => false,
          voltage: () => false,
          current: () => false,
          custom: (v) => false,
        ),
        isTrue,
      );
    });
    test('(light)', () {
      expect(
        ParameterId.light().when(
          speed: () => false,
          light: () => true,
          voltage: () => false,
          current: () => false,
          custom: (v) => false,
        ),
        isTrue,
      );
    });
    test('(voltage)', () {
      expect(
        ParameterId.voltage().when(
          speed: () => false,
          light: () => false,
          voltage: () => true,
          current: () => false,
          custom: (v) => false,
        ),
        isTrue,
      );
    });
    test('(current)', () {
      expect(
        ParameterId.current().when(
          speed: () => false,
          light: () => false,
          voltage: () => false,
          current: () => true,
          custom: (v) => false,
        ),
        isTrue,
      );
    });
    test('(custom)', () {
      expect(
        ParameterId.custom(555).when(
          speed: () => 4,
          light: () => 3,
          voltage: () => 2,
          current: () => 1,
          custom: (v) => v,
        ),
        equals(555),
      );
    });
  });

  test('hashCode getter returns correct value', () {
    expect(ParameterId.speed().hashCode, equals(125.hashCode));
    expect(ParameterId.custom(678).hashCode, equals(678.hashCode));
  });

  group('equality operator', () {
    test('returns true when parameter id are equal', () {
      expect(ParameterId.current() == ParameterId.current(), isTrue);
      expect(ParameterId.custom(263) == ParameterId.custom(263), isTrue);
    });

    test('returns false when parameter id are not equal', () {
      expect(ParameterId.current() == ParameterId.speed(), isFalse);
      expect(ParameterId.custom(263) == ParameterId.custom(262), isFalse);
    });
  });
}
