import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:auri_sign/config/api_constants.dart';

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

  Future<void> _initWebView() async {
    await [Permission.camera, Permission.microphone].request();

    const String targetUrl = ApiConstants.gestureWebviewUrl;

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController webViewController =
        WebViewController.fromPlatformCreationParams(params);

    if (webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
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
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // CSS Injection to hide unwanted UI elements
            const String css = """
              .fixed-bottom, nav, header, footer, .navbar, .bottom-nav,
              div[style*="z-index: 5"][style*="position: fixed"][style*="top: 0"],
              #root > div > div[style*="position: fixed"][style*="top: 0"] { 
                display: none !important; 
                visibility: hidden !important;
                opacity: 0 !important;
                pointer-events: none !important;
                height: 0px !important;
                min-height: 0px !important;
                margin: 0px !important;
                padding: 0px !important;
                z-index: -9999 !important;
              }
            """;
            webViewController.runJavaScript("""
              var style = document.createElement('style');
              style.type = 'text/css';
              style.innerHTML = `$css`;
              document.head.appendChild(style);
            """);

            // Inject Token
            webViewController.runJavaScript("""
              localStorage.setItem('token', '${widget.userToken}');
              if (window.location.pathname === '/login' || window.location.pathname === '/') {
                 window.location.href = '/ai_gesture';
              }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Gesture"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            tooltip: 'Reload Camera',
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              controller?.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (controller != null) WebViewWidget(controller: controller!),

          if (controller == null || _isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
