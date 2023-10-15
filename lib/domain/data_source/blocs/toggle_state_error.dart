sealed class ToggleStateError {
  const ToggleStateError();

  const factory ToggleStateError.differs({
    required bool first,
    required bool second,
  }) = _StatesDiffersEnablingError;

  const factory ToggleStateError.timeout() = _TimeoutEnablingError;
  const factory ToggleStateError.mainECUError() = _MainECUEnablingError;

  bool get isTimeout => this is _TimeoutEnablingError;
  bool get differs => this is _StatesDiffersEnablingError;
  bool get mainECUError => this is _MainECUEnablingError;

  R when<R>({
    required R Function() differs,
    required R Function() timeout,
    required R Function() mainECUError,
  }) {
    return switch (this) {
      _StatesDiffersEnablingError() => differs(),
      _TimeoutEnablingError() => timeout(),
      _MainECUEnablingError() => mainECUError(),
    };
  }
}

final class _StatesDiffersEnablingError extends ToggleStateError {
  const _StatesDiffersEnablingError({
    required this.first,
    required this.second,
  });

  final bool first;
  final bool second;
}

final class _TimeoutEnablingError extends ToggleStateError {
  const _TimeoutEnablingError();
}

final class _MainECUEnablingError extends ToggleStateError {
  const _MainECUEnablingError();
}
