import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pixel_app_flutter/data/services/data_source/bluetooth_data_source.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/parse_bytes_package_mixin.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/incoming/handshake.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/outgoing/value_request.dart';
import 'package:re_seedwork/re_seedwork.dart';

class BluetoothSerialMock extends Mock implements FlutterBluetoothSerial {}

class BluetoothConnectionMock extends Mock implements BluetoothConnection {}

class BluetoothStreamSinkMock extends Mock
    implements BluetoothStreamSink<Uint8List> {}

void main() {
  group('PopFirstExtension', () {
    final set1 = [23, 53, 123];
    final set2 = [66, 74, 34, 90];

    final bb = <int>[];
    setUp(bb.clear);
    group('popFirst() method', () {
      test(
          'returns empty list and does not '
          'remove nothing when passing 0 as count param', () {
        // arrange
        bb.addAll(set1);

        // assert
        expect(bb.popFirst(0), isEmpty);
        expect(bb, equals(set1));
        expect(bb.length, set1.length);
      });

      test(
        'returns whole list when passing as count '
        'a number bigger that buffer length, and clears the buffer',
        () {
          // arrange
          bb.addAll(set1);

          // assert
          expect(bb.popFirst(set1.length + 1), set1);
          expect(bb, isEmpty);
          expect(bb.length, 0);
        },
      );

      test(
        'returns n items(more than 0 and less than buffer length) '
        'and removes them from buffer',
        () {
          // arrange
          bb
            ..addAll(set1)
            ..addAll(set2);

          // assert
          expect(bb.popFirst(set1.length), set1);
          expect(bb, set2);
          expect(bb.length, set2.length);
        },
      );
    });
  });

  group('BluetoothDataSource', () {
    const deviceAddress = '123';
    const someRandomAddress = 'someRandomAddress';

    late StreamController<Uint8List> inputStreamController;

    final serial = BluetoothSerialMock();
    final connection = BluetoothConnectionMock();
    final sink = BluetoothStreamSinkMock();

    late BluetoothDataSource ds;

    setUp(() {
      inputStreamController = StreamController<Uint8List>();
      reset(serial);
      reset(connection);
      reset(sink);
      ds = BluetoothDataSource(
        bluetoothSerial: serial,
        id: 123,
        permissionRequestCallback: () async => true,
        connectToAddress: (address) async => connection,
      );

      when(() => serial.isAvailable).thenAnswer((invocation) async => true);
      when(() => serial.isEnabled).thenAnswer((invocation) async => true);
      when(serial.getBondedDevices).thenAnswer(
        (invocation) async => [
          const BluetoothDevice(address: deviceAddress),
        ],
      );
      //
      when(() => connection.input)
          .thenAnswer((invocation) => inputStreamController.stream);
      when(() => connection.output).thenAnswer((invocation) => sink);
      when(sink.close).thenAnswer((_) async {});

      when(connection.close).thenAnswer((invocation) async {});
      when(connection.dispose).thenAnswer((invocation) async {});
    });

    void addBytesToStream(List<int> bytes, {int delayInMillis = 50}) {
      for (var i = 0; i < bytes.length;) {
        final nextI = i + Random().nextInt(20);
        final chunk = bytes.sublist(
          i,
          min(nextI, bytes.length),
        );
        inputStreamController.sink.add(Uint8List.fromList(chunk));

        i = nextI;
      }

      inputStreamController.close();
    }

    Future<void> assertStreamEventsCount(
      int expectableEventsCount, {
      bool awaitNoBytesInBufferToComplete = true,
    }) async {
      var incomingEvents = 0;

      final sub = ds.packageStream.listen((event) => incomingEvents++);

      await inputStreamController.done;

      if (awaitNoBytesInBufferToComplete) await ds.noBytesInBufferFuture;

      expect(incomingEvents, equals(expectableEventsCount));

      await sub.cancel();
    }

    void runActionWithZeroDelay(void Function() action) {
      Future<void>.delayed(Duration.zero).then(
        (value) => action(),
      );
    }

    group('connect method', () {
      test('returns value when device is in the bonded device list', () async {
        expect((await ds.connect(deviceAddress)).isValue, isTrue);

        verify(serial.getBondedDevices).called(1);
        verify(() => connection.input).called(1);
        verify(() => connection.output).called(1);
        verifyNever(() => serial.bondDeviceAtAddress(deviceAddress));
      });

      group("bonds device if it's not bonded", () {
        test('returns value when bonding is succesfull', () async {
          when(() => serial.bondDeviceAtAddress(someRandomAddress)).thenAnswer(
            (invocation) async => true,
          );

          expect((await ds.connect(someRandomAddress)).isValue, true);

          verify(serial.getBondedDevices).called(1);
          verify(() => connection.input).called(1);
          verify(() => connection.output).called(1);
          verify(() => serial.bondDeviceAtAddress(someRandomAddress)).called(1);
        });

        test(
            'returns ConnectError.bondingError '
            'when bonding is unsuccesfull(bondDeviceAtAddress returned false)',
            () async {
          when(() => serial.bondDeviceAtAddress(someRandomAddress)).thenAnswer(
            (invocation) async => false,
          );

          expect(
            await ds.connect(someRandomAddress),
            isA<Result<ConnectError, void>>().having(
              (result) => result.when(error: (e) => e, value: (_) => null),
              'ConnectError.bondingError',
              equals(ConnectError.bondingError),
            ),
          );

          verify(serial.getBondedDevices).called(1);
          verify(() => serial.bondDeviceAtAddress(someRandomAddress)).called(1);
          verifyNever(() => connection.input);
          verifyNever(() => connection.output);
        });

        test(
            'returns ConnectError.bondingError '
            'when bonding is unsuccesfull(bondDeviceAtAddress returned null)',
            () async {
          when(() => serial.bondDeviceAtAddress(someRandomAddress)).thenAnswer(
            (invocation) async => null,
          );

          expect(
            await ds.connect(someRandomAddress),
            isA<Result<ConnectError, void>>().having(
              (result) => result.when(error: (e) => e, value: (_) => null),
              'ConnectError.bondingError',
              equals(ConnectError.bondingError),
            ),
          );

          verify(serial.getBondedDevices).called(1);
          verify(() => serial.bondDeviceAtAddress(someRandomAddress)).called(1);
          verifyNever(() => connection.input);
          verifyNever(() => connection.output);
        });
      });
    });

    group('tryParse()', () {
      test('does nothing when buffer length is less than 9', () {
        // arrange
        ds.buffer.addAll([1, 2, 3]);

        // act
        ds.tryParse(ds.controller.add);

        // assert
        expect(ds.buffer, equals([1, 2, 3]));
      });

      group('if the first byte is not a starting byte', () {
        test('cleares the buffer if there is no starting byte in it', () async {
          // arrange
          ds.buffer.addAll([1, 2, 3, 4, 5, 6, 0, 16, 34, 23]);

          // act
          runActionWithZeroDelay(() {
            ds.tryParse(ds.controller.add);
            ds.controller.close();
          });

          // assert
          await expectLater(
            ds.controller.stream,
            neverEmits(isA<DataSourceIncomingPackage>()),
          );
          expect(ds.buffer, isEmpty);
        });

        test(
            'removes every byte until the starting one '
            'when there is a starting byte in the buffer, '
            'and does nothing more if the buffer length after byte removing '
            'is less than the minimum package length', () async {
          // arrange
          ds.buffer.addAll([1, 2, 3, 4, 5, 6, 60, 0, 16]);

          // act
          runActionWithZeroDelay(() {
            ds.tryParse(ds.controller.add);
            ds.controller.close();
          });

          // assert
          await expectLater(
            ds.controller.stream,
            neverEmits(isA<DataSourceIncomingPackage>()),
          );
          expect(ds.buffer, equals([60, 0, 16]));
        });
        test(
            'removes every byte until the starting one '
            'when there is a starting byte in the buffer, and parses the rest '
            'when in the buffer remained more than or equal '
            'to minimum package length', () async {
          // arrange
          const validPackage = [60, 0, 144, 0, 0, 0, 222, 71, 62];
          ds.buffer.addAll([
            1, 2, 3, 4, 5, 6, //
            ...validPackage,
          ]);

          // act
          runActionWithZeroDelay(() => ds.tryParse(ds.controller.add));

          // assert
          await expectLater(
            ds.controller.stream,
            emits(isA<HandshakeIncomingDataSourcePackage>()),
          );
          expect(ds.buffer, isEmpty);
        });

        test(
            'removes every byte until the starting one '
            'when there is a starting byte in the buffer '
            'and does nothing more when there is no ending byte in the buffer',
            () async {
          // arrange
          const noEndingByte = [60, 0, 144, 0, 0, 0, 222, 71];
          ds.buffer.addAll([
            1, 2, 3, 4, 5, 6, // invalid beggining, should be removed
            ...noEndingByte,
          ]);

          // act
          runActionWithZeroDelay(() {
            ds.tryParse(ds.controller.add);
            ds.controller.close();
          });

          // assert
          await expectLater(
            ds.controller.stream,
            neverEmits(isA<DataSourceIncomingPackage>()),
          );
          expect(ds.buffer, equals(noEndingByte));
        });
      });

      group('there is no ending byte at index where it should be', () {
        test('if new starting byte was not found, cleares the buffer',
            () async {
          // arrange
          // Instead of 43 should be 62(ending byte)
          const endingByteInWrongPlace = [
            60, 0, 144, 0, 0, 0, 222, 71, 43, //
            62 // This is a wrong place
          ];
          ds.buffer.addAll(endingByteInWrongPlace);

          // act
          runActionWithZeroDelay(() {
            ds.tryParse(ds.controller.add);
            ds.controller.close();
          });

          // assert
          await expectLater(
            ds.controller.stream,
            neverEmits(isA<DataSourceIncomingPackage>()),
          );
          expect(ds.buffer, isEmpty);
        });
        test('if new starting byte was found, removes everything until it',
            () async {
          // arrange
          // Instead of 43 should be 62(ending byte)
          const endingByteInWrongPlace = [
            60, 0, 144, 0, 0, 0, 222, 71, 43, //
            62, 43, 60
          ];
          ds.buffer.addAll(endingByteInWrongPlace);

          // act
          runActionWithZeroDelay(() {
            ds.tryParse(ds.controller.add);
            ds.controller.close();
          });

          // assert
          await expectLater(
            ds.controller.stream,
            neverEmits(isA<DataSourceIncomingPackage>()),
          );
          expect(ds.buffer, equals([60]));
        });
      });
    });

    group('parsing bytes into packages', () {
      test('All bytes are parsed into packages(valid bytes order)', () async {
        // arrange
        await ds.connect(deviceAddress);

        // act
        addBytesToStream(_correctBytesOrder);

        // assert
        await assertStreamEventsCount(35);
        expect(ds.buffer.length, isZero);
      });

      group('skips invalid range of bytes and parses correctly the rest', () {
        test('(no starting byte)', () async {
          // arrange
          await ds.connect(deviceAddress);

          // act
          addBytesToStream(_noStartingByte);

          // assert
          await assertStreamEventsCount(3);
          expect(ds.buffer.length, isZero);
        });

        test(
            '(no ending byte. Parses valid packages '
            'and saves bytes without ending byte in the buffer)', () async {
          // arrange
          await ds.connect(deviceAddress);

          // act
          addBytesToStream(_noEndingByte);

          // assert
          await assertStreamEventsCount(
            3,
            awaitNoBytesInBufferToComplete: false,
          );
          expect(ds.buffer.length, equals(10));
        });
      });
    });

    test('disconnect method calls close() on connection', () async {
      // arrange
      await ds.connect(deviceAddress);

      // act
      await ds.disconnect();

      // assert
      verify(connection.close).called(1);
    });

    test(
      'cancedDeviceDiscovering calls FlutterBluetoothSerial.cancelDiscovery()',
      () async {
        // arrange
        when(serial.cancelDiscovery).thenAnswer((invocation) async {});

        // assert
        expect(
          await ds.cancelDeviceDiscovering(),
          isA<Result<CancelDeviceDiscoveringError, void>>().having(
            (p0) => p0.when(error: (_) => null, value: (_) => true),
            'returns Result.value()',
            isTrue,
          ),
        );

        verify(serial.cancelDiscovery).called(1);
      },
    );

    test(
      'getDeviceStream calls FlutterBluetoothSerial.startDiscovery() '
      'and maps all devices to DataSourceDevice',
      () async {
        // arrange
        const deviceCnt = 5;
        final devices = List.generate(
          deviceCnt,
          (index) => BluetoothDiscoveryResult(
            device: BluetoothDevice(
              address: '$index',
              name: '$index',
            ),
          ),
        );

        final controller = StreamController<BluetoothDiscoveryResult>();

        when(serial.startDiscovery).thenAnswer(
          (invocation) => controller.stream,
        );

        // act
        final res = await ds.getDevicesStream();

        // assert
        unawaited(
          expectLater(
            res.when(error: (_) => null, value: (s) => s),
            emitsInOrder(
              List.generate(
                deviceCnt,
                (index) => devices
                    .sublist(0, index + 1)
                    .map(
                      (e) => DataSourceDevice(
                        address: e.device.address,
                        name: e.device.name,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );

        await controller.addStream(Stream.fromIterable(devices));
        await controller.close();
        await ds.cachedDataSourceDevicesStreamController.close();

        verify(serial.startDiscovery).called(1);
      },
      timeout: const Timeout(Duration(seconds: 1)),
    );

    group('isAvailable', () {
      test(
        'returns true when FlutterBluetoothSerial.isAvailable returns true',
        () async {
          // arrange
          when(() => serial.isAvailable).thenAnswer((invocation) async => true);

          // assert
          expect(await ds.isAvailable, isTrue);

          verify(() => serial.isAvailable).called(1);
        },
      );
      test(
        'returns false when FlutterBluetoothSerial.isAvailable returns false',
        () async {
          // arrange
          when(() => serial.isAvailable)
              .thenAnswer((invocation) async => false);

          // assert
          expect(await ds.isAvailable, isFalse);

          verify(() => serial.isAvailable).called(1);
        },
      );
      test(
        'returns false when FlutterBluetoothSerial.isAvailable returns null',
        () async {
          // arrange
          when(() => serial.isAvailable).thenAnswer((invocation) async => null);

          // assert
          expect(await ds.isAvailable, isFalse);

          verify(() => serial.isAvailable).called(1);
        },
      );
    });
    group('isEnabled', () {
      test(
        'returns true when FlutterBluetoothSerial.isEnabled returns true',
        () async {
          // arrange
          when(() => serial.isEnabled).thenAnswer((invocation) async => true);

          // assert
          expect(await ds.isEnabled, isTrue);

          verify(() => serial.isEnabled).called(1);
        },
      );
      test(
        'returns false when FlutterBluetoothSerial.isEnabled returns false',
        () async {
          // arrange
          when(() => serial.isEnabled).thenAnswer((invocation) async => false);

          // assert
          expect(await ds.isEnabled, isFalse);

          verify(() => serial.isEnabled).called(1);
        },
      );
      test(
        'returns false when FlutterBluetoothSerial.isEnabled returns null',
        () async {
          // arrange
          when(() => serial.isEnabled).thenAnswer((invocation) async => null);

          // assert
          expect(await ds.isEnabled, isFalse);

          verify(() => serial.isEnabled).called(1);
        },
      );
    });

    group('enable()', () {
      test(
        'returns EnableError.isUnavailable '
        'if isAvailable returns false',
        () async {
          // arrange
          when(() => serial.isAvailable).thenAnswer(
            (invocation) async => false,
          );

          // assert
          expect(
            await ds.enable(),
            isA<Result<EnableError, void>>().having(
              (p0) => p0.when(error: (e) => e, value: (_) => _),
              'returns EnableError.isUnavailable',
              equals(EnableError.isUnavailable),
            ),
          );
          verifyNever(serial.requestEnable);
        },
      );

      test(
        'returns EnableError.isAlreadyEnabled '
        'if isEnabled returns true',
        () async {
          // arrange
          when(() => serial.isAvailable).thenAnswer(
            (invocation) async => true,
          );
          when(() => serial.isEnabled).thenAnswer(
            (invocation) async => true,
          );

          // assert
          expect(
            await ds.enable(),
            isA<Result<EnableError, void>>().having(
              (p0) => p0.when(error: (e) => e, value: (_) => _),
              'returns EnableError.isAlreadyEnabled',
              equals(EnableError.isAlreadyEnabled),
            ),
          );
          verifyNever(serial.requestEnable);
        },
      );

      group(
        'calls FlutterBluetoothSerial.requestEnable() when '
        'isAvailable is true and isEnabled isFalse',
        () {
          test(
            'returns EnableError.unsuccessfulEnableAttempt '
            'if FlutterBluetoothSerial.requestEnable() returns false',
            () async {
              // arrange
              when(() => serial.isAvailable).thenAnswer(
                (invocation) async => true,
              );
              when(() => serial.isEnabled).thenAnswer(
                (invocation) async => false,
              );
              when(serial.requestEnable).thenAnswer(
                (invocation) async => false,
              );

              // assert
              expect(
                await ds.enable(),
                isA<Result<EnableError, void>>().having(
                  (p0) => p0.when(error: (e) => e, value: (_) => _),
                  'returns EnableError.unsuccessfulEnableAttempt',
                  equals(EnableError.unsuccessfulEnableAttempt),
                ),
              );
              verify(serial.requestEnable).called(1);
            },
          );
          test(
            'returns EnableError.unsuccessfulEnableAttempt '
            'if FlutterBluetoothSerial.requestEnable() returns null',
            () async {
              // arrange
              when(() => serial.isAvailable).thenAnswer(
                (invocation) async => true,
              );
              when(() => serial.isEnabled).thenAnswer(
                (invocation) async => false,
              );
              when(serial.requestEnable).thenAnswer(
                (invocation) async => null,
              );

              // assert
              expect(
                await ds.enable(),
                isA<Result<EnableError, void>>().having(
                  (p0) => p0.when(error: (e) => e, value: (_) => _),
                  'returns EnableError.unsuccessfulEnableAttempt',
                  equals(EnableError.unsuccessfulEnableAttempt),
                ),
              );
              verify(serial.requestEnable).called(1);
            },
          );
          test(
            'returns Result.value() '
            'if FlutterBluetoothSerial.requestEnable() returns true',
            () async {
              // arrange
              when(() => serial.isAvailable).thenAnswer(
                (invocation) async => true,
              );
              when(() => serial.isEnabled).thenAnswer(
                (invocation) async => false,
              );
              when(serial.requestEnable).thenAnswer(
                (invocation) async => true,
              );

              // assert
              expect(
                await ds.enable(),
                isA<Result<EnableError, void>>().having(
                  (p0) => p0.isValue,
                  'returns Result.value()',
                  isTrue,
                ),
              );
              verify(serial.requestEnable).called(1);
            },
          );
        },
      );

      group('sendEvent()', () {
        test(
          'returns SendEventError.noConnection '
          'when connection was not established',
          () async {
            // assert
            expect(
              await ds.sendPackage(
                OutgoingValueRequestPackage(
                  parameterId: const DataSourceParameterId.speed(),
                ),
              ),
              isA<Result<SendPackageError, void>>().having(
                (p0) => p0.when(error: (e) => e, value: (v) => v),
                'returns SendEventError.noConnection',
                equals(SendPackageError.noConnection),
              ),
            );
          },
        );
        test(
          'adds bytes from package to connection.output '
          'and returns Result.value() when connection is established',
          () async {
            // arrange
            await ds.connect(deviceAddress);

            final package = OutgoingValueRequestPackage(
              parameterId: const DataSourceParameterId.speed(),
            );

            final bytes = package.toUint8List;

            when(() => sink.add(bytes)).thenAnswer((invocation) {});

            // assert
            expect(
              await ds.sendPackage(package),
              isA<Result<SendPackageError, void>>().having(
                (p0) => p0.isValue,
                'returns Result.value()',
                isTrue,
              ),
            );
            verify(() => sink.add(bytes)).called(1);
          },
        );
      });

      test('key getter returns always the same string', () {
        final secondInstance = BluetoothDataSource(
          bluetoothSerial: serial,
          id: 321,
          permissionRequestCallback: () async => true,
          connectToAddress: (address) async => connection,
        );
        expect(secondInstance.key, equals(ds.key));
      });
    });

    group('observe feature', () {
      test('adds observer on new incoming event and outgoing', () async {
        await ds.connect(deviceAddress);
        final outgoingEvent = OutgoingValueRequestPackage(
          parameterId: const DataSourceParameterId.speed(),
        );
        const incomingPackage = [60, 0, 144, 0, 0, 0, 222, 71, 62];
        // var incomingEventsCounter = 0;
        final events = <List<int>>[];
        ds.addObserver((raw, parsed, direction) {
          if (raw != null) events.add(raw);
        });

        // act
        await ds.sendPackage(outgoingEvent);
        inputStreamController.add(Uint8List.fromList(incomingPackage));
        await inputStreamController.close();
        await inputStreamController.done;

        // assert
        expect(
          events,
          equals([
            outgoingEvent.toUint8List,
            incomingPackage,
          ]),
        );
      });
    });

    test(
      'on dispose disposes everything that needs to be disposed',
      () async {
        // arrange
        await ds.connect(deviceAddress);
        ds.addObserver((_, __, ___) {});

        // act
        ds.debouncer.run(() {});
        await ds.dispose();

        expect(ds.observers, isEmpty);
        expect(ds.debouncer.isCompleted, isTrue);
        expect(ds.subscription, isNull);
        expect(ds.controller.isClosed, isTrue);
        verify(connection.close).called(1);
        verify(connection.dispose).called(1);
      },
    );

    group('awaitNoBytesInBufferCompleter', () {
      group('noBytesInBuffer getter', () {
        test('initially is true', () {
          // assert
          expect(ds.noBytesInBuffer, isTrue);
        });

        test('becomes true when were received new bytes', () {
          ds.buffer.addAll([1, 2, 3]);
          ds.tryParse(ds.controller.add);
          expect(ds.noBytesInBuffer, isFalse);
        });

        test('becomes false when no bytes remained in buffer', () {
          ds.buffer.addAll([60, 0, 149, 0, 125, 2, 97, 13, 227, 0, 62]);
          ds.tryParse(ds.controller.add);
          expect(ds.noBytesInBuffer, isTrue);
        });
      });

      group('noBytesInBufferFuture getter', () {
        test(' initially is completed', () async {
          final stopwatch = Stopwatch()..start();
          await ds.noBytesInBufferFuture;
          stopwatch.stop();
          final elapsed = stopwatch.elapsedMilliseconds;
          // Tolerance 5 milliseconds
          expect(elapsed, lessThanOrEqualTo(5));
        });

        test(
            'sets new completer when were received new bytes '
            'and does not complete until there are bytes in buffer', () async {
          ds.buffer.addAll([1, 2, 3]);
          ds.tryParse(ds.controller.add);

          await expectLater(
            ds.noBytesInBufferFuture
                .timeout(Duration(milliseconds: ds.debouncer.milliseconds * 2)),
            throwsA(isA<TimeoutException>()),
          );
        });

        test('completer when no bytes remained in buffer', () async {
          ds.buffer.addAll([60, 0, 149, 0, 125, 2, 97, 13, 227, 0, 62]);
          ds.tryParse(ds.controller.add);
          final stopwatch = Stopwatch()..start();
          await ds.noBytesInBufferFuture;
          stopwatch.stop();
          final elapsed = stopwatch.elapsedMilliseconds;
          // Tolerance 5 milliseconds
          expect(elapsed, lessThanOrEqualTo(5));
        });
      });
    });

    tearDown(() {
      inputStreamController.close();
      ds.dispose();
    });
  });
}

const _noStartingByte = [
  0, 144, 0, 0, 0, 222, 71, 62, //
  60, 0, 149, 0, 125, 2, 97, 7, 76, 90, 62, //
  60, 0, 149, 0, 125, 2, 97, 12, 242, 137, 62, //
  60, 0, 149, 0, 125, 2, 97, 13, 227, 0, 62, //
];

const _noEndingByte = [
  60, 0, 144, 0, 0, 0, 222, 71, 62, //
  60, 0, 149, 0, 125, 2, 97, 7, 76, 90, 62, //
  60, 0, 149, 0, 125, 2, 97, 12, 242, 137, 62, //
  60, 0, 149, 0, 125, 2, 97, 13, 227, 0 //
];

const _correctBytesOrder = [
  60, 0, 144, 0, 0, 0, 222, 71, 62, //
  60, 0, 149, 0, 125, 2, 97, 14, 209, 155, 62, //
  60, 0, 149, 0, 125, 2, 97, 13, 227, 0, 62, //
  60, 0, 149, 0, 125, 2, 97, 12, 242, 137, 62, //
  60, 0, 149, 0, 174, 5, 97, 0, 0, 243, 112, 45, 244, 62, //
  60, 0, 149, 0, 239, 5, 97, 255, 255, 103, 138, 80, 238, 62, //
  60, 0, 149, 0, 125, 2, 97, 11, 134, 54, 62, //
  60, 0, 149, 0, 125, 2, 97, 10, 151, 191, 62, //
  60, 0, 144, 255, 255, 4, 121, 215, 1, 0, 57, 233, 62, //
  60, 0, 149, 0, 125, 2, 97, 9, 165, 36, 62, //
  60, 0, 149, 0, 239, 5, 97, 255, 255, 207, 134, 251, 189, 62, //
  60, 0, 149, 0, 125, 2, 97, 8, 180, 173, 62, //
  60, 0, 149, 0, 125, 2, 97, 7, 76, 90, 62, //
  60, 0, 149, 0, 125, 2, 97, 6, 93, 211, 62, //
  60, 0, 149, 0, 125, 2, 97, 5, 111, 72, 62, //
  60, 0, 149, 0, 239, 5, 97, 0, 1, 226, 80, 130, 176, 62, //
  60, 0, 149, 0, 125, 2, 97, 4, 126, 193, 62, //
  60, 0, 149, 0, 174, 5, 97, 0, 0, 242, 118, 81, 26, 62, //
  60, 0, 149, 0, 125, 2, 97, 3, 10, 126, 62, //
  60, 0, 144, 255, 255, 4, 34, 224, 1, 0, 38, 65, 62, //
  60, 0, 149, 0, 125, 2, 97, 2, 27, 247, 62, //
  60, 0, 149, 0, 239, 5, 97, 0, 1, 113, 46, 43, 124, 62, //
  60, 0, 149, 0, 125, 2, 97, 1, 41, 108, 62, //
  60, 0, 149, 0, 125, 2, 97, 0, 56, 229, 62, //
  60, 0, 149, 0, 239, 5, 97, 255, 254, 207, 157, 15, 51, 62, //
  60, 0, 149, 0, 125, 2, 97, 1, 41, 108, 62, //
  60, 0, 144, 255, 255, 4, 118, 230, 1, 0, 87, 98, 62, //
  60, 0, 149, 0, 125, 2, 97, 2, 27, 247, 62, //
  60, 0, 149, 0, 125, 2, 97, 3, 10, 126, 62, //
  60, 0, 149, 0, 174, 5, 97, 0, 0, 242, 48, 118, 40, 62, //
  60, 0, 149, 0, 125, 2, 97, 4, 126, 193, 62, //
  60, 0, 149, 0, 239, 5, 97, 255, 255, 162, 51, 204, 182, 62, //
  60, 0, 149, 0, 125, 2, 97, 5, 111, 72, 62, //
  60, 0, 149, 0, 125, 2, 97, 6, 93, 211, 62, //
  60, 0, 149, 0, 125, 2, 97, 7, 76, 90, 62, //
];
