import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: analytics);

  // Logga screen views
  Future<void> logScreenView(String screenName) async {
    await analytics.logScreenView(screenName: screenName);
  }

  // Logga login events
  Future<void> logLogin(String method) async {
    await analytics.logLogin(loginMethod: method);
  }

  // Logga signout
  Future<void> logLogout() async {
    await analytics.logEvent(name: 'logout');
  }

  // Custom events
  Future<void> logCustomEvent(
    String eventName, {
    Map<String, Object>? parameters,
  }) async {
    await analytics.logEvent(name: eventName, parameters: parameters);
  }
}
