import 'package:flutter/foundation.dart';
import 'package:unitime/core/utils/result.dart';

// Define a [Command action] that returns a [Result] of type [T]
// Used by [Command0] that tkes no arguments.
typedef CommandAction0<T> = Future<Result<T>> Function();

// Define a [Command action] that returns a Result of type [T]
// Used by [Command1] that takes one argument of type [A]
typedef CommandAction1<T, A> = Future<Result<T>> Function(A);

// Define a [Command action] that returns a Result of type [T]
// Used by [Command2] that takes two arguments the first of type [A], the second of type [B]
typedef CommandAction2<T, A, B> = Future<Result<T>> Function(A, B);

// Define a [Command action] that returns a Result of type [T]
// Used by [Command3] that takes three arguments the first of type [A], the second of type [B], the third of type [C]
typedef CommandAction3<T, A, B, C> = Future<Result<T>> Function(A, B, C);

// Define a [Command action] that returns a Result of type [T]
// Used by [Command4] that takes two arguments the first of type [A], the second of type [B], the Third of type [C], the fourth of type [D]
typedef CommandAction4<T, A, B, C, D> = Future<Result<T>> Function(A, B, C, D);

abstract class Command<T> extends ChangeNotifier {
  bool _running = false;
  bool get running => _running;

  Exception? _error;
  Exception? get error => _error;

  bool _completed = false;
  bool get completed => _completed;

  Future<void> _execute(CommandAction0<T> action) async {
    if (running) return;

    _running = true;
    _completed = false;
    _error = null;

    notifyListeners();

    try {
      await action();
      _completed = true;
    } on Exception catch (e) {
      _error = e;
    } finally {
      _running = false;
      notifyListeners();
    }
  }

  void clear() {
    _running = false;
    _completed = false;
    _error = null;
    notifyListeners();
  }
}

final class Command0<T> extends Command<T> {
  Command0(this._action);

  final CommandAction0<T> _action;

  Future<void> execute() async {
    await _execute(_action);
  }
}

final class Command1<T, A> extends Command<T> {
  Command1(this._action);

  final CommandAction1<T, A> _action;

  Future<void> execute(A arg) async {
    await _execute(() => _action(arg));
  }
}

final class Command2<T, A, B> extends Command<T> {
  Command2(this._action);

  final CommandAction2<T, A, B> _action;

  Future<void> execute(A arg1, B arg2) async {
    await _execute(() => _action(arg1, arg2));
  }
}

final class Command3<T, A, B, C> extends Command<T> {
  Command3(this._action);

  final CommandAction3<T, A, B, C> _action;

  Future<void> execute(A arg1, B arg2, C arg3) async {
    await _execute(() => _action(arg1, arg2, arg3));
  }
}

final class Command4<T, A, B, C, D> extends Command<T> {
  Command4(this._action);

  final CommandAction4<T, A, B, C, D> _action;

  Future<void> execute(A arg1, B arg2, C arg3, D arg4) async {
    await _execute(() => _action(arg1, arg2, arg3, arg4));
  }
}
