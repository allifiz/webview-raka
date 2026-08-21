import 'package:flutter_test/flutter_test.dart';
import 'package:raka_webview/app_config.dart';

void main() {
  test('default APP_URL is intentionally invalid', () {
    expect(AppConfig.hasValidWebAppUrl, isFalse);
  });

  test('web app URL has a parseable URI', () {
    expect(AppConfig.webAppUri.scheme, isNotEmpty);
  });
}
