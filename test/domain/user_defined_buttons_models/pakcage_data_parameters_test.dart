import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';

void main() {
  group('PackageDataParameters', () {
    group('Correct parses bytes into integer', () {
      test('Big endian, unsigned, AllDataBytesRange()', () {
        // arrange
        const parameters = PackageDataParameters(
          endian: Endian.big,
          range: AllDataBytesRange(),
          sign: Sign.unsigned,
        );

        // assert
        expect(parameters.getInt([0x01]), equals(1));
        expect(parameters.getInt([0x00, 0xE0]), equals(224));
        expect(parameters.getInt([0x10, 0x55, 0xFF]), equals(1070591));
        expect(parameters.getInt([0x01, 0x02, 0x03, 0x04]), equals(16909060));
        expect(
          parameters.getInt([0x01, 0x02, 0x03, 0x04, 0x05, 0x06]),
          equals(1108152157446),
        );
        expect(
          parameters.getInt([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]),
          equals(BigInt.parse('72623859790382856').toInt()),
        );
      });

      test('Big endian, signed, AllDataBytesRange()', () {
        // arrange
        const parameters = PackageDataParameters(
          endian: Endian.big,
          range: AllDataBytesRange(),
          sign: Sign.signed,
        );

        // assert
        expect(parameters.getInt([0x01]), equals(1));

        // with sign
        expect(parameters.getInt([0x80, 0x60]), equals(-32672));
        // adds one byte 0xFF. Resulting byte list: [0xFF, 0x90, 0x55, 0x7F]
        expect(parameters.getInt([0x90, 0x55, 0x7F]), equals(-7318145));
        //

        // without sign
        expect(parameters.getInt([0x0A, 0xE0]), equals(2784));
        // adds one byte 0x00. Resulting byte list: [0x00, 0x90, 0x55, 0x7F]
        expect(parameters.getInt([0x10, 0x55, 0xFF]), equals(1070591));
      });

      test('Little endian, unsigned, AllDataBytesRange()', () {
        // arrange
        const parameters = PackageDataParameters(
          endian: Endian.little,
          range: AllDataBytesRange(),
          sign: Sign.unsigned,
        );

        // assert
        expect(parameters.getInt([0x01]), equals(1));
        expect(parameters.getInt([0x00, 0xE0]), equals(57344));
        expect(parameters.getInt([0x10, 0x55, 0xFF]), equals(16733456));
        expect(parameters.getInt([0x01, 0x02, 0x03, 0x04]), equals(67305985));
        expect(
          parameters.getInt([0x01, 0x02, 0x03, 0x04, 0x05, 0x06]),
          equals(6618611909121),
        );
        expect(
          parameters.getInt([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]),
          equals(BigInt.parse('578437695752307201').toInt()),
        );
      });

      test('Little endian, signed, AllDataBytesRange()', () {
        // arrange
        const parameters = PackageDataParameters(
          endian: Endian.little,
          range: AllDataBytesRange(),
          sign: Sign.signed,
        );

        // assert
        expect(parameters.getInt([0x01]), equals(1));

        // with sign
        expect(parameters.getInt([0x60, 0x80]), equals(-32672));
        // adds one byte 0xFF. Resulting byte list: [0x90, 0x55, 0x7F, 0xFF]
        expect(parameters.getInt([0x7F, 0x55, 0x90]), equals(-7318145));
        //

        // without sign
        expect(parameters.getInt([0xE0, 0x0A]), equals(2784));
        // adds one byte 0x00. Resulting byte list: [0x90, 0x55, 0x7F, 0x00]
        expect(parameters.getInt([0xFF, 0x55, 0x10]), equals(1070591));
      });
    });
  });
}
