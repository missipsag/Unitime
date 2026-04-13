import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:unitime/core/utils/exceptions.dart';
import 'package:unitime/core/utils/result.dart';

class StorageService {
  static final StorageService _shared = StorageService._sharedInstance();

  StorageService._sharedInstance();

  factory StorageService() => _shared;

  final _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(),
    webOptions: WebOptions.defaultOptions,
  );

  Future<Result<void>> write(String key, String value) async {
    try {
      await _storage
          .write(key: key, value: value)
          .catchError((e) => throw Exception(e));
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> delete(String key) async {
    try {
      await _storage.delete(key: key).catchError((e) => throw Exception(e));
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String>> read(String key) async {
    try {
      final value = await _storage
          .read(key: key)
          .catchError((e) => throw Exception(e));
      if (value != null) {
        return Result.ok(value);
      } else {
        return Result.error(
          NoValueAssociatedWithKeyException("No value associated with $key."),
        );
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
