part of '../user_defined_button.dart';

class IndicatorUserDefinedButton extends IncomingDirectionUserDefinedButton {
  IndicatorUserDefinedButton({
    required super.id,
    required super.title,
    required this.incomingPackageGetter,
    this.colorMatcher,
    this.statusMatcher,
  }) : assert(
          colorMatcher != null || statusMatcher != null,
          'Either "colorMatcher" or "statusMatcher" should be specified',
        );

  final IncomingPackageGetter incomingPackageGetter;

  final ColorMatcher? colorMatcher;

  final StringMatcher? statusMatcher;

  @override
  UserDefinedButtonSerializer<IndicatorUserDefinedButton> get serializer =>
      const IndicatorUserDefinedButtonSerializer();

  @override
  List<Object?> get props => [
        ...super.props,
        incomingPackageGetter,
        colorMatcher,
        statusMatcher,
      ];
}

class IndicatorUserDefinedButtonSerializer
    extends UserDefinedButtonSerializer<IndicatorUserDefinedButton> {
  const IndicatorUserDefinedButtonSerializer() : super(kKey);

  static const kKey = 'indicator';

  @override
  IndicatorUserDefinedButton fromMap(Map<String, dynamic> map) {
    return IndicatorUserDefinedButton(
      id: map.parseId,
      title: map.parseTitle,
      incomingPackageGetter: map.parseAndMap(
        'incomingPackageGetter',
        IncomingPackageGetter.fromMap,
      ),
      colorMatcher: map.tryParseAndMap(
        'colorMatcher',
        ColorMatcher.fromMap,
      ),
      statusMatcher: map.tryParseAndMap(
        'statusMatcher',
        StringMatcher.fromMap,
      ),
    );
  }

  @override
  Map<String, dynamic> toMapInternal(IndicatorUserDefinedButton object) {
    return {
      'title': object.title,
      'incomingPackageGetter': object.incomingPackageGetter.toMap(),
      'colorMatcher': object.colorMatcher?.toMap(),
      'statusMatcher': object.statusMatcher?.toMap(),
    };
  }
}
