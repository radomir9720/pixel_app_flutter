import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pixel_app_flutter/data/services/bluetooth_data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
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
      bool awaitDebouncerToComplete = true,
    }) async {
      var incomingEvents = 0;

      final sub = ds.eventStream.listen((event) => incomingEvents++);

      await inputStreamController.done;
      if (awaitDebouncerToComplete) await ds.debouncer.completerFuture;

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
        ds.tryParse();

        // assert
        expect(ds.buffer, equals([1, 2, 3]));
      });

      group('if the first byte is not a starting byte', () {
        test('cleares the buffer if there is no starting byte in it', () async {
          // arrange
          ds.buffer.addAll([1, 2, 3, 4, 5, 6, 0, 16, 34, 23]);

          // act
          runActionWithZeroDelay(() {
            ds.tryParse();
            ds.controller.close();
          });

          // assert
          await expectLater(
            ds.controller.stream,
            neverEmits(isA<DataSourceIncomingEvent>()),
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
            ds.tryParse();
            ds.controller.close();
          });

          // assert
          await expectLater(
            ds.controller.stream,
            neverEmits(isA<DataSourceIncomingEvent>()),
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
          runActionWithZeroDelay(ds.tryParse);

          // assert
          await expectLater(
            ds.controller.stream,
            emits(isA<DataSourceHandshakeIncomingEvent>()),
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
            ds.tryParse();
            ds.controller.close();
          });

          // assert
          await expectLater(
            ds.controller.stream,
            neverEmits(isA<DataSourceIncomingEvent>()),
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
            ds.tryParse();
            ds.controller.close();
          });

          // assert
          await expectLater(
            ds.controller.stream,
            neverEmits(isA<DataSourceIncomingEvent>()),
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
            ds.tryParse();
            ds.controller.close();
          });

          // assert
          await expectLater(
            ds.controller.stream,
            neverEmits(isA<DataSourceIncomingEvent>()),
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
        await assertStreamEventsCount(403);
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
          await assertStreamEventsCount(3, awaitDebouncerToComplete: false);
          expect(ds.buffer.length, equals(9));
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
      'getDeviceStream calls FlutterBluetoothSerial.startDiscovery() '
      'and maps all devices to DataSourceDevice',
      () async {
        // arrange
        final devices = List.generate(
          5,
          (index) => BluetoothDiscoveryResult(
            device: BluetoothDevice(
              address: '$index',
              name: '$index',
            ),
          ),
        );

        when(serial.startDiscovery).thenAnswer(
          (invocation) => Stream.fromIterable(devices),
        );

        // act
        final res = await ds.getDeviceStream();

        // assert
        expect(
          res,
          isA<Result<GetDeviceListError, Stream<DataSourceDevice>>>().having(
            (p0) => p0.when(error: (e) => null, value: (stream) => stream),
            'returns stream',
            isA<Stream<DataSourceDevice>>(),
          ),
        );

        await res.when(
          error: (e) {},
          value: (value) async {
            final list = await value.toList();
            expect(
              list,
              equals(
                devices
                    .map(
                      (e) => DataSourceDevice(
                        address: e.device.address,
                        name: e.device.name,
                        isBonded: false,
                      ),
                    )
                    .toList(),
              ),
            );
          },
        );

        verify(serial.startDiscovery).called(1);
      },
    );

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
              await ds.sendEvent(
                const DataSourceGetParameterValueOutgoingEvent(
                  id: DataSourceParameterId.speed(),
                ),
              ),
              isA<Result<SendEventError, void>>().having(
                (p0) => p0.when(error: (e) => e, value: (v) => v),
                'returns SendEventError.noConnection',
                equals(SendEventError.noConnection),
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

            const event = DataSourceGetParameterValueOutgoingEvent(
              id: DataSourceParameterId.speed(),
            );
            final bytes = event.toPackage();

            when(() => sink.add(bytes)).thenAnswer((invocation) {});

            // assert
            expect(
              await ds.sendEvent(event),
              isA<Result<SendEventError, void>>().having(
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
          connectToAddress: (address) async => connection,
        );
        expect(secondInstance.key, equals(ds.key));
      });
    });

    group('observe feature', () {
      test('adds observer on new incoming evenr and outgoing', () async {
        await ds.connect(deviceAddress);
        const outgoingEvent = DataSourceGetParameterValueOutgoingEvent(
          id: DataSourceParameterId.speed(),
        );
        const incomingPackage = [60, 0, 144, 0, 0, 0, 222, 71, 62];
        // var incomingEventsCounter = 0;
        final events = <List<int>>[];
        ds.addObserver(events.add);

        // act
        await ds.sendEvent(outgoingEvent);
        inputStreamController.add(Uint8List.fromList(incomingPackage));
        await inputStreamController.close();
        await inputStreamController.done;

        // assert
        expect(
          events,
          equals([
            outgoingEvent.toPackage(),
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
        ds.addObserver((package) {});

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

    tearDown(() {
      inputStreamController.close();
      ds.dispose();
    });
  });
}

const _noStartingByte = [
  0, 144, 0, 0, 0, 222, 71, 62, //
  60, 0, 145, 0, 125, 1, 11, 229, 141, 62, //
  60, 0, 149, 0, 125, 1, 12, 188, 34, 62, //
  60, 0, 149, 0, 125, 1, 13, 173, 171, 62, //
];

const _noEndingByte = [
  60, 0, 144, 0, 0, 0, 222, 71, 62, //
  60, 0, 145, 0, 125, 1, 11, 229, 141, 62, //
  60, 0, 149, 0, 125, 1, 12, 188, 34, 62, //
  60, 0, 149, 0, 125, 1, 13, 173, 171 //
];

const _correctBytesOrder = [
  60, 0, 144, 0, 0, 0, 222, 71, 62, //
  60, 0, 145, 0, 125, 1, 11, 229, 141, 62, //
  60, 0, 149, 0, 125, 1, 12, 188, 34, 62, //
  60, 0, 149, 0, 125, 1, 13, 173, 171, 62, //
  60, 0, 149, 0, 125, 1, 14, 159, 48, 62, //
  60, 0, 149, 0, 125, 1, 15, 142, 185, 62, //
  60, 0, 145, 0, 174, 4, 0, 1, 55, 134, 139, 5, 62, //
  60, 0, 149, 0, 125, 1, 16, 102, 207, 62, //
  60, 0, 145, 0, 239, 4, 255, 255, 158, 213, 204, 251, 62, //
  60, 0, 149, 0, 125, 1, 17, 119, 70, 62, //
  60, 0, 149, 0, 239, 4, 0, 1, 3, 97, 217, 82, 62, //
  60, 0, 149, 0, 125, 1, 18, 69, 221, 62, //
  60, 0, 149, 0, 125, 1, 19, 84, 84, 62, //
  60, 0, 149, 0, 125, 1, 20, 32, 235, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 54, 140, 43, 89, 62, //
  60, 0, 149, 0, 239, 4, 255, 254, 73, 38, 87, 222, 62, //
  60, 0, 149, 0, 125, 1, 21, 49, 98, 62, //
  60, 0, 144, 255, 255, 4, 186, 239, 91, 0, 73, 22, 62, //
  60, 0, 149, 0, 125, 1, 22, 3, 249, 62, //
  60, 0, 149, 0, 125, 1, 23, 18, 112, 62, //
  60, 0, 149, 0, 125, 1, 24, 234, 135, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 237, 22, 244, 30, 62, //
  60, 0, 149, 0, 125, 1, 25, 251, 14, 62, //
  60, 0, 149, 0, 125, 1, 26, 201, 149, 62, //
  60, 0, 149, 0, 125, 1, 27, 216, 28, 62, //
  60, 0, 149, 0, 239, 4, 255, 254, 21, 165, 155, 26, 62, //
  60, 0, 149, 0, 125, 1, 28, 172, 163, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 53, 146, 248, 206, 62, //
  60, 0, 149, 0, 125, 1, 29, 189, 42, 62, //
  60, 0, 144, 255, 255, 4, 205, 249, 91, 0, 23, 62, 62, //
  60, 0, 149, 0, 125, 1, 30, 143, 177, 62, //
  60, 0, 149, 0, 239, 4, 255, 254, 160, 83, 77, 117, 62, //
  60, 0, 149, 0, 125, 1, 31, 158, 56, 62, //
  60, 0, 149, 0, 125, 1, 32, 87, 76, 62, //
  60, 0, 149, 0, 125, 1, 33, 70, 197, 62, //
  60, 0, 149, 0, 125, 1, 34, 116, 94, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 66, 66, 207, 169, 62, //
  60, 0, 144, 255, 255, 4, 169, 255, 91, 0, 42, 239, 62, //
  60, 0, 149, 0, 125, 1, 35, 101, 215, 62, //
  60, 0, 149, 0, 125, 1, 36, 17, 104, 62, //
  60, 0, 149, 0, 125, 1, 37, 0, 225, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 52, 152, 78, 76, 62, //
  60, 0, 149, 0, 239, 4, 0, 1, 203, 40, 2, 253, 62, //
  60, 0, 149, 0, 125, 1, 38, 50, 122, 62, //
  60, 0, 149, 0, 125, 1, 39, 35, 243, 62, //
  60, 0, 149, 0, 125, 1, 40, 219, 4, 62, //
  60, 0, 149, 0, 239, 4, 255, 253, 213, 205, 81, 154, 62, //
  60, 0, 149, 0, 125, 1, 41, 202, 141, 62, //
  60, 0, 149, 0, 125, 1, 42, 248, 22, 62, //
  60, 0, 149, 0, 125, 1, 43, 233, 159, 62, //
  60, 0, 144, 255, 255, 4, 167, 9, 92, 0, 147, 72, 62, //
  60, 0, 149, 0, 125, 1, 44, 157, 32, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 10, 202, 76, 110, 62, //
  60, 0, 149, 0, 125, 1, 45, 140, 169, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 51, 158, 102, 114, 62, //
  60, 0, 149, 0, 125, 1, 46, 190, 50, 62, //
  60, 0, 149, 0, 125, 1, 47, 175, 187, 62, //
  60, 0, 149, 0, 239, 4, 255, 254, 200, 74, 107, 160, 62, //
  60, 0, 149, 0, 125, 1, 48, 71, 205, 62, //
  60, 0, 149, 0, 125, 1, 49, 86, 68, 62, //
  60, 0, 149, 0, 125, 1, 50, 100, 223, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 14, 62, 154, 165, 62, //
  60, 0, 149, 0, 125, 1, 51, 117, 86, 62, //
  60, 0, 144, 255, 255, 4, 172, 19, 92, 0, 165, 178, 62, //
  60, 0, 149, 0, 125, 1, 52, 1, 233, 62, //
  60, 0, 149, 0, 125, 1, 53, 16, 96, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 50, 164, 225, 115, 62, //
  60, 0, 149, 0, 125, 1, 54, 34, 251, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 89, 35, 207, 62, 62, //
  60, 0, 149, 0, 125, 1, 55, 51, 114, 62, //
  60, 0, 149, 0, 125, 1, 56, 203, 133, 62, //
  60, 0, 149, 0, 125, 1, 57, 218, 12, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 61, 209, 25, 150, 62, //
  60, 0, 149, 0, 125, 1, 58, 232, 151, 62, //
  60, 0, 149, 0, 125, 1, 59, 249, 30, 62, //
  60, 0, 149, 0, 125, 1, 60, 141, 161, 62, //
  60, 0, 144, 255, 255, 4, 166, 29, 92, 0, 105, 7, 62, //
  60, 0, 149, 0, 239, 4, 255, 253, 247, 2, 127, 226, 62, //
  60, 0, 149, 0, 125, 1, 61, 156, 40, 62, //
  60, 0, 149, 0, 125, 1, 62, 174, 179, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 49, 170, 34, 101, 62, //
  60, 0, 149, 0, 125, 1, 63, 191, 58, 62, //
  60, 0, 149, 0, 125, 1, 64, 52, 74, 62, //
  60, 0, 149, 0, 239, 4, 255, 254, 185, 162, 233, 250, 62, //
  60, 0, 149, 0, 125, 1, 65, 37, 195, 62, //
  60, 0, 149, 0, 125, 1, 66, 23, 88, 62, //
  60, 0, 149, 0, 125, 1, 67, 6, 209, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 2, 231, 123, 104, 62, //
  60, 0, 149, 0, 125, 1, 68, 114, 110, 62, //
  60, 0, 144, 255, 255, 4, 180, 39, 92, 0, 102, 4, 62, //
  60, 0, 149, 0, 125, 1, 69, 99, 231, 62, //
  60, 0, 149, 0, 125, 1, 70, 81, 124, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 48, 176, 132, 102, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 126, 219, 218, 194, 62, //
  60, 0, 149, 0, 125, 1, 71, 64, 245, 62, //
  60, 0, 149, 0, 125, 1, 72, 184, 2, 62, //
  60, 0, 149, 0, 125, 1, 73, 169, 139, 62, //
  60, 0, 149, 0, 125, 1, 74, 155, 16, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 51, 206, 104, 209, 62, //
  60, 0, 149, 0, 125, 1, 75, 138, 153, 62, //
  60, 0, 149, 0, 125, 1, 76, 254, 38, 62, //
  60, 0, 149, 0, 125, 1, 77, 239, 175, 62, //
  60, 0, 149, 0, 239, 4, 255, 254, 80, 107, 140, 182, 62, //
  60, 0, 144, 255, 255, 4, 199, 49, 92, 0, 74, 192, 62, //
  60, 0, 149, 0, 125, 1, 78, 221, 52, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 47, 182, 247, 9, 62, //
  60, 0, 149, 0, 125, 1, 79, 204, 189, 62, //
  60, 0, 149, 0, 125, 1, 80, 36, 203, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 227, 226, 223, 165, 62, //
  60, 0, 149, 0, 125, 1, 81, 53, 66, 62, //
  60, 0, 149, 0, 125, 1, 82, 7, 217, 62, //
  60, 0, 149, 0, 125, 1, 83, 22, 80, 62, //
  60, 0, 149, 0, 125, 1, 84, 98, 239, 62, //
  60, 0, 149, 0, 239, 4, 0, 2, 24, 106, 249, 220, 62, //
  60, 0, 149, 0, 125, 1, 85, 115, 102, 62, //
  60, 0, 144, 255, 255, 4, 207, 59, 92, 0, 220, 98, 62, //
  60, 0, 149, 0, 125, 1, 86, 65, 253, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 46, 188, 65, 139, 62, //
  60, 0, 149, 0, 125, 1, 87, 80, 116, 62, //
  60, 0, 149, 0, 239, 4, 0, 2, 29, 222, 116, 203, 62, //
  60, 0, 149, 0, 125, 1, 88, 168, 131, 62, //
  60, 0, 149, 0, 125, 1, 89, 185, 10, 62, //
  60, 0, 149, 0, 125, 1, 90, 139, 145, 62, //
  60, 0, 149, 0, 239, 4, 0, 2, 43, 217, 226, 6, 62, //
  60, 0, 149, 0, 125, 1, 91, 154, 24, 62, //
  60, 0, 149, 0, 125, 1, 92, 238, 167, 62, //
  60, 0, 149, 0, 125, 1, 93, 255, 46, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 212, 160, 70, 56, 62, //
  60, 0, 149, 0, 125, 1, 94, 205, 181, 62, //
  60, 0, 144, 255, 255, 4, 202, 69, 92, 0, 34, 246, 62, //
  60, 0, 149, 0, 125, 1, 95, 220, 60, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 45, 194, 241, 26, 62, //
  60, 0, 149, 0, 125, 1, 96, 21, 72, 62, //
  60, 0, 149, 0, 125, 1, 97, 4, 193, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 74, 182, 179, 227, 62, //
  60, 0, 149, 0, 125, 1, 98, 54, 90, 62, //
  60, 0, 149, 0, 125, 1, 99, 39, 211, 62, //
  60, 0, 149, 0, 125, 1, 100, 83, 108, 62, //
  60, 0, 149, 0, 239, 4, 0, 1, 138, 163, 103, 152, 62, //
  60, 0, 149, 0, 125, 1, 101, 66, 229, 62, //
  60, 0, 149, 0, 125, 1, 101, 66, 229, 62, //
  60, 0, 144, 255, 255, 4, 215, 79, 92, 0, 25, 162, 62, //
  60, 0, 149, 0, 125, 1, 100, 83, 108, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 44, 200, 71, 152, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 174, 18, 222, 52, 62, //
  60, 0, 149, 0, 125, 1, 99, 39, 211, 62, //
  60, 0, 149, 0, 125, 1, 98, 54, 90, 62, //
  60, 0, 149, 0, 125, 1, 97, 4, 193, 62, //
  60, 0, 149, 0, 125, 1, 96, 21, 72, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 186, 81, 95, 123, 62, //
  60, 0, 149, 0, 125, 1, 95, 220, 60, 62, //
  60, 0, 149, 0, 125, 1, 94, 205, 181, 62, //
  60, 0, 149, 0, 125, 1, 93, 255, 46, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 218, 133, 170, 135, 62, //
  60, 0, 149, 0, 125, 1, 92, 238, 167, 62, //
  60, 0, 144, 255, 255, 4, 232, 89, 92, 0, 180, 229, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 43, 206, 111, 166, 62, //
  60, 0, 149, 0, 125, 1, 91, 154, 24, 62, //
  60, 0, 149, 0, 125, 1, 90, 139, 145, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 229, 104, 160, 39, 62, //
  60, 0, 149, 0, 125, 1, 89, 185, 10, 62, //
  60, 0, 149, 0, 125, 1, 88, 168, 131, 62, //
  60, 0, 149, 0, 125, 1, 87, 80, 116, 62, //
  60, 0, 149, 0, 125, 1, 86, 65, 253, 62, //
  60, 0, 149, 0, 239, 4, 255, 254, 55, 103, 110, 135, 62, //
  60, 0, 149, 0, 125, 1, 85, 115, 102, 62, //
  60, 0, 149, 0, 125, 1, 84, 98, 239, 62, //
  60, 0, 149, 0, 125, 1, 83, 22, 80, 62, //
  60, 0, 144, 255, 255, 4, 224, 99, 92, 0, 164, 233, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 42, 212, 201, 165, 62, //
  60, 0, 149, 0, 239, 4, 0, 2, 44, 150, 21, 253, 62, //
  60, 0, 149, 0, 125, 1, 82, 7, 217, 62, //
  60, 0, 149, 0, 125, 1, 81, 53, 66, 62, //
  60, 0, 149, 0, 125, 1, 80, 36, 203, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 251, 238, 77, 185, 62, //
  60, 0, 149, 0, 125, 1, 79, 204, 189, 62, //
  60, 0, 149, 0, 125, 1, 78, 221, 52, 62, //
  60, 0, 149, 0, 125, 1, 77, 239, 175, 62, //
  60, 0, 149, 0, 125, 1, 76, 254, 38, 62, //
  60, 0, 149, 0, 239, 4, 0, 1, 17, 57, 161, 190, 62, //
  60, 0, 149, 0, 125, 1, 75, 138, 153, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 41, 218, 10, 179, 62, //
  60, 0, 144, 255, 255, 4, 251, 109, 92, 0, 183, 70, 62, //
  60, 0, 149, 0, 125, 1, 74, 155, 16, 62, //
  60, 0, 149, 0, 125, 1, 73, 169, 139, 62, //
  60, 0, 149, 0, 239, 4, 0, 2, 1, 91, 155, 95, 62, //
  60, 0, 149, 0, 125, 1, 72, 184, 2, 62, //
  60, 0, 149, 0, 125, 1, 71, 64, 245, 62, //
  60, 0, 149, 0, 125, 1, 70, 81, 124, 62, //
  60, 0, 149, 0, 239, 4, 0, 2, 67, 68, 6, 255, 62, //
  60, 0, 149, 0, 125, 1, 69, 99, 231, 62, //
  60, 0, 149, 0, 125, 1, 68, 114, 110, 62, //
  60, 0, 149, 0, 125, 1, 67, 6, 209, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 40, 224, 141, 178, 62, //
  60, 0, 149, 0, 125, 1, 66, 23, 88, 62, //
  60, 0, 144, 255, 255, 4, 22, 120, 92, 0, 52, 107, 62, //
  60, 0, 149, 0, 239, 4, 0, 1, 131, 153, 46, 89, 62, //
  60, 0, 149, 0, 125, 1, 65, 37, 195, 62, //
  60, 0, 149, 0, 125, 1, 64, 52, 74, 62, //
  60, 0, 149, 0, 125, 1, 63, 191, 58, 62, //
  60, 0, 149, 0, 239, 4, 255, 254, 170, 221, 221, 115, 62, //
  60, 0, 149, 0, 125, 1, 62, 174, 179, 62, //
  60, 0, 149, 0, 125, 1, 61, 156, 40, 62, //
  60, 0, 149, 0, 125, 1, 60, 141, 161, 62, //
  60, 0, 149, 0, 239, 4, 255, 254, 112, 129, 231, 209, 62, //
  60, 0, 149, 0, 125, 1, 59, 249, 30, 62, //
  60, 0, 149, 0, 125, 1, 58, 232, 151, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 39, 230, 107, 76, 62, //
  60, 0, 144, 255, 255, 4, 39, 130, 92, 0, 155, 108, 62, //
  60, 0, 149, 0, 125, 1, 57, 218, 12, 62, //
  60, 0, 149, 0, 125, 1, 56, 203, 133, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 105, 7, 29, 155, 62, //
  60, 0, 149, 0, 125, 1, 55, 51, 114, 62, //
  60, 0, 149, 0, 125, 1, 54, 34, 251, 62, //
  60, 0, 149, 0, 125, 1, 53, 16, 96, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 99, 255, 152, 13, 62, //
  60, 0, 149, 0, 125, 1, 52, 1, 233, 62, //
  60, 0, 149, 0, 125, 1, 51, 117, 86, 62, //
  60, 0, 149, 0, 125, 1, 50, 100, 223, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 38, 236, 221, 206, 62, //
  60, 0, 149, 0, 239, 4, 255, 254, 136, 23, 164, 166, 62, //
  60, 0, 149, 0, 125, 1, 49, 86, 68, 62, //
  60, 0, 144, 255, 255, 4, 47, 140, 92, 0, 110, 175, 62, //
  60, 0, 149, 0, 125, 1, 48, 71, 205, 62, //
  60, 0, 149, 0, 125, 1, 47, 175, 187, 62, //
  60, 0, 149, 0, 125, 1, 46, 190, 50, 62, //
  60, 0, 149, 0, 239, 4, 255, 254, 222, 65, 20, 50, 62, //
  60, 0, 149, 0, 125, 1, 45, 140, 169, 62, //
  60, 0, 149, 0, 125, 1, 44, 157, 32, 62, //
  60, 0, 149, 0, 125, 1, 43, 233, 159, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 113, 86, 5, 198, 62, //
  60, 0, 149, 0, 125, 1, 42, 248, 22, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 37, 242, 14, 89, 62, //
  60, 0, 149, 0, 125, 1, 41, 202, 141, 62, //
  60, 0, 144, 255, 255, 4, 37, 150, 92, 0, 68, 238, 62, //
  60, 0, 149, 0, 125, 1, 40, 219, 4, 62, //
  60, 0, 149, 0, 239, 4, 255, 253, 224, 207, 186, 146, 62, //
  60, 0, 149, 0, 125, 1, 39, 35, 243, 62, //
  60, 0, 149, 0, 125, 1, 38, 50, 122, 62, //
  60, 0, 149, 0, 125, 1, 37, 0, 225, 62, //
  60, 0, 149, 0, 125, 1, 36, 17, 104, 62, //
  60, 0, 149, 0, 239, 4, 0, 1, 151, 226, 17, 252, 62, //
  60, 0, 149, 0, 125, 1, 35, 101, 215, 62, //
  60, 0, 149, 0, 125, 1, 34, 116, 94, 62, //
  60, 0, 149, 0, 125, 1, 33, 70, 197, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 36, 248, 184, 219, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 23, 117, 36, 251, 62, //
  60, 0, 149, 0, 125, 1, 32, 87, 76, 62, //
  60, 0, 144, 255, 255, 4, 43, 160, 92, 0, 186, 219, 62, //
  60, 0, 149, 0, 125, 1, 31, 158, 56, 62, //
  60, 0, 149, 0, 125, 1, 30, 143, 177, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 225, 95, 129, 90, 62, //
  60, 0, 149, 0, 125, 1, 29, 189, 42, 62, //
  60, 0, 149, 0, 125, 1, 28, 172, 163, 62, //
  60, 0, 149, 0, 125, 1, 27, 216, 28, 62, //
  60, 0, 149, 0, 125, 1, 26, 201, 149, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 139, 36, 215, 10, 62, //
  60, 0, 149, 0, 125, 1, 25, 251, 14, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 35, 254, 144, 229, 62, //
  60, 0, 149, 0, 125, 1, 24, 234, 135, 62, //
  60, 0, 144, 255, 255, 4, 48, 170, 92, 0, 202, 21, 62, //
  60, 0, 149, 0, 125, 1, 23, 18, 112, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 125, 161, 44, 119, 62, //
  60, 0, 149, 0, 125, 1, 22, 3, 249, 62, //
  60, 0, 149, 0, 125, 1, 21, 49, 98, 62, //
  60, 0, 149, 0, 125, 1, 20, 32, 235, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 234, 42, 66, 249, 62, //
  60, 0, 149, 0, 125, 1, 19, 84, 84, 62, //
  60, 0, 149, 0, 125, 1, 18, 69, 221, 62, //
  60, 0, 149, 0, 125, 1, 17, 119, 70, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 35, 4, 200, 48, 62, //
  60, 0, 149, 0, 125, 1, 16, 102, 207, 62, //
  60, 0, 149, 0, 239, 4, 255, 254, 205, 46, 48, 58, 62, //
  60, 0, 149, 0, 125, 1, 15, 142, 185, 62, //
  60, 0, 144, 255, 255, 4, 58, 180, 92, 0, 131, 53, 62, //
  60, 0, 149, 0, 125, 1, 14, 159, 48, 62, //
  60, 0, 149, 0, 125, 1, 13, 173, 171, 62, //
  60, 0, 149, 0, 239, 4, 0, 1, 165, 97, 34, 125, 62, //
  60, 0, 149, 0, 125, 1, 12, 188, 34, 62, //
  60, 0, 149, 0, 125, 1, 11, 200, 157, 62, //
  60, 0, 149, 0, 125, 1, 10, 217, 20, 62, //
  60, 0, 149, 0, 239, 4, 0, 2, 48, 95, 114, 1, 62, //
  60, 0, 149, 0, 125, 1, 9, 235, 143, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 34, 10, 56, 150, 62, //
  60, 0, 149, 0, 125, 1, 8, 250, 6, 62, //
  60, 0, 149, 0, 125, 1, 7, 2, 241, 62, //
  60, 0, 144, 255, 255, 4, 76, 190, 92, 0, 225, 144, 62, //
  60, 0, 149, 0, 125, 1, 6, 19, 120, 62, //
  60, 0, 149, 0, 239, 4, 0, 2, 37, 37, 69, 245, 62, //
  60, 0, 149, 0, 125, 1, 5, 33, 227, 62, //
  60, 0, 149, 0, 125, 1, 4, 48, 106, 62, //
  60, 0, 149, 0, 125, 1, 3, 68, 213, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 5, 137, 191, 57, 62, //
  60, 0, 149, 0, 125, 1, 2, 85, 92, 62, //
  60, 0, 149, 0, 125, 1, 1, 103, 199, 62, //
  60, 0, 149, 0, 125, 1, 0, 118, 78, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 33, 16, 173, 37, 62, //
  60, 0, 149, 0, 239, 4, 0, 1, 94, 167, 25, 231, 62, //
  60, 0, 149, 0, 125, 1, 0, 118, 78, 62, //
  60, 0, 149, 0, 125, 1, 1, 103, 199, 62, //
  60, 0, 144, 255, 255, 4, 111, 200, 92, 0, 29, 15, 62, //
  60, 0, 149, 0, 125, 1, 2, 85, 92, 62, //
  60, 0, 149, 0, 125, 1, 3, 68, 213, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 9, 207, 50, 138, 62, //
  60, 0, 149, 0, 125, 1, 4, 48, 106, 62, //
  60, 0, 149, 0, 125, 1, 5, 33, 227, 62, //
  60, 0, 149, 0, 125, 1, 6, 19, 120, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 64, 123, 80, 91, 62, //
  60, 0, 149, 0, 125, 1, 7, 2, 241, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 32, 22, 209, 203, 62, //
  60, 0, 149, 0, 125, 1, 8, 250, 6, 62, //
  60, 0, 149, 0, 125, 1, 9, 235, 143, 62, //
  60, 0, 149, 0, 239, 4, 255, 254, 56, 229, 74, 85, 62, //
  60, 0, 149, 0, 125, 1, 10, 217, 20, 62, //
  60, 0, 144, 255, 255, 4, 163, 210, 92, 0, 71, 13, 62, //
  60, 0, 149, 0, 125, 1, 11, 200, 157, 62, //
  60, 0, 149, 0, 125, 1, 12, 188, 34, 62, //
  60, 0, 149, 0, 125, 1, 13, 173, 171, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 118, 205, 98, 148, 62, //
  60, 0, 149, 0, 125, 1, 14, 159, 48, 62, //
  60, 0, 149, 0, 125, 1, 15, 142, 185, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 31, 28, 75, 251, 62, //
  60, 0, 149, 0, 125, 1, 16, 102, 207, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 89, 77, 69, 70, 62, //
  60, 0, 149, 0, 125, 1, 17, 119, 70, 62, //
  60, 0, 149, 0, 125, 1, 18, 69, 221, 62, //
  60, 0, 144, 255, 255, 4, 185, 220, 92, 0, 72, 25, 62, //
  60, 0, 149, 0, 125, 1, 19, 84, 84, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 66, 43, 49, 110, 62, //
  60, 0, 149, 0, 125, 1, 20, 32, 235, 62, //
  60, 0, 149, 0, 125, 1, 21, 49, 98, 62, //
  60, 0, 149, 0, 125, 1, 22, 3, 249, 62, //
  60, 0, 149, 0, 125, 1, 23, 18, 112, 62, //
  60, 0, 149, 0, 239, 4, 0, 1, 191, 214, 139, 168, 62, //
  60, 0, 149, 0, 125, 1, 24, 234, 135, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 30, 34, 138, 222, 62, //
  60, 0, 149, 0, 125, 1, 25, 251, 14, 62, //
  60, 0, 149, 0, 125, 1, 26, 201, 149, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 86, 220, 67, 142, 62, //
  60, 0, 149, 0, 125, 1, 27, 216, 28, 62, //
  60, 0, 144, 255, 255, 4, 194, 230, 92, 0, 39, 157, 62, //
  60, 0, 149, 0, 125, 1, 28, 172, 163, 62, //
  60, 0, 149, 0, 125, 1, 29, 189, 42, 62, //
  60, 0, 149, 0, 239, 4, 0, 1, 137, 58, 68, 184, 62, //
  60, 0, 149, 0, 125, 1, 30, 143, 177, 62, //
  60, 0, 149, 0, 125, 1, 31, 158, 56, 62, //
  60, 0, 149, 0, 125, 1, 32, 87, 76, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 29, 40, 15, 236, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 101, 89, 15, 192, 62, //
  60, 0, 149, 0, 125, 1, 33, 70, 197, 62, //
  60, 0, 149, 0, 125, 1, 34, 116, 94, 62, //
  60, 0, 149, 0, 125, 1, 35, 101, 215, 62, //
  60, 0, 144, 255, 255, 4, 195, 240, 92, 0, 104, 106, 62, //
  60, 0, 149, 0, 125, 1, 36, 17, 104, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 199, 4, 25, 206, 62, //
  60, 0, 149, 0, 125, 1, 37, 0, 225, 62, //
  60, 0, 149, 0, 125, 1, 38, 50, 122, 62, //
  60, 0, 149, 0, 125, 1, 39, 35, 243, 62, //
  60, 0, 149, 0, 239, 4, 0, 0, 30, 134, 53, 214, 62, //
  60, 0, 149, 0, 125, 1, 40, 219, 4, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 28, 46, 115, 2, 62, //
  60, 0, 149, 0, 125, 1, 41, 202, 141, 62, //
  60, 0, 149, 0, 125, 1, 42, 248, 22, 62, //
  60, 0, 149, 0, 239, 4, 255, 254, 10, 105, 129, 35, 62, //
  60, 0, 149, 0, 125, 1, 43, 233, 159, 62, //
  60, 0, 149, 0, 125, 1, 44, 157, 32, 62, //
  60, 0, 144, 255, 255, 4, 213, 250, 92, 0, 147, 43, 62, //
  60, 0, 149, 0, 125, 1, 45, 140, 169, 62, //
  60, 0, 149, 0, 125, 1, 46, 190, 50, 62, //
  60, 0, 149, 0, 239, 4, 255, 253, 244, 59, 249, 200, 62, //
  60, 0, 149, 0, 125, 1, 47, 175, 187, 62, //
  60, 0, 149, 0, 125, 1, 48, 71, 205, 62, //
  60, 0, 149, 0, 125, 1, 49, 86, 68, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 27, 52, 129, 209, 62, //
  60, 0, 149, 0, 239, 4, 0, 1, 33, 55, 254, 98, 62, //
  60, 0, 149, 0, 125, 1, 50, 100, 223, 62, //
  60, 0, 149, 0, 125, 1, 51, 117, 86, 62, //
  60, 0, 149, 0, 125, 1, 52, 1, 233, 62, //
  60, 0, 144, 255, 255, 4, 211, 4, 93, 0, 93, 70, 62, //
  60, 0, 149, 0, 239, 4, 0, 1, 2, 242, 102, 152, 62, //
  60, 0, 149, 0, 125, 1, 53, 16, 96, 62, //
  60, 0, 149, 0, 125, 1, 54, 34, 251, 62, //
  60, 0, 149, 0, 125, 1, 55, 51, 114, 62, //
  60, 0, 149, 0, 125, 1, 56, 203, 133, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 6, 160, 41, 146, 62, //
  60, 0, 149, 0, 125, 1, 57, 218, 12, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 26, 58, 113, 119, 62, //
  60, 0, 144, 255, 255, 4, 175, 10, 93, 0, 128, 44, 62, //
  60, 0, 149, 0, 125, 1, 58, 232, 151, 62, //
  60, 0, 149, 0, 125, 1, 59, 249, 30, 62, //
  60, 0, 149, 0, 239, 4, 0, 1, 97, 239, 226, 193, 62, //
  60, 0, 149, 0, 125, 1, 60, 141, 161, 62, //
  60, 0, 149, 0, 125, 1, 61, 156, 40, 62, //
  60, 0, 149, 0, 125, 1, 62, 174, 179, 62, //
  60, 0, 144, 255, 255, 4, 139, 16, 93, 0, 139, 124, 62, //
  60, 0, 149, 0, 239, 4, 0, 1, 164, 236, 100, 72, 62, //
  60, 0, 149, 0, 125, 1, 63, 191, 58, 62, //
  60, 0, 149, 0, 125, 1, 64, 52, 74, 62, //
  60, 0, 149, 0, 125, 1, 65, 37, 195, 62, //
  60, 0, 149, 0, 174, 4, 0, 1, 25, 64, 135, 194, 62, //
  60, 0, 149, 0, 125, 1, 66, 23, 88, 62, //
  60, 0, 149, 0, 239, 4, 255, 255, 40, 214, 134, 0, 62, //
  60, 0, 149, 0, 125, 1, 67, 6, 209, 62, //
];
