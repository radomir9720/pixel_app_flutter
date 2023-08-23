part of '../user_defined_button.dart';

class SendPackagesUserDefinedButton extends OutgoingDirectionUserDefinedButton {
  SendPackagesUserDefinedButton({
    required super.id,
    required super.title,
    required this.onTap,
  });

  final List<OutgoingPackageParameters> onTap;

  @override
  UserDefinedButtonSerializer<SendPackagesUserDefinedButton> get serializer =>
      const SendPackagesUserDefinedButtonSerializer();
}

class SendPackagesUserDefinedButtonSerializer
    extends UserDefinedButtonSerializer<SendPackagesUserDefinedButton> {
  const SendPackagesUserDefinedButtonSerializer() : super(kKey);

  @protected
  static const kKey = 'OneDirectionButton';

  @override
  SendPackagesUserDefinedButton fromMap(Map<String, dynamic> map) {
    return SendPackagesUserDefinedButton(
      id: map.parseId,
      title: map.parseTitle,
      onTap: map.parseOnTap,
    );
  }

  @override
  Map<String, dynamic> toMapInternal(SendPackagesUserDefinedButton object) {
    return {
      MappersExtension.kOnTapKey: object.onTap.toMap(),
    };
  }
}
