import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class GestureWebviewScreen extends StatefulWidget {
  const GestureWebviewScreen({super.key});

  @override
  State<GestureWebviewScreen> createState() => _GestureWebviewScreenState();
}

class _GestureWebviewScreenState extends State<GestureWebviewScreen> {
  late final WebViewController controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    // Request permissions for Camera/Microphone
    await [Permission.camera, Permission.microphone].request();

    const String url = 'http://localhost:5173/ai_gesture';

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
      final androidController = webViewController.platform as AndroidWebViewController;
      
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
              .fixed-bottom, nav, header, footer, .navbar, .bottom-nav { 
                display: none !important; 
                visibility: hidden !important;
                opacity: 0 !important;
                pointer-events: none !important;
              }
            """;
            
            webViewController.runJavaScript("""
              var style = document.createElement('style');
              style.type = 'text/css';
              style.innerHTML = `$css`;
              document.head.appendChild(style);
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
      ..loadRequest(Uri.parse(url));

    controller = webViewController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Gesture")),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}