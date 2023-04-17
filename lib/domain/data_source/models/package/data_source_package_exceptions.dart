class DataSourcePackageException implements Exception {
  const DataSourcePackageException(this.message);

  final String message;

  @override
  String toString() {
    return 'DataSourcePackageException: $message';
  }
}

class NotEnoughBytesDataSourcePackageException
    extends DataSourcePackageException {
  const NotEnoughBytesDataSourcePackageException(int length)
      : super('Not enough bytes. Required at least 9. Received: $length');
}

class InvalidStartingByteDataSourcePackageException
    extends DataSourcePackageException {
  const InvalidStartingByteDataSourcePackageException()
      : super('Invalid starting byte');
}

class InvalidEndingByteDataSourcePackageException
    extends DataSourcePackageException {
  const InvalidEndingByteDataSourcePackageException(List<int> package)
      : super('Invalid ending byte. Package: $package');
}

class WrongCheckSumDataSourcePackageException
    extends DataSourcePackageException {
  const WrongCheckSumDataSourcePackageException({
    required List<int> packageCheckSum,
    required List<int> calculatedCheckSum,
    required List<int> body,
    required List<int> package,
  }) : super(
          'Wrong checkSum. Package checkSum: $packageCheckSum. '
          'Calculated checkSum: $calculatedCheckSum. '
          'Body: $body. '
          'Package: $package',
        );
}

class ParserNotFoundDataSourceIncomingPackageException
    extends DataSourcePackageException {
  const ParserNotFoundDataSourceIncomingPackageException(List<int> package)
      : super(
          'Package parser for incoming data source package not found.\n'
          'Package: $package',
        );
}
