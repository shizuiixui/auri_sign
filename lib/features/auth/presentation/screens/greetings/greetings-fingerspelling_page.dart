import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:auri_sign/config/api_constants.dart';
import 'package:provider/provider.dart';

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

  // CSS Injection to hide web layout elements and make it feel native
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

    const String targetUrl = ApiConstants.greetingFingerspellingWebviewUrl;

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
      // The bridge between JavaScript and Flutter
      ..addJavaScriptChannel(
        'MobileChannel',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message == 'navigateToHome') {
            // Turn the loading overlay back on
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
            // To mark the finger spelling as completed in SharedPref
            context.read<UserViewModel>().completeFingerspelling();

            Future.delayed(const Duration(milliseconds: 600), () {
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            });
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
            _injectCSS(webViewController);
          },
          onPageFinished: (String url) {
            _injectCSS(webViewController);
            // Handle Authentication and Routing Interception
            webViewController.runJavaScript("""
             // Handle Authentication
              localStorage.setItem('token', '${widget.userToken}');
              if (window.location.pathname === '/login' || window.location.pathname === '/') {
                 window.location.href = '/greeting-fingerspelling';
              }

              // Handle Routing Interception
              const originalPush = window.history.pushState;
              const originalReplace = window.history.replaceState;

              function notifyFlutter(url) {
                if (url.includes('/home') || url.includes('/dashboard') || url.includes('/main') || url === '/') {
                  MobileChannel.postMessage('navigateToHome');
                }
              }

              window.history.pushState = function(state, unused, url) {
                originalPush.apply(window.history, arguments);
                notifyFlutter(url);
              };

              window.history.replaceState = function(state, unused, url) {
                originalReplace.apply(window.history, arguments);
                notifyFlutter(url);
              };
            """);

            // 2. Add an 800ms buffer to hide the web rendering process
            Future.delayed(const Duration(milliseconds: 800), () {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            });
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
