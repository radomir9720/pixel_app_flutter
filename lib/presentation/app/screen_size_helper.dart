// ignore_for_file: dead_null_aware_expression

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

extension ShortCutExtensions on num {
  double get si => SizeProvider.instance.sizeConverter.si(this);

  double get fo => SizeProvider.instance.sizeConverter.fo(this);
}

@immutable
class SizeConverter with EquatableMixin {
  const SizeConverter({
    required this.fo,
    required this.si,
  });

  const factory SizeConverter.original() = _OriginalSizeConverter;

  final double Function<T extends num>(T original) fo;

  final double Function<T extends num>(T original) si;

  @override
  List<Object?> get props => [fo, si];
}

class _OriginalSizeConverter extends SizeConverter {
  const _OriginalSizeConverter()
      : super(
          fo: _returnOriginal,
          si: _returnOriginal,
        );

  static double _returnOriginal<T extends num>(T original) {
    return original.toDouble();
  }
}

@immutable
class SizeProvider {
  const SizeProvider._(this.sizeConverter);
  final SizeConverter sizeConverter;

  static SizeProvider? _instance;

  // ignore: prefer_constructors_over_static_methods
  static SizeProvider get instance {
    return _instance ??= const SizeProvider._(SizeConverter.original());
  }

  static void initialize({
    SizeConverter sizeConverter = const SizeConverter.original(),
  }) {
    if (_instance != null) {
      throw Exception('SizeProvider already was initialized');
    }
    _instance = SizeProvider._(sizeConverter);
  }
}
