import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PickScreen extends StatefulWidget {
  const PickScreen({Key? key}) : super(key: key);
  static const String id = 'PromoScreen';

  @override
  State<PickScreen> createState() => _PickScreenState();
}

class _PickScreenState extends State<PickScreen> {
  WebViewController? _controller;

  final Completer<WebViewController> _controllerCompleter =
  Completer<WebViewController>();

  //Make sure this function return Future<bool> otherwise you will get an error
  Future<bool> _onWillPop(BuildContext context) async {
    if (await _controller!.canGoBack()) {
      _controller?.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
  final _key = UniqueKey();

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: SafeArea(
            child: Stack(
              children: [
                WebView(
                  initialUrl: 'https://delivery.pick-a.net',
                  javascriptMode: JavascriptMode.unrestricted,
                  key: _key,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controllerCompleter.future
                        .then((value) => _controller = value);
                    _controllerCompleter.complete(webViewController);
                  },
                  javascriptChannels: {
                    JavascriptChannel(
                        name: 'opengooglemaps',
                        onMessageReceived: (JavascriptMessage message) async {
                          if (!await launchUrl(Uri.parse(message.message),
                              mode: LaunchMode.externalApplication)) {
                            throw 'Could not launch $message';
                          }
                        })
                  },
                  onProgress: (int progress) {
                    print('WebView is loading (progress : $progress%)');
                  },
                  onPageFinished: (finish) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                isLoading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : Stack(),
              ],
            )
          // WebView(

          //   javascriptMode: JavascriptMode.unrestricted,
          //   initialUrl: widget.url,
          // )

        ),
      ),
    );
  }
}
