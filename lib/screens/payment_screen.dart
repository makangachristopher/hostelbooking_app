import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyWebView extends StatelessWidget {
  final String url;

  MyWebView({required this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pay with Pesapal"),
      ),
      body: _buildWebView(),
    );
  }

  Widget _buildWebView() {
    if (Platform.isAndroid || Platform.isIOS) {
      // Use WebView for Android and iOS
      return WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      );
    } else {
      // Open the URL in the default browser for other platforms
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "WebView is not supported on this platform.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                launchURL(url);
              },
              child: Text("Open in Browser"),
            ),
          ],
        ),
      );
    }
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }
}
