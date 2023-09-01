import 'package:equatable/equatable.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:re_seedwork/re_seedwork.dart';

/// Enum, that lists comparison operations
enum ComparisonOperation {
  /// Equality comparison(==)
  equalsTo,

  /// Less than comparison(<)
  lessThan,

  /// Grater than comparison(>)
  greaterThan,

  /// Less than or equal to comparison(<=)
  lessOrEqualTo,

  /// Greater than or equal to comparison(>=)
  greaterOrEqualTo,

  /// Not equal comparison(!=)
  notEqualsTo;

  /// Pattern matching function by enum value. Executes the corresponding to
  /// the value callback, and returns the result of it.
  T when<T>({
    required T Function() equalsTo,
    required T Function() lessThan,
    required T Function() geaterThan,
    required T Function() lessOrEqualTo,
    required T Function() greaterOrEqualTo,
    required T Function() notEqualsTo,
  }) {
    return switch (this) {
      ComparisonOperation.equalsTo => equalsTo(),
      ComparisonOperation.lessThan => lessThan(),
      ComparisonOperation.greaterThan => geaterThan(),
      ComparisonOperation.lessOrEqualTo => lessOrEqualTo(),
      ComparisonOperation.greaterOrEqualTo => greaterOrEqualTo(),
      ComparisonOperation.notEqualsTo => notEqualsTo(),
    };
  }

  static ComparisonOperation fromString(String name) {
    return ComparisonOperation.values.firstWhere(
      (element) => element.name == name,
    );
  }

  String toSign() {
    return when(
      equalsTo: () => '==',
      lessThan: () => '<',
      geaterThan: () => '>',
      lessOrEqualTo: () => '<=',
      greaterOrEqualTo: () => '>=',
      notEqualsTo: () => '!=',
    );
  }
}

class ComparisonOperationMatcher<T> with EquatableMixin {
  const ComparisonOperationMatcher({
    required this.operation,
    required this.value,
    required this.result,
    required this.parameters,
  });

  final ComparisonOperation operation;
  final int value;
  final PackageDataParameters parameters;
  final T result;

  static ComparisonOperationMatcher<T> fromMap<T>(
    Map<String, dynamic> map,
    T Function(String result) resultDeserializer,
  ) {
    return ComparisonOperationMatcher(
      operation: map.parseOperation,
      value: map.parseValue,
      result: resultDeserializer(map.parseResult),
      parameters: map.parseAndMap(
        _ParserExtension.kPackageDataParametersKey,
        PackageDataParameters.fromMap,
      ),
    );
  }

  Map<String, dynamic> toMap(String Function(T object) resultSerializer) {
    return {
      _ParserExtension.kOperationKey: operation.name,
      _ParserExtension.kValueKey: value,
      _ParserExtension.kResultKey: resultSerializer(result),
      _ParserExtension.kPackageDataParametersKey: parameters.toMap(),
    };
  }

  bool satisfies(int integer) {
    return operation.when(
      equalsTo: () => integer == value,
      lessThan: () => integer < value,
      geaterThan: () => integer > value,
      lessOrEqualTo: () => integer <= value,
      greaterOrEqualTo: () => integer >= value,
      notEqualsTo: () => integer != value,
    );
  }

  @override
  List<Object?> get props => [operation, value, result, parameters];
}

extension _ParserExtension on Map<String, dynamic> {
  static const kOperationKey = 'operation';

  static const kValueKey = 'value';

  static const kResultKey = 'result';

  static const kPackageDataParametersKey = 'packageDataParameters';

  ComparisonOperation get parseOperation {
    return parseAndMap(kOperationKey, ComparisonOperation.fromString);
  }

  int get parseValue => parse(kValueKey);

  String get parseResult => parse(kResultKey);
}
