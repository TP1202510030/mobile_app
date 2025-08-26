sealed class Result<T> {
  const Result();

  /// Creates a successful [Result], completed with the specified [value].
  const factory Result.success(T value) = Success._;

  /// Creates an error [Result], completed with the specified [error].
  const factory Result.error(Exception error) = Error._;
}

/// Subclass of Result for values
final class Success<T> extends Result<T> {
  const Success._(this.value);

  /// Returned value in result
  final T value;

  @override
  String toString() => 'Result<$T>.success($value)';
}

/// Subclass of Result for errors
final class Error<T> extends Result<T> {
  const Error._(this.error);

  /// Returned error in result
  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}

/// Extension that adds functional 'when' handling to the [Result] class.
/// Allows executing a callback for the success or error case asynchronously
extension ResultWhen<T> on Result<T> {
  Future<Result<U>> when<U>({
    required Future<Result<U>> Function(T value) success,
    required Result<U> Function(Exception error) error,
  }) async {
    switch (this) {
      case Success<T>(value: final v):
        return success(v);
      case Error<T>(error: final e):
        return error(e);
    }
  }
}
