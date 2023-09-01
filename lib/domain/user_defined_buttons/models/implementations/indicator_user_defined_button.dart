part of '../user_defined_button.dart';

@immutable
class IndicatorUserDefinedButton extends IncomingDirectionUserDefinedButton {
  const IndicatorUserDefinedButton({
    required super.id,
    required super.title,
    required this.incomingPackageGetter,
    this.colorMatcher,
    this.statusMatcher,
    this.numValueGetterParameters,
  }) : assert(
          colorMatcher != null ||
              statusMatcher != null ||
              numValueGetterParameters != null,
          'Either "colorMatcher", "statusMatcher" or '
          '"numValueGetterParameters" should be specified',
        );

  final IncomingPackageGetter incomingPackageGetter;

  final NumValueGetterParameters? numValueGetterParameters;

  final ColorMatcher? colorMatcher;

  final StringMatcher? statusMatcher;

  @override
  UserDefinedButtonSerializer<IndicatorUserDefinedButton> get serializer =>
      const IndicatorUserDefinedButtonSerializer();

  @override
  List<Object?> get props => [
        ...super.props,
        incomingPackageGetter,
        numValueGetterParameters,
        colorMatcher,
        statusMatcher,
      ];
}

@immutable
class NumValueGetterParameters with EquatableMixin {
  const NumValueGetterParameters({
    required this.parameters,
    this.multiplier,
    this.fractionDigits,
    this.suffix,
  });

  factory NumValueGetterParameters.fromMap(Map<String, dynamic> map) {
    return NumValueGetterParameters(
      multiplier: map.tryParse('multiplier'),
      fractionDigits: map.tryParse('fractionDigits'),
      parameters: map.parseAndMap('parameters', PackageDataParameters.fromMap),
      suffix: map.tryParse('suffix'),
    );
  }

  final double? multiplier;
  final int? fractionDigits;
  final PackageDataParameters parameters;
  final String? suffix;

  String? getNum(List<int> data) {
    final value = parameters.getInt(data);
    if (value == null) return null;
    final _multiplier = multiplier;
    if (_multiplier == null) return value.toString();
    final multiplied = value * _multiplier;
    final _fractionDigits = fractionDigits;
    if (_fractionDigits == null) return multiplied.toString();
    return multiplied.toStringAsFixed(_fractionDigits);
  }

  Map<String, dynamic> toMap() {
    return {
      'multiplier': multiplier,
      'fractionDigits': fractionDigits,
      'parameters': parameters.toMap(),
      'suffix': suffix,
    };
  }

  @override
  List<Object?> get props => [
        multiplier,
        fractionDigits,
        parameters,
        suffix,
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
      numValueGetterParameters: map.tryParseAndMap(
        'numValueGetterParameters',
        NumValueGetterParameters.fromMap,
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
      'numValueGetterParameters': object.numValueGetterParameters?.toMap(),
      'colorMatcher': object.colorMatcher?.toMap(),
      'statusMatcher': object.statusMatcher?.toMap(),
    };
  }
}
