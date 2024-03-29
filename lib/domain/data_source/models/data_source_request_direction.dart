enum DataSourceRequestDirection {
  outgoing(0),
  incoming(1);

  const DataSourceRequestDirection(this.value);
  final int value;

  static DataSourceRequestDirection fromInt(int value) {
    return DataSourceRequestDirection.values.firstWhere(
      (element) => element.value == value,
    );
  }

  bool get isOutgoing => this == DataSourceRequestDirection.outgoing;
  bool get isIncoming => this == DataSourceRequestDirection.incoming;

  R when<R>({
    required R Function() outgoing,
    required R Function() incoming,
  }) {
    switch (this) {
      case DataSourceRequestDirection.incoming:
        return incoming();
      case DataSourceRequestDirection.outgoing:
        return outgoing();
    }
  }
}
