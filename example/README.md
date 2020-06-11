# ir_sensor_plugin_example

Demonstrates how to use the ir_sensor_plugin plugin.
### Example

``` 
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
  static const TV_POWER_HEX =
      "0000 006d 0022 0003 00a9 00a8 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0040 0015 0015 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 0702 00a9 00a8 0015 0015 0015 0e6e";

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
                  String result =
                      await IrSensorPlugin.transmit(pattern: TV_POWER_HEX);
                  debugPrint('Emitting Signal: $result');
                },
                child: Text('Transmitt'),
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
                  hintText: 'Write specific code to transmit',
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
            final String result =
                await IrSensorPlugin.transmit(pattern: _textController.text);
            if (result.contains('Emitting') && result != null) {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Broadcasting... ${_textController.text}')));
            }
          }
        },
        child: Text('Transmit Specific Code'),
      )
    ]);
  }
}

``` 
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
