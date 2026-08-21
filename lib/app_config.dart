class AppConfig {
  const AppConfig._();

  static const String webAppUrl = String.fromEnvironment(
    'APP_URL',
    defaultValue: 'https://example.invalid/employee',
  );

  static Uri get webAppUri => Uri.parse(webAppUrl);

  static bool get hasValidWebAppUrl {
    final uri = Uri.tryParse(webAppUrl);

    return uri != null &&
        uri.hasAuthority &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host != 'example.invalid';
  }
}
