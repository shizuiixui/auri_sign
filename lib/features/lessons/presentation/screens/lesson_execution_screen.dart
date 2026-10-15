import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/config/api_constants.dart';
import 'package:auri_sign/features/lessons/presentation/viewmodels/category_view_model.dart';
import 'package:auri_sign/features/profile/viewmodels/streak_view_model.dart';
import 'package:auri_sign/features/profile/viewmodels/sound_settings_view_model.dart';
import 'package:auri_sign/core/utils/webview_audio_helper.dart';

class LessonExecutionScreen extends StatefulWidget {
  final String category;
  final String lessonId;
  final String userToken;

  const LessonExecutionScreen({
    super.key,
    required this.category,
    required this.lessonId,
    required this.userToken,
  });

  @override
  State<LessonExecutionScreen> createState() => _LessonExecutionScreenState();
}

class _LessonExecutionScreenState extends State<LessonExecutionScreen> {
  WebViewController? controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  @override
  void dispose() {
    controller?.loadRequest(Uri.parse('about:blank'));
    controller?.clearCache();
    super.dispose();
  }

  Future<void> _initWebView() async {
    await [Permission.camera, Permission.microphone].request();
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final String effectiveToken = widget.userToken.isNotEmpty
        ? widget.userToken
        : (prefs.getString('auth_token') ?? '');

    // Setup the target URL with the auth token parameter
    final String baseTargetUrl = ApiConstants.lessonWebviewUrl(
      widget.category,
      widget.lessonId,
    );
    final String targetUrl = "$baseTargetUrl#auth=$effectiveToken";
    final String targetPath = Uri.parse(baseTargetUrl).path;

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController webViewController =
        WebViewController.fromPlatformCreationParams(params);

    if (webViewController.platform is AndroidWebViewController) {
      final androidController =
          webViewController.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
      androidController.setOnPlatformPermissionRequest(
        (request) => request.grant(),
      );
    }

    // 🎯 This listens for messages from the React web app
    webViewController.addJavaScriptChannel(
      'FlutterChannel',
      onMessageReceived: (JavaScriptMessage message) {
        if (message.message == 'exit_lesson') {
          debugPrint(
              "🚪 Web requested exit. Fetching new data and closing Flutter screen.");

          if (mounted) {
            context.read<CategoryViewModel>().fetchAllCategoriesSummary();
            context.read<StreakViewModel>().fetchStreakInfo();

            if (Navigator.canPop(context)) {
              Navigator.pop(context); // Goes back to CategoryAlphabetsPage
            }
          }
        }
      },
    );

    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setUserAgent(
        "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Mobile Safari/537.36 AuriSignMobile",
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) {
              setState(() {
                _hasError = false;
                _errorMessage = '';
              });
            }

            webViewController.runJavaScript("""
              (function() {
                const hash = window.location.hash.substring(1);
                const urlParams = new URLSearchParams(hash);
                const token = urlParams.get('auth') || '$effectiveToken';
                if (token) {
                  localStorage.setItem('token', token);
                  localStorage.setItem('auth_token', token);
                  localStorage.setItem('sessionActivity', JSON.stringify({ token: token, at: Date.now() }));
                }
              })();
            """).catchError((_) {});
            _applyAudioSetting(webViewController);
          },
          onPageFinished: (url) {
            if (url == 'about:blank') return;

            webViewController.runJavaScript("""
              (function() {
                const token = '$effectiveToken';
                if (token) {
                  localStorage.setItem('token', token);
                  localStorage.setItem('auth_token', token);
                  localStorage.setItem('sessionActivity', JSON.stringify({ token: token, at: Date.now() }));
                }
                if (window.location.pathname.includes('/login') || window.location.pathname === '/') {
                  window.location.replace('$targetPath');
                }
              })();
            """).catchError((_) {});
            _applyAudioSetting(webViewController);

            if (!url.contains('/login') &&
                url != 'https://auri-sign-web.vercel.app/') {
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) setState(() => _isLoading = false);
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(
                "Lesson WebView Error: ${error.errorCode} - ${error.description}");
            if (error.isForMainFrame ?? true) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _hasError = true;
                  _errorMessage = error.description;
                });
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(targetUrl));

    if (mounted) setState(() => controller = webViewController);
  }

  void _applyAudioSetting(WebViewController ctrl) {
    if (!mounted) return;
    try {
      final isSoundEnabled =
          context.read<SoundSettingsViewModel>().isSoundEffectsEnabled;
      WebViewAudioHelper.applyAudioSetting(ctrl, isSoundEnabled);
    } catch (e) {
      debugPrint("Error applying webview audio setting: $e");
    }
  }

  void _handleBackPress() {
    controller?.runJavaScript("""
      (function() {
        const exitBtn = document.querySelector('button[aria-label="Exit or go back from lesson"]')
          || Array.from(document.querySelectorAll('button')).find(b =>
              b.innerText && (b.innerText.toLowerCase().includes('exit') || b.innerText.toLowerCase().includes('quit'))
          );
        if (exitBtn) {
          exitBtn.click();
        } else if (window.history.length > 1) {
          window.history.back();
        }
      })();
    """).catchError((_) {});
  }

  Widget _buildWebViewWidget() {
    if (controller == null) return const SizedBox.shrink();

    final PlatformWebViewWidgetCreationParams widgetParams;
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      widgetParams = AndroidWebViewWidgetCreationParams(
        controller: controller!.platform,
        displayWithHybridComposition: true,
      );
    } else {
      widgetParams = PlatformWebViewWidgetCreationParams(
        controller: controller!.platform,
      );
    }

    return WebViewWidget.fromPlatformCreationParams(params: widgetParams);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPress();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              if (controller != null) _buildWebViewWidget(),
              if (_isLoading)
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFFE9B63B)),
                  ),
                ),
              if (_hasError)
                Container(
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.wifi_off_rounded,
                            size: 64,
                            color: Color(0xFFE9B63B),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Unable to load lesson",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage.isNotEmpty
                                ? "Connection issue: $_errorMessage\nPlease check your internet and try again."
                                : "Please check your internet connection and try again.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE9B63B),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                                _hasError = false;
                              });
                              controller?.reload();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text(
                              "Try Again",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}