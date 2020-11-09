import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart';

class MyWebView extends StatefulWidget {
  final String title;
  final String selectedUrl;

  // void scrap() async {}

  MyWebView({Key key, this.title, this.selectedUrl}) : super(key: key);

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  void readJS() async {
    try {
      String html = await _controller.evaluateJavascript(
          "console.log(document.getElementById('psname').innerHTML);");

      print(html);
    } catch (e) {
      print(e.toString());
    }
  }

  WebViewController _controller;

  var htmlElement;

  @override
  Widget build(BuildContext context) {
    // readJS();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: WebView(
              initialUrl: widget.selectedUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              navigationDelegate: (NavigationRequest request) {
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {},
              onPageFinished: (_) {
                // _controller.evaluateJavascript(
                //     "console.log(document.documentElement.innerHTML);");
                //  htmlElement =  _controller.evaluateJavascript('document.documentElement.innerHTML') as String;

                // String docu = _controller.evaluateJavascript(
                //         'console.log(document.documentElement.innerHTML);') as String;

                var docu = _controller.evaluateJavascript(
                    'console.log(document.body.innerHTML);');
                // as String;
                // print('DOCU,................................................................................................................................................... $docu');
                var dom = parse(docu);
                print(dom.getElementsByTagName('strong')[0].innerHtml);
              },
              gestureNavigationEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
