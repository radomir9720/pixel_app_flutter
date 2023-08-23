part of '../user_defined_button.dart';

sealed class OneAxisJoystickUserDefinedButton
    extends OutgoingDirectionUserDefinedButton {
  const OneAxisJoystickUserDefinedButton({
    required super.id,
    required super.title,
    required this.onAxisMove,
    required this.onTap,
    required this.axisUpdatePeriodMillis,
  });

  final int axisUpdatePeriodMillis;

  final List<OutgoingPackageParameters> onAxisMove;

  final List<OutgoingPackageParameters> onTap;
}

final class YAxisJoystickUserDefinedButton
    extends OneAxisJoystickUserDefinedButton {
  const YAxisJoystickUserDefinedButton({
    required super.id,
    required super.title,
    required super.onAxisMove,
    required super.onTap,
    required super.axisUpdatePeriodMillis,
  });

  @override
  UserDefinedButtonSerializer<YAxisJoystickUserDefinedButton> get serializer =>
      const YAxisJoystickUserDefinedButtonSerializer();
}

final class XAxisJoystickUserDefinedButton
    extends OneAxisJoystickUserDefinedButton {
  const XAxisJoystickUserDefinedButton({
    required super.id,
    required super.title,
    required super.onAxisMove,
    required super.onTap,
    required super.axisUpdatePeriodMillis,
  });

  @override
  UserDefinedButtonSerializer<XAxisJoystickUserDefinedButton> get serializer =>
      const XAxisJoystickUserDefinedButtonSerializer();
}

abstract class OneAxisJoystickUserDefinedButtonSerializer<
        T extends OneAxisJoystickUserDefinedButton>
    extends UserDefinedButtonSerializer<T> {
  const OneAxisJoystickUserDefinedButtonSerializer(super.key);

  @override
  Map<String, dynamic> toMapInternal(OneAxisJoystickUserDefinedButton object) {
    return {
      _ParseExtension.kOnAxisMoveKey: object.onAxisMove.toMap(),
      MappersExtension.kOnTapKey: object.onTap.toMap(),
      _ParseExtension.kAxisUpdatePeriodMillisKey: object.axisUpdatePeriodMillis,
    };
  }
}

class YAxisJoystickUserDefinedButtonSerializer
    extends OneAxisJoystickUserDefinedButtonSerializer<
        YAxisJoystickUserDefinedButton> {
  const YAxisJoystickUserDefinedButtonSerializer() : super(kKey);

  static const kKey = 'YAxisJoystick';

  @override
  YAxisJoystickUserDefinedButton fromMap(Map<String, dynamic> map) {
    return YAxisJoystickUserDefinedButton(
      id: map.parseId,
      title: map.parseTitle,
      axisUpdatePeriodMillis: map.parseAxisUpdatePeriodMillis,
      onAxisMove: map.parseOnAxisMove,
      onTap: map.parseOnTap,
    );
  }
}

class XAxisJoystickUserDefinedButtonSerializer
    extends OneAxisJoystickUserDefinedButtonSerializer<
        XAxisJoystickUserDefinedButton> {
  const XAxisJoystickUserDefinedButtonSerializer() : super(kKey);

  static const kKey = 'XAxisJoystick';

  @override
  XAxisJoystickUserDefinedButton fromMap(Map<String, dynamic> map) {
    return XAxisJoystickUserDefinedButton(
      id: map.parseId,
      title: map.parseTitle,
      axisUpdatePeriodMillis: map.parseAxisUpdatePeriodMillis,
      onAxisMove: map.parseOnAxisMove,
      onTap: map.parseOnTap,
    );
  }
}

extension _ParseExtension on Map<String, dynamic> {
  static const kOnAxisMoveKey = 'onAxisMove';
  static const kAxisUpdatePeriodMillisKey = 'axisUpdatePeriodMillis';

  List<OutgoingPackageParameters> get parseOnAxisMove => tryParseAndMapList(
        kOnAxisMoveKey,
        OutgoingPackageParameters.fromMap,
      );

  int get parseAxisUpdatePeriodMillis => parse(kAxisUpdatePeriodMillisKey);
}
