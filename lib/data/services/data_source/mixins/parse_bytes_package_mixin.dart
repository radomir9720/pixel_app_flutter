import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

extension PopFirstExtension on List<int> {
  List<int> popFirst(int count) {
    if (length == 0 || count == 0) return const [];
    if (count >= length) {
      final buffer = [...this];
      clear();
      return buffer;
    }

    final buffer = sublist(0, count);
    removeRange(0, count);
    return buffer;
  }
}

typedef OnNewEventCallback = void Function(DataSourceIncomingEvent event);

mixin ParseBytesPackageMixin on DataSource {
  @protected
  @nonVirtual
  @visibleForTesting
  List<int> buffer = [];

  int get debouncerDurationMillis => 150;

  Debouncer? _debouncer;

  @protected
  @nonVirtual
  @visibleForTesting
  Debouncer get debouncer {
    return _debouncer ??= Debouncer(milliseconds: debouncerDurationMillis);
  }

  @protected
  @nonVirtual
  @visibleForTesting
  Future<void> get noBytesInBufferFuture =>
      noBytesInBufferCompleter?.future ?? Future.value();

  @protected
  @nonVirtual
  @visibleForTesting
  bool get noBytesInBuffer => noBytesInBufferCompleter?.isCompleted ?? true;

  @protected
  @nonVirtual
  @visibleForTesting
  Completer<void>? noBytesInBufferCompleter;

  @protected
  @nonVirtual
  @visibleForTesting
  void onNewPackage({
    required Uint8List rawPackage,
    required OnNewEventCallback onNewEventCallback,
  }) {
    observe(rawPackage);

    buffer.addAll(rawPackage);

    tryParse(onNewEventCallback);
  }

  @protected
  @nonVirtual
  @visibleForTesting
  void tryParse(OnNewEventCallback onNewEvent) {
    if (buffer.isEmpty) return;
    if (noBytesInBuffer) noBytesInBufferCompleter = Completer();

    const minimumPackageLength = 9;

    const startingByte = DataSourcePackage.startingByte;
    const endingByte = DataSourcePackage.endingByte;

    // Step 1
    // Check buffer lenght. Minimum length of a valid package is 9.
    // If the length is less than this value, do nothing(wait for more bytes).
    if (buffer.length < minimumPackageLength) return;

    // Step 2
    // If first byte is not starting,
    // then removing every byte until the starting one
    if (buffer.first != startingByte) {
      final indexOfStartingByte = buffer.indexOf(startingByte);

      // There is no starting byte in buffer yet
      // Clearing buffer
      if (indexOfStartingByte == -1) {
        buffer.removeRange(0, buffer.length);
        return;
      }

      // Starting byte was found
      // Removing every byte until starting byte(exclusive)
      buffer.popFirst(indexOfStartingByte);

      // Check the buffer lenght after popFirst() method.
      // If the length is less than minimum length, do nothing
      // (wait for more bytes).
      // ignore: invariant_booleans
      if (buffer.length < minimumPackageLength) return;
    }

    // Step 3
    // Check that buffer contains ending byte.
    // Otherwise do nothing(wait for more bytes)
    if (!buffer.contains(endingByte)) return;

    // Step 4
    // Checking buffer length
    // Correct bytes order:
    // 0 - starting byte
    // 1 - config byte 1
    // 2 - config byte 2
    // 3 - parameter id(first byte)
    // 4 - parameter id(second byte)
    // 5 - data length
    // 6+n - data
    // 6+n+1 - CRC sum(first byte)
    // 6+n+2 - CRC sum(second byte)
    // 6+n+3 - ending byte
    // So the ending byte should be at position bytes[5 + bytes[5] + 3]
    final indexOfPotentialEndingByte = 5 + buffer[5] + 3;
    // If length of the buffer is less than should be,
    // do nothing((wait for more bytes))
    if (indexOfPotentialEndingByte > buffer.length - 1) return;

    // Step 5
    // Check that ending byte is in the right position

    final potentialEndingByte = buffer[indexOfPotentialEndingByte];
    // If the ending byte is in the right position, then extracting the chunk
    // from buffer, parsing it, and adding to events stream
    if (potentialEndingByte == endingByte) {
      final package = buffer.popFirst(indexOfPotentialEndingByte + 1);
      final dataSourceEvent =
          DataSourceEvent.fromPackage(DataSourcePackage(package));
      // controller.sink.add(dataSourceEvent);
      onNewEvent(dataSourceEvent);
    } else {
      // If the ending byte was not found at the index where it should be,
      // then trying to find the next starting byte, and remove everything until
      // the new starting byte(exclusive)
      final indexOfStartingByte = buffer.sublist(1).indexOf(startingByte);

      // There is no starting byte in buffer yet
      // Clearing buffer
      if (indexOfStartingByte == -1) {
        buffer.removeRange(0, buffer.length);
        return;
      }

      // Starting byte was found
      // Removing every byte until starting byte(exclusive)
      // + 1 because above we took a sublist of buffer, which begins
      // from second item
      buffer.popFirst(indexOfStartingByte + 1);
    }

    if (buffer.isNotEmpty) {
      debouncer.run(() => tryParse(onNewEvent));
    } else {
      noBytesInBufferCompleter?.complete();
    }
  }

  @override
  Future<void> dispose() {
    _debouncer?.dispose();
    _debouncer = null;
    if (!noBytesInBuffer) {
      noBytesInBufferCompleter?.complete();
    }
    return super.dispose();
  }
}
