import 'package:suprsync/core/utils/conn.dart';
import 'package:suprsync/core/utils/network_helper.dart';
import 'package:suprsync/core/utils/shared_preferences.dart';
import 'package:suprsync/models/shift_set.dart';

/// Reads and writes the signed-in user's shift set.
///
/// The API stores one JSON document per user:
/// `GET /shift-sets?userId=` and `POST /shift-sets`.
/// A local copy is written after a successful save. If the server does not
/// return a document, that copy is used so the prompt does not repeat.
class ShiftSetService {
  ShiftSetService({NetworkHelper? networkHelper})
      : _networkHelper = networkHelper ?? NetworkHelper();

  final NetworkHelper _networkHelper;

  Future<ShiftSet?> fetch({
    required String token,
    required String userId,
  }) async {
    final url = '$prodUrl/shift-sets?userId=${Uri.encodeQueryComponent(userId)}';
    ShiftSet? remote;
    try {
      final value = await _networkHelper.get(url, headers: _headers(token));
      remote = ShiftSet.tryParse(value, userId: userId);
    } catch (_) {
      remote = null;
    }
    if (remote != null) {
      await _writeCache(userId, remote);
      return remote;
    }
    return _readCache(userId);
  }

  Future<ShiftSet> save({
    required String token,
    required String userId,
    required ShiftSet shiftSet,
  }) async {
    final value = await _networkHelper.post(
      '$prodUrl/shift-sets',
      headers: _headers(token),
      body: shiftSet.toJson(),
    );
    final parsed = ShiftSet.tryParse(value, userId: userId) ?? shiftSet;
    await _writeCache(userId, parsed);
    return parsed;
  }

  Map<String, String> _headers(String token) => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  String _cacheKey(String userId) => 'shift_set_$userId';

  Future<void> _writeCache(String userId, ShiftSet shiftSet) {
    return saveDetails(_cacheKey(userId), shiftSet.toJson());
  }

  Future<ShiftSet?> _readCache(String userId) async {
    final value = await read(_cacheKey(userId));
    if (value is Map) {
      return ShiftSet.tryParse(Map<String, dynamic>.from(value), userId: userId);
    }
    return null;
  }
}
