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
  String _bodyHtml;
  List<String> htmDataList = [];
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
    List<String> reversed = htmDataList[1].split('\n').toList();
    print(reversed[24]);
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
              onWebViewCreated: (WebViewController webViewController) {
                // Get reference to WebView controller to access it globally
                _controller = webViewController;
              },
              javascriptChannels: <JavascriptChannel>[
                // Set Javascript Channel to WebView
                _extractDataJsChannel(context),
              ].toSet(),
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                _controller.evaluateJavascript(
                    "(function(){Flutter.postMessage(window.document.body.innerText)})();");
              },
            ),
          ),

          //  WebView(
          //   initialUrl: widget.selectedUrl,
          //   javascriptMode: JavascriptMode.unrestricted,
          //   onWebViewCreated: (controller) {
          //     _controller = controller;
          //   },
          //   navigationDelegate: (NavigationRequest request) {
          //     print('allowing navigation to $request');
          //     return NavigationDecision.navigate;
          //   },
          //   onPageStarted: (String url) {},
          //   onPageFinished: (_) {
          //     // _controller.evaluateJavascript(
          //     //     "console.log(document.documentElement.innerHTML);");
          //     //  htmlElement =  _controller.evaluateJavascript('document.documentElement.innerHTML') as String;

          //     // String docu = _controller.evaluateJavascript(
          //     //         'console.log(document.documentElement.innerHTML);') as String;

          //     // var docu = _controller.evaluateJavascript(
          //     //     'console.log(document.body.innerHTML);');
          //     // as String;
          //     // print('DOCU,................................................................................................................................................... $docu');
          //     // var dom = parse(docu);
          //     // print(dom.getElementsByTagName('strong')[0].innerHtml);
          //     // _controller.evaluateJavascript("function(){FLUTTER.postMessage(window.document.body.innerText)}();");
          //      _controller.evaluateJavascript("(function(){Flutter.postMessage(window.document.body.outerHTML)})();");
          //   },
          //   gestureNavigationEnabled: true,
          // ),
          // ),
        ],
      ),
    );
  }

  JavascriptChannel _extractDataJsChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Flutter',
        onMessageReceived: (JavascriptMessage message) {
          String pageBody = message.message;
          setState(() {
            _bodyHtml = pageBody;
          });
          htmDataList.add(pageBody);
          print('$pageBody');
        });
  }
}
