import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:auri_sign/config/api_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GreetingFingerspellingPage extends StatefulWidget {
  final String userToken;

  const GreetingFingerspellingPage({super.key, required this.userToken});

  @override
  State<GreetingFingerspellingPage> createState() =>
      _GreetingFingerspellingPageState();
}

class _GreetingFingerspellingPageState
    extends State<GreetingFingerspellingPage> {
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

  void _injectCSS(WebViewController controller) {
    const String css = """
      nav, header, footer, .navbar, .bottom-nav, .sidebar, 
      .badge, .streak-container, [class*='badge'], [class*='streak'] { 
        display: none !important; 
        visibility: hidden !important;
        height: 0px !important;
        pointer-events: none !important;
        opacity: 0 !important;
      }
      .container-fluid, .container { padding: 0 !important; margin: 0 !important; }
      body { background-color: #fff !important; overflow-x: hidden; }
    """;

    controller
        .runJavaScript("""
      (function() {
        var style = document.createElement('style');
        style.innerHTML = `$css`;
        document.head.appendChild(style);
      })();
    """)
        .catchError((_) {});
  }

  Future<void> _initWebView() async {
    await [Permission.camera, Permission.microphone].request();
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final String effectiveToken = widget.userToken.isNotEmpty
        ? widget.userToken
        : (prefs.getString('auth_token') ?? '');

    // THE MAGIC BULLET: Just pass the token exactly how your leader set it up!
    final String targetUrl =
        "${ApiConstants.greetingFingerspellingWebviewUrl}?token=$effectiveToken";

    print("TESTING URL: $targetUrl");

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

    void handleExit() {
      if (mounted) setState(() => _isLoading = true);
      context.read<UserViewModel>().completeFingerspelling();
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      });
    }

    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setUserAgent(
        "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 AuriSignMobile",
      )
      ..addJavaScriptChannel(
        'MobileChannel',
        onMessageReceived: (m) => handleExit(),
      )
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (m) => handleExit(),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            _injectCSS(webViewController);

            // Just the history patcher to know when the user exits back to Flutter
            webViewController
                .runJavaScript("""
              (function() {
                if (!window.__historyPatched) {
                  const originalPush = window.history.pushState;
                  const originalReplace = window.history.replaceState;
                  function notifyFlutter(navUrl) {
                    if (navUrl && (navUrl.includes('/home') || navUrl === '/')) {
                      if (window.MobileChannel) MobileChannel.postMessage('navigateToHome');
                      if (window.FlutterChannel) FlutterChannel.postMessage('navigateToHome');
                    }
                  }
                  window.history.pushState = function() {
                    originalPush.apply(window.history, arguments);
                    notifyFlutter(arguments[2]);
                  };
                  window.history.replaceState = function() {
                    originalReplace.apply(window.history, arguments);
                    notifyFlutter(arguments[2]);
                  };
                  window.__historyPatched = true;
                }
              })();
            """)
                .catchError((_) {});

            Future.delayed(const Duration(milliseconds: 600), () {
              if (mounted) setState(() => _isLoading = false);
            });
          },
          onWebResourceError: (error) =>
              debugPrint("WebView Error: ${error.description}"),
        ),
      )
      ..loadRequest(Uri.parse(targetUrl));

    if (mounted) setState(() => controller = webViewController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Greeting Fingerspelling",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          if (controller != null) WebViewWidget(controller: controller!),
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
