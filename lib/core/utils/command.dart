import 'package:flutter/foundation.dart';

class Command extends ChangeNotifier {
  Command(this._action);

  Future<void> Function() _action;

  bool _running = false;
  bool get running => _running;

  Exception? _error;
  Exception? get error => _error;

  bool _completed = false;
  bool get completed => _completed;

  void execute() async {
    if (running) return;

    _running = true;
    _completed = false;
    _error = null;

    notifyListeners();

    try {
      await _action();
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
  }
}





