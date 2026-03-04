import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String _defaultWebViewerHost = String.fromEnvironment(
  'WEB_APP_HOST',
  defaultValue: 'localhost',
);

const String _webViewerUrl = String.fromEnvironment(
  'WEB_VIEWER_URL',
  defaultValue: 'http://$_defaultWebViewerHost:5173/gesture-recognition',
);

class GestureDetectionScreen extends StatefulWidget {
  const GestureDetectionScreen({super.key});

  @override
  State<GestureDetectionScreen> createState() => _GestureDetectionScreenState();
}

class _GestureDetectionScreenState extends State<GestureDetectionScreen>
    with WidgetsBindingObserver {
  static const int _maxRetriesPerUrl = 10;

  late final WebViewController _webViewController;
  late final List<Uri> _candidateUrls;
  int _loadingProgress = 0;
  int _activeUrlIndex = 0;
  int _mainFrameRetryCount = 0;
  bool _retryScheduled = false;
  String? _errorText;

  Uri get _activeUri => _candidateUrls[_activeUrlIndex];

  List<Uri> _buildCandidateUrls() {
    final urls = <Uri>[
      Uri.parse(_webViewerUrl),
      Uri.parse('http://localhost:5173/gesture-recognition'),
      Uri.parse('http://127.0.0.1:5173/gesture-recognition'),
    ];

    final seen = <String>{};
    final unique = <Uri>[];
    for (final uri in urls) {
      final key = uri.toString();
      if (seen.add(key)) {
        unique.add(uri);
      }
    }

    return unique;
  }

  void _loadCurrentUrl() {
    _webViewController.loadRequest(_activeUri);
  }

  Future<void> _handleMainFrameError() async {
    if (_retryScheduled) return;

    if (_mainFrameRetryCount < _maxRetriesPerUrl) {
      _retryScheduled = true;
      _mainFrameRetryCount += 1;
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      if (!mounted) {
        _retryScheduled = false;
        return;
      }
      _loadCurrentUrl();
      _retryScheduled = false;
      return;
    }

    if (_activeUrlIndex < _candidateUrls.length - 1) {
      setState(() {
        _activeUrlIndex += 1;
        _mainFrameRetryCount = 0;
        _errorText = null;
        _loadingProgress = 0;
      });
      _retryScheduled = true;
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      if (!mounted) {
        _retryScheduled = false;
        return;
      }
      _loadCurrentUrl();
      _retryScheduled = false;
      return;
    }

    setState(() {
      _errorText =
          'Unable to load web viewer. Ensure web client is running and adb reverse is active.';
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _candidateUrls = _buildCandidateUrls();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (!mounted) return;
            setState(() {
              _loadingProgress = progress;
            });
          },
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _errorText = null;
              _loadingProgress = 0;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() {
              _mainFrameRetryCount = 0;
              _retryScheduled = false;
              _loadingProgress = 100;
            });
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame != true) {
              return;
            }
            if (!mounted) return;
            unawaited(_handleMainFrameError());
          },
        ),
      )
      ..loadRequest(_activeUri);

    final platformController = _webViewController.platform;
    if (platformController is AndroidWebViewController) {
      platformController.setMediaPlaybackRequiresUserGesture(false);
      platformController.setOnPlatformPermissionRequest((request) {
        request.grant();
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _webViewController.reload();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gesture Detection'),
        actions: [
          IconButton(
            tooltip: 'Reload',
            onPressed: () {
              setState(() {
                _errorText = null;
                _loadingProgress = 0;
              });
              _webViewController.reload();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (_loadingProgress < 100)
            LinearProgressIndicator(value: _loadingProgress / 100.0),
          if (_errorText != null)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    _errorText!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Current URL: $_activeUri',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quick fix: run scripts/run_mobile_webview.ps1 to auto-start web app + adb reverse.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _errorText = null;
                        _loadingProgress = 0;
                        _mainFrameRetryCount = 0;
                        _activeUrlIndex = 0;
                      });
                      _loadCurrentUrl();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
