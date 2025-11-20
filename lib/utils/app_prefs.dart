import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefsKeys {
  static const anchor = 'anchor';
  static const summaryCount = 'summaryCount';
}

class AppPrefsDefaults {
  static const anchor = '앵커 미설정';
  static const summaryCount = 5;
}

/// 앱 prefs ValueNotifier 상태 (UI 연동용)
class AppPrefsState {
  static late final ValueNotifier<String> anchor;
  static late final ValueNotifier<int> summaryCount;
}

/// 정적 prefs 유틸: 인스턴스 생성 금지 (오용 방지)
class AppPrefs {
  AppPrefs._();

  static SharedPreferences? _prefs;

  /// 앱 시작 시 1회 초기화
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    final savedAnchor = _prefs!.getString(AppPrefsKeys.anchor);
    final savedSummaryCount = _prefs!.getInt(AppPrefsKeys.summaryCount);

    AppPrefsState.anchor = ValueNotifier<String>(
      savedAnchor ?? AppPrefsDefaults.anchor,
    );
    AppPrefsState.summaryCount = ValueNotifier<int>(
      savedSummaryCount ?? AppPrefsDefaults.summaryCount,
    );
  }

  /// 값 저장
  static Future<void> set(String key, Object value) async {
    final p = _prefs!;
    switch (value) {
      case int v:
        await p.setInt(key, v);
        break;
      case bool v:
        await p.setBool(key, v);
        break;
      case double v:
        await p.setDouble(key, v);
        break;
      case String v:
        await p.setString(key, v);
        break;
      case List<String> v:
        await p.setStringList(key, v);
        break;
      default:
        break;
    }

    /// ValueNotifier 동기화
    switch (key) {
      case AppPrefsKeys.anchor:
        AppPrefsState.anchor.value = value as String;
        break;
      case AppPrefsKeys.summaryCount:
        AppPrefsState.summaryCount.value = value as int;
        break;
    }
  }

  /// 값 조회 (없으면 null)
  /// ValueNotifier 도입으로 더 이상 사용하지 않음
  // static T? get<T>(String key) {
  //   return _prefs!.get(key) as T?;
  // }

  /// 키 삭제
  static Future<void> remove(String key) async {
    await _prefs!.remove(key);

    /// 삭제 시 기본값으로 되돌리기
    switch (key) {
      case AppPrefsKeys.anchor:
        AppPrefsState.anchor.value = AppPrefsDefaults.anchor;
        break;
      case AppPrefsKeys.summaryCount:
        AppPrefsState.summaryCount.value = AppPrefsDefaults.summaryCount;
        break;
    }
  }
}
