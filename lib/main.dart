import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  QrReaderViewController _controller;
  bool isOk = false;
  String _qrResult = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              QrImage(
                data: "https://yahoo.co.jp",
                version: QrVersions.auto,
                size: 200.0,
              ),
              RaisedButton(
                onPressed: () async {
                  Map<PermissionGroup, PermissionStatus> permissions =
                      await PermissionHandler()
                          .requestPermissions([PermissionGroup.camera]);
                  if (permissions[PermissionGroup.camera] ==
                      PermissionStatus.granted) {
                    setState(() {
                      isOk = true;
                    });
                  }
                },
                child: Text('get camera permission'),
                color: Colors.blue,
              ),
              QrReaderViewHolder(
                enable: isOk,
                callback: (controller) {
                  this._controller = controller;
                  _controller.startCamera(onScan);
                },
              ),
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                'QR code result $_qrResult',
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onScan(String v, List<Offset> offsets) {
    setState(() {
      _qrResult = v;
    });
    _controller.stopCamera();
  }
}

class QrReaderViewHolder extends StatelessWidget {
  QrReaderViewHolder({@required this.enable, @required this.callback});
  final enable;
  final Function(QrReaderViewController) callback;

  @override
  Widget build(BuildContext context) {
    if (!enable) {
      return Text('please get permission');
    }
    return Container(
      width: 320,
      height: 350,
      child: QrReaderView(
        width: 320,
        height: 350,
        callback: this.callback,
      ),
    );
  }
}
