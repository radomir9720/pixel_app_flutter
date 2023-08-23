// ignore_for_file: avoid_positional_boolean_parameters

abstract class BaseException implements Exception {
  const BaseException({
    required this.title,
    this.message,
  });

  final String title;

  final Object? message;

  void throwIf(bool predicate) {
    if (predicate) throw this;
  }

  void throwIfNot(bool predicate) => throwIf(!predicate);

  @override
  String toString() {
    if (message == null) return title;
    return '$title: $message';
  }
}
