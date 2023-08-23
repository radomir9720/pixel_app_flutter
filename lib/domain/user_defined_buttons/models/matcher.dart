import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:re_seedwork/re_seedwork.dart';

sealed class Matcher<T> {
  const Matcher({
    required this.ifMatchers,
    required this.elseResult,
  });

  final List<ComparisonOperationMatcher<T>> ifMatchers;

  final T elseResult;

  Map<String, dynamic> toMap() {
    return {
      _ParseExtension.kIfMatchersKey:
          ifMatchers.map((e) => e.toMap(matcherResultToSting)).toList(),
      _ParseExtension.kElseResultKey: matcherResultToSting(elseResult),
    };
  }

  String matcherResultToSting(T result);
}

final class ColorMatcher extends Matcher<Color> {
  const ColorMatcher({
    required super.ifMatchers,
    required super.elseResult,
  });

  factory ColorMatcher.fromMap(Map<String, dynamic> map) {
    return ColorMatcher(
      ifMatchers: map.tryParseAndMapList<ComparisonOperationMatcher<Color>,
          Map<String, dynamic>>(
        _ParseExtension.kIfMatchersKey,
        (value) => ComparisonOperationMatcher.fromMap<Color>(
          value,
          _parseColor,
        ),
      ),
      elseResult: _parseColor(map.parseElseResult),
    );
  }

  static Color _parseColor(String serialized) => Color(int.parse(serialized));

  @override
  String matcherResultToSting(Color result) => '${result.value}';
}

class StringMatcher extends Matcher<String> {
  const StringMatcher({
    required super.ifMatchers,
    required super.elseResult,
  });

  factory StringMatcher.fromMap(Map<String, dynamic> map) {
    return StringMatcher(
      ifMatchers: map.tryParseAndMapList<ComparisonOperationMatcher<String>,
          Map<String, dynamic>>(
        _ParseExtension.kIfMatchersKey,
        (value) => ComparisonOperationMatcher.fromMap<String>(
          value,
          (result) => result,
        ),
      ),
      elseResult: map.parseElseResult,
    );
  }

  @override
  String matcherResultToSting(String result) => result;
}

extension _ParseExtension on Map<String, dynamic> {
  static const kIfMatchersKey = 'ifMatchers';
  static const kElseResultKey = 'elseResult';

  String get parseElseResult => parse(kElseResultKey);
}
