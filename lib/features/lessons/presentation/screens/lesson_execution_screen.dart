import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:auri_sign/config/api_constants.dart';

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

    // 1. Setup the target URL with the auth token parameter
    final String baseTargetUrl = ApiConstants.lessonWebviewUrl(
      widget.category,
      widget.lessonId,
    );
    final String targetUrl = "$baseTargetUrl#auth=${widget.userToken}";
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

    // 🌉 THE BRIDGE: This listens for messages from the React web app
    webViewController.addJavaScriptChannel(
      'FlutterChannel',
      onMessageReceived: (JavaScriptMessage message) {
        if (message.message == 'exit_lesson') {
          debugPrint("🚪 Web requested exit. Closing Flutter screen.");
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context); // Goes back to CategoryAlphabetsPage
          }
        }
      },
    );

    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      // Added 'AuriSignMobile' to the User Agent so React knows it's inside the app
      ..setUserAgent(
        "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Mobile Safari/537.36 AuriSignMobile",
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            webViewController.runJavaScript("""
              (function() {
                const hash = window.location.hash.substring(1);
                const urlParams = new URLSearchParams(hash);
                const token = urlParams.get('auth') || '${widget.userToken}';
                if (token) {
                  localStorage.setItem('token', token);
                  localStorage.setItem('auth_token', token);
                }
              })();
            """);
          },
          onPageFinished: (url) {
            if (url == 'about:blank') return;
            webViewController.runJavaScript("""
              if (window.location.pathname.includes('/login') || window.location.pathname === '/') {
                localStorage.setItem('token', '${widget.userToken}');
                window.location.replace('$targetPath');
              }
            """);

            if (mounted) setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(targetUrl));

    if (mounted) setState(() => controller = webViewController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 4. NO FLUTTER APP BAR: Let the React app's header act as the native header
      body: SafeArea(
        // SafeArea prevents the React header from hiding under the phone's top notch
        child: Stack(
          children: [
            if (controller != null) WebViewWidget(controller: controller!),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFFE9B63B)),
              ),
          ],
        ),
      ),
    );
  }
}
