import 'package:pixel_app_flutter/data/exceptions/base_exception.dart';

class StoreException extends BaseException {
  const StoreException({super.message}) : super(title: 'StoreException');

  const factory StoreException.write() = WriteStoreException;
}

class WriteStoreException extends StoreException {
  const WriteStoreException()
      : super(message: 'Unsuccessful attempt to write data to store');
}
