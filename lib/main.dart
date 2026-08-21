import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RakaWebViewApp());
}

class RakaWebViewApp extends StatelessWidget {
  const RakaWebViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absensi Raka',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F172A)),
        useMaterial3: true,
      ),
      home: const AttendanceWebViewPage(),
    );
  }
}

class AttendanceWebViewPage extends StatefulWidget {
  const AttendanceWebViewPage({super.key});

  @override
  State<AttendanceWebViewPage> createState() => _AttendanceWebViewPageState();
}

class _AttendanceWebViewPageState extends State<AttendanceWebViewPage> {
  InAppWebViewController? _webViewController;
  double _progress = 0;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _requestDevicePermissions();
  }

  Future<void> _requestDevicePermissions() async {
    await [Permission.camera, Permission.locationWhenInUse].request();
  }

  Future<void> _reload() async {
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });

    await _webViewController?.reload();
  }

  Future<void> _openExternalUrl(Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!opened && mounted) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Link tidak dapat dibuka.';
      });
    }
  }

  bool _isInternalUrl(Uri uri) {
    final appUri = AppConfig.webAppUri;

    return uri.scheme == appUri.scheme && uri.host == appUri.host;
  }

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.hasValidWebAppUrl) {
      return const _ConfigurationErrorPage();
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }

        final canGoBack = await _webViewController?.canGoBack() ?? false;

        if (canGoBack) {
          await _webViewController?.goBack();
          return;
        }

        await SystemNavigator.pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(AppConfig.webAppUrl)),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  mediaPlaybackRequiresUserGesture: false,
                  allowsInlineMediaPlayback: true,
                  useHybridComposition: true,
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onPermissionRequest: (controller, request) async {
                  final statuses = await [
                    Permission.camera,
                    Permission.microphone,
                  ].request();

                  final granted = statuses.values.every(
                    (status) => status.isGranted,
                  );

                  return PermissionResponse(
                    resources: request.resources,
                    action: granted
                        ? PermissionResponseAction.GRANT
                        : PermissionResponseAction.DENY,
                  );
                },
                onGeolocationPermissionsShowPrompt: (controller, origin) async {
                  final status = await Permission.locationWhenInUse.request();

                  return GeolocationPermissionShowPromptResponse(
                    origin: origin,
                    allow: status.isGranted,
                    retain: false,
                  );
                },
                shouldOverrideUrlLoading: (controller, action) async {
                  final url = action.request.url;

                  if (url == null) {
                    return NavigationActionPolicy.CANCEL;
                  }

                  if (url.scheme == 'tel' ||
                      url.scheme == 'mailto' ||
                      url.scheme == 'intent') {
                    await _openExternalUrl(url);
                    return NavigationActionPolicy.CANCEL;
                  }

                  if (!_isInternalUrl(url)) {
                    await _openExternalUrl(url);
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onProgressChanged: (controller, progress) {
                  if (mounted) {
                    setState(() => _progress = progress / 100);
                  }
                },
                onLoadStart: (controller, url) {
                  if (mounted) {
                    setState(() => _hasError = false);
                  }
                },
                onReceivedError: (controller, request, error) {
                  if (!request.isForMainFrame || !mounted) {
                    return;
                  }

                  setState(() {
                    _hasError = true;
                    _errorMessage =
                        'Halaman absensi gagal dimuat. Periksa internet atau URL server.';
                  });
                },
                onReceivedHttpError: (controller, request, errorResponse) {
                  if (!request.isForMainFrame ||
                      errorResponse.statusCode < 400 ||
                      !mounted) {
                    return;
                  }

                  setState(() {
                    _hasError = true;
                    _errorMessage =
                        'Server mengembalikan HTTP ${errorResponse.statusCode}. Coba lagi beberapa saat.';
                  });
                },
              ),
              if (_progress < 1 && !_hasError)
                LinearProgressIndicator(value: _progress),
              if (_hasError)
                _WebViewError(
                  message: _errorMessage,
                  onRetry: _reload,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebViewError extends StatelessWidget {
  const _WebViewError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 52),
              const SizedBox(height: 16),
              const Text(
                'Tidak dapat membuka absensi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => onRetry(),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfigurationErrorPage extends StatelessWidget {
  const _ConfigurationErrorPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'APP_URL belum dikonfigurasi. Jalankan aplikasi dengan '
            '--dart-define=APP_URL=https://domain-kamu/employee',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
