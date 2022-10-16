enum DataSourceRequestType {
  mirror(0x00),
  bufferRequest(0x01),
  canRequest(0x02),
  handshake(0x10),
  subscription(0x11),
  valueUpdate(0x15);

  const DataSourceRequestType(this.value);

  final int value;
}
