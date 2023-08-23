import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'implementations/indicator_user_defined_button.dart';
part 'implementations/one_axis_joystick_user_defined_button.dart';
part 'implementations/send_packages_user_defined_button.dart';

sealed class UserDefinedButton with EquatableMixin {
  const UserDefinedButton({
    required this.id,
    required this.title,
  });

  final String title;

  final int id;

  UserDefinedButtonSerializer get serializer;

  Map<String, dynamic> get toMap => serializer.toMap(this);

  R when<R>({
    required R Function(IndicatorUserDefinedButton button) indicator,
    required R Function(YAxisJoystickUserDefinedButton button) yAxisJoystick,
    required R Function(XAxisJoystickUserDefinedButton button) xAxisJoystick,
    required R Function(SendPackagesUserDefinedButton button)
        sendPackagesButton,
  }) {
    return switch (this) {
      (final IndicatorUserDefinedButton b) => indicator(b),
      (final YAxisJoystickUserDefinedButton b) => yAxisJoystick(b),
      (final XAxisJoystickUserDefinedButton b) => xAxisJoystick(b),
      (final SendPackagesUserDefinedButton b) => sendPackagesButton(b),
    };
  }

  @override
  List<Object?> get props => [title, id];
}

sealed class OutgoingDirectionUserDefinedButton extends UserDefinedButton {
  const OutgoingDirectionUserDefinedButton({
    required super.id,
    required super.title,
  });
}

sealed class IncomingDirectionUserDefinedButton extends UserDefinedButton {
  const IncomingDirectionUserDefinedButton({
    required super.id,
    required super.title,
  });
}

sealed class TwoDirectionsUserDefinedButton extends UserDefinedButton {
  const TwoDirectionsUserDefinedButton({
    required super.id,
    required super.title,
  });
}

sealed class UserDefinedButtonSerializer<T extends UserDefinedButton>
    with EquatableMixin {
  const UserDefinedButtonSerializer(this.key);

  final String key;

  T fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap(T object) {
    return <String, dynamic>{
      'key': key,
      'id': object.id,
      'title': object.title,
      ...toMapInternal(object),
    };
  }

  @protected
  Map<String, dynamic> toMapInternal(T object);

  @override
  List<Object?> get props => [key];
}

extension MappersExtension on Map<String, dynamic> {
  int get parseId => parse('id');
  String get parseKey => parse('key');
  String get parseTitle => parse('title');
  int get parseRequestType => parse('requestType');
  int get parseParameterId => parse('parameterId');
  List<int> get parseData => tryParseList('data');

  static const kOnTapKey = 'onTap';

  List<OutgoingPackageParameters> get parseOnTap => tryParseAndMapList(
        kOnTapKey,
        OutgoingPackageParameters.fromMap,
      );
}
