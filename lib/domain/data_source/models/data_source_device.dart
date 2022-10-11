import 'package:meta/meta.dart';

@immutable
class DataSourceDevice {
  const DataSourceDevice({
    this.name,
    required this.address,
    required this.isBonded,
  });

  final String? name;
  final String address;
  final bool isBonded;

  @override
  bool operator ==(dynamic other) {
    return other is DataSourceDevice &&
        name == other.name &&
        address == other.address &&
        isBonded == other.isBonded;
  }

  @override
  int get hashCode => Object.hash(name, address, isBonded);
}
