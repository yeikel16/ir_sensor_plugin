import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ir_sensor_plugin/ir_sensor_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _hasIrEmitter = false;
  String _getCarrierFrequencies = 'Unknown';

  var power = [
    169,
    168,
    21,
    63,
    21,
    63,
    21,
    63,
    21,
    63,
    21,
    63,
    21,
    63,
    21,
    63,
    21,
    1794,
    169,
    168,
    21,
    21,
    21,
    3694
  ];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    bool hasIrEmitter;
    String getCarrierFrequencies;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await IrSensorPlugin.platformVersion;
      hasIrEmitter = await IrSensorPlugin.hasIrEmitter;
      getCarrierFrequencies = await IrSensorPlugin.getCarrierFrequencies;
    } on PlatformException {
      platformVersion = 'Failed to get data in a platform.';
      hasIrEmitter = false;
      getCarrierFrequencies = 'None';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _hasIrEmitter = hasIrEmitter;
      _getCarrierFrequencies = getCarrierFrequencies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                height: 15.0,
              ),
              Text('Running on: $_platformVersion\n'),
              Text('Has Ir Emitter: $_hasIrEmitter\n'),
              Text('IR Carrier Frequencies:$_getCarrierFrequencies'),
              Container(
                height: 15.0,
              ),
              RaisedButton(
                onPressed: () async {
                  final String result =
                      await IrSensorPlugin.transmitListInt(list: power);
                  debugPrint('Emitting  List Int Signal: $result');
                },
                child: Text('Transmitt List Int'),
              ),
              Container(
                height: 15.0,
              ),
              FormSpecificCode(),
            ],
          ),
        ),
      ),
    );
  }
}

class FormSpecificCode extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  static const power =
      "0000 006d 0022 0003 00a9 00a8 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0040 0015 0015 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 0702 00a9 00a8 0015 0015 0015 0e6e";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Write specific String code to transmit',
                  suffixIcon: IconButton(
                    onPressed: () => _textController.clear(),
                    icon: Icon(Icons.clear),
                  ),
                ),
                controller: _textController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Write the code to transmit';
                  }
                  return null;
                },
              ),
            )
          ])),
      Container(
        height: 15.0,
      ),
      RaisedButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            final String result = await IrSensorPlugin.transmitString(
                pattern: _textController.text);
            if (result.contains('Emitting') && result != null) {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Broadcasting... ${_textController.text}')));
            }
          }
        },
        child: Text('Transmit Specific Code HEX'),
      )
    ]);
  }
}
