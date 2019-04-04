import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FP Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Fingerprint Auth'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomePage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometrics = false;
  String _authorized = 'Not Authorized';
  List<BiometricType> _availableBiometricTypes = List<BiometricType>();

  Future<void> _checkBiometric() async {
    bool checkBiometric = false;
    try {
      checkBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = checkBiometric;
    });
  }

  Future<void> _getBiometricList() async {
    List<BiometricType> listAvailableBiometrics;
    try {
      listAvailableBiometrics =
          await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _availableBiometricTypes = listAvailableBiometrics;
    });
  }

  Future<void> _authorizeNow() async {
    bool isAuthorized = false;
    try {
     var isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please autheticate to proceed!",
        useErrorDialogs: true,
        stickyAuth: true,

      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      if(isAuthorized) {
        _authorized = "Authorized";
      } else {
        _authorized = "Not Authorized";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Can we check biometric: $_canCheckBiometrics"),
            RaisedButton(
                child: Text("Check Biometric"),
                color: Colors.green,
                colorBrightness: Brightness.dark,
                onPressed: _checkBiometric),
            Text(
                "Available Biometrics: ${_availableBiometricTypes.toString()}"),
            RaisedButton(
                child: Text("List Biometric Types"),
                color: Colors.green,
                colorBrightness: Brightness.dark,
                onPressed: _getBiometricList),
            Text("Authorized: $_authorized"),
            RaisedButton(
                child: Text("List Biometric Types"),
                color: Colors.green,
                colorBrightness: Brightness.dark,
                onPressed: _authorizeNow)
          ],
        ),
      ),
    );
  }
}
