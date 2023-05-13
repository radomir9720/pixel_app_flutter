enum DataSourceRequestType {
  mirror(0x00),
  bufferRequest(0x01),
  canRequest(0x02),
  handshake(0x10),
  subscription(0x11),
  event(0x15);

  const DataSourceRequestType(this.value);

  final int value;

  static DataSourceRequestType fromInt(int value) {
    return DataSourceRequestType.values.firstWhere(
      (element) => element.value == value,
      orElse: () => throw Exception('Invalid request type: $value'),
    );
  }

  static bool isValid(int value) {
    return values.any((element) => element.value == value);
  }

  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? mirror,
    R Function()? bufferRequest,
    R Function()? canRequest,
    R Function()? handshake,
    R Function()? subscription,
    R Function()? event,
  }) {
    switch (this) {
      case DataSourceRequestType.mirror:
        return mirror?.call() ?? orElse();
      case DataSourceRequestType.bufferRequest:
        return bufferRequest?.call() ?? orElse();
      case DataSourceRequestType.canRequest:
        return canRequest?.call() ?? orElse();
      case DataSourceRequestType.handshake:
        return handshake?.call() ?? orElse();
      case DataSourceRequestType.subscription:
        return subscription?.call() ?? orElse();
      case DataSourceRequestType.event:
        return event?.call() ?? orElse();
    }
  }

  bool get isSubscription => this == DataSourceRequestType.subscription;
  bool get isEvent => this == DataSourceRequestType.event;
  bool get isHandshake => this == DataSourceRequestType.handshake;
  bool get isBufferRequest => this == DataSourceRequestType.bufferRequest;
}
