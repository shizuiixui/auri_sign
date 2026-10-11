import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:auri_sign/config/api_constants.dart';
import 'package:auri_sign/core/di/injection_container.dart' as di;
import 'package:auri_sign/core/utils/webview_audio_helper.dart';
import 'package:auri_sign/features/profile/viewmodels/sound_settings_view_model.dart';

class GestureWebviewScreen extends StatefulWidget {
  final String userToken;

  const GestureWebviewScreen({super.key, required this.userToken});

  @override
  State<GestureWebviewScreen> createState() => _GestureWebviewScreenState();
}

class _GestureWebviewScreenState extends State<GestureWebviewScreen> {
  WebViewController? controller;
  bool _isLoading = true;

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

  // CSS Injection
  void _injectCSS(WebViewController controller) {
    const String css = """
      /* Hide standard web layout and UI components immediately */
      nav, header, footer, .navbar, .bottom-nav, .sidebar, 
      .badge, .streak-container, [class*='badge'], [class*='streak'] { 
        display: none !important; 
        visibility: hidden !important;
        height: 0px !important;
        pointer-events: none !important;
        opacity: 0 !important;
      }
      
      .container-fluid, .container {
        padding: 0 !important;
        margin: 0 !important;
      }
      
      body {
        background-color: #fff !important; 
        overflow-x: hidden;
      }
    """;

    controller.runJavaScript("""
      (function() {
        function injectMobileStyles() {
          if (!document.getElementById('injected-mobile-css')) {
            var style = document.createElement('style');
            style.id = 'injected-mobile-css';
            style.innerHTML = `$css`;
            document.head.appendChild(style);
          }
        }

        // 1. Inject immediately on load
        injectMobileStyles();

        // 2. Watch for the web app wiping out the head or re-rendering
        var observer = new MutationObserver(function(mutations) {
          injectMobileStyles();
        });
        
        // Target the whole document to catch any routing changes
        observer.observe(document.documentElement, { 
          childList: true, 
          subtree: true 
        });
      })();
    """);
  }

  Future<void> _initWebView() async {
    await [Permission.camera, Permission.microphone].request();

    final String baseTargetUrl = ApiConstants.gestureWebviewUrl;
    final String targetUrl = "$baseTargetUrl#auth=${widget.userToken}";

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
      androidController.setOnPlatformPermissionRequest((request) {
        request.grant();
      });
    }

    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setUserAgent(
        "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Mobile Safari/537.36",
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            webViewController.runJavaScript("""
              (function() {
                const token = '${widget.userToken}';
                if (token) {
                  localStorage.setItem('token', token);
                  localStorage.setItem('auth_token', token);
                  localStorage.setItem('sessionActivity', JSON.stringify({ token: token, at: Date.now() }));
                }
              })();
            """);
            _injectCSS(webViewController);
            _applyAudioSetting(webViewController);
          },
          onPageFinished: (String url) {
            if (url == 'about:blank') return;
            _injectCSS(webViewController);
            _applyAudioSetting(webViewController);

            // Token and Routing Injection
            webViewController.runJavaScript("""
              (function() {
                const token = '${widget.userToken}';
                localStorage.setItem('token', token);
                localStorage.setItem('auth_token', token);
                localStorage.setItem('sessionActivity', JSON.stringify({ token: token, at: Date.now() }));
                if (window.location.pathname.includes('/login') || window.location.pathname === '/') {
                   window.location.replace('/ai_gesture/mobile');
                }
              })();
            """);

            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(targetUrl));

    if (mounted) {
      setState(() {
        controller = webViewController;
      });
    }
  }

  void _applyAudioSetting(WebViewController ctrl) {
    if (!mounted) return;
    try {
      final isSoundEnabled =
          di.sl<SoundSettingsViewModel>().isSoundEffectsEnabled;
      WebViewAudioHelper.applyAudioSetting(ctrl, isSoundEnabled);
    } catch (e) {
      debugPrint("Error applying webview audio setting: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AI Gesture",
          style: TextStyle(color: Colors.black,),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() => _isLoading = true);
              controller?.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (controller != null) WebViewWidget(controller: controller!),

          // Loading Overlay
          if (controller == null || _isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFE9B63B)),
              ),
            ),
        ],
      ),
    );
  }
}
