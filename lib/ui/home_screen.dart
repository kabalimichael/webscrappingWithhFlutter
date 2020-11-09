import 'package:flutter/material.dart';
import 'package:webscrapping_flutter/ui/my_webview.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('H Screen'),
      ),
      body: Center(
        child: FlatButton(
          child: Text('Open Webpage'),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => MyWebView(
                      title: 'Uganda Electoral Website',
                      selectedUrl: 'https://www.ec.or.ug/search/byid/',
                    )));
          },
        ),
      ),
    );
  }
}
