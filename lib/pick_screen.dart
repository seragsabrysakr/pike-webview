import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PickScreen extends StatefulWidget {
  const PickScreen({Key? key}) : super(key: key);
  static const String id = 'PromoScreen';

  @override
  State<PickScreen> createState() => _PickScreenState();
}

class _PickScreenState extends State<PickScreen> {
  Color primColor = const Color(0Xff2D364C);
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    if (Platform.isIOS) WebView.platform = CupertinoWebView();
  }

  bool isLoading = true;
  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffff7800),
      child: SafeArea(
        child: Scaffold(
            body: Stack(
          children: [
            WebView(
              key: _key,
              initialUrl: 'https://delivery.pick-a.net',
              javascriptMode: JavascriptMode.unrestricted,
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
        )),
      ),
    );
  }
}
