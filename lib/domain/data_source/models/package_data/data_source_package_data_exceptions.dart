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
