import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:unitime/core/utils/result.dart';

class StorageService {
  static final StorageService _shared = StorageService._sharedInstance();

  StorageService._sharedInstance();

  factory StorageService() => _shared;

  final _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(),
  );

  Future<Result<void>> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> delete(String key) async {
    try {
      await _storage.delete(key: key);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String>> read(String key) async {
    try {
      final value = await _storage.read(key: key);
      if (value != null) {
        return Result.ok(value);
      } else {
        return Result.error(Exception("No value associated with $key."));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
