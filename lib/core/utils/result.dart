
// Utitlity class that simplifies handling errors
//
//Return a Result to indicate if success of failure
//
// A Result is either an OK with a value of type T
// Or an Error with an exception 

/// Use [Result.ok] to create a successful result with a value of type [T].
/// Use [Result.error] to create an error result with an [Exception].




sealed class Result<T> {
  const Result();

   factory Result.ok(T value) => Ok(value);

   factory Result.error(Exception error) => Error(error);
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

final class Error<T> extends Result<T> {
  const Error(this.error);

  final Exception error;
}
