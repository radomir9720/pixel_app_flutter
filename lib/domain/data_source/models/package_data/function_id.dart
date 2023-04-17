enum FunctionId {
  /// ID of function, that requests a value through CAN
  requestValue(0x11),

  /// ID of function, that sets a value(ex: lights brightness).
  setValueWithParam(0x01),

  /// ID, saying that value was set successfuly.
  /// This id comes as result of [setValueWithParam]
  successSetValueWithParam(0x41),

  /// ID, saying that value request was successful.
  /// This id comes as result of [requestValue]
  successRequestValue(0x51),

  /// ID, saying that was received a value we subscribed for, and the value
  /// is "normal"(ex: the temperature of the battery is in the normal bounds)
  okIncomingPeriodicValue(okIncomingPeriodicValueId),

  /// ID, saying that was received a value we subscribed for, and the value
  /// is not "normal", but also is not critical yet(ex: the temperature of
  /// the battery is higher that we expected, but not critical)
  warningIncomingPeriodicValue(warningIncomingPeriodicValueId),

  /// ID, saying that was received a value we subscribed for, and the value
  /// is "critical"(ex: the temperature of the battery is too high)
  criticalIncomingPeriodicValue(criticalIncomingPeriodicValueId),

  /// ID, saying that an error was encountered while setting a value,
  /// This id comes as result of [setValueWithParam].
  errorSettingValueWithParam(0xC1),

  /// ID, saying that an error was encountered while requesting a value,
  /// This id comes as result of [requestValue].
  errorRequestingValue(0xD1),

  /// ID, saying that an error was encountered while ending an event from the
  /// L2 level
  errorEvent(0xE6);

  const FunctionId(this.value);

  final int value;

  static FunctionId fromValue(int value) {
    return FunctionId.values.firstWhere((element) => element.value == value);
  }

  static const okIncomingPeriodicValueId = 0x61;
  static const warningIncomingPeriodicValueId = 0x62;
  static const criticalIncomingPeriodicValueId = 0x63;
}
