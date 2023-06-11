class DataSourcePackageDataException implements Exception {
  const DataSourcePackageDataException(this.message);

  final String message;

  @override
  String toString() {
    return 'DataSourcePackageDataException: $message';
  }
}

class ShouldNotBeCalledDataSourcePackageDataException
    extends DataSourcePackageDataException {
  const ShouldNotBeCalledDataSourcePackageDataException(
    String name, [
    String? reason,
  ]) : super('This method/getter/setter should not be called: "$name".'
            '${reason == null ? '' : '\nReason: $reason'}');
}

class FromBytesShouldNotBeCalledDataSourcePackageDataException
    extends ShouldNotBeCalledDataSourcePackageDataException {
  const FromBytesShouldNotBeCalledDataSourcePackageDataException(
    String className,
  ) : super(
          '$className.fromBytes()',
          '$className is intended to be used only for outgoing packages, '
              'therefore only toBytes() method can be used',
        );
}

class UnexpectedFunctionIdDataSourcePackageDataException
    extends DataSourcePackageDataException {
  const UnexpectedFunctionIdDataSourcePackageDataException({
    required int? functionId,
    required List<int> expected,
    required List<int> package,
  }) : super(
          'Unexpected function id: $functionId.\n'
          'Expected: $expected.\n'
          'Package: $package',
        );
}
