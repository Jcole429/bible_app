import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool _isWebViewReady = false;

  @override
  void initState() {
    super.initState();

    print("Opening URL: ${widget.url}");

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) => print("WebView started loading: $url"),
              onPageFinished: (url) {
                setState(() {
                  _isWebViewReady = true;
                });
                print("WebView finished loading: $url");
              },
              onWebResourceError: (error) {
                print(
                  "WebView Error: ${error.description}, Code: ${error.errorCode}",
                );
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));

    print("WebView initialized");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:
          _isWebViewReady
              ? WebViewWidget(controller: _controller)
              : const Center(
                child: CircularProgressIndicator(),
              ), // Show loading
    );
  }
}
