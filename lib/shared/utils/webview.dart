import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SsoWebView extends StatelessWidget {
  final Uri url;
  const SsoWebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(url);

    return Scaffold(
      appBar: AppBar(
        title: const Text("SSO Login"),
        backgroundColor: Colors.blue,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
