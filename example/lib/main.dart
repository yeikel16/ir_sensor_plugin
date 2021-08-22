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
              const SizedBox(
                height: 15.0,
              ),
              Text('Running on: $_platformVersion\n'),
              Text('Has Ir Emitter: $_hasIrEmitter\n'),
              Text('IR Carrier Frequencies:$_getCarrierFrequencies'),
              const SizedBox(
                height: 15.0,
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(power.toString()),
                      const SizedBox(
                        height: 15.0,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final String result =
                              await IrSensorPlugin.transmitListInt(list: power);
                          debugPrint('Emitting  List Int Signal: $result');
                        },
                        child: Text('Transmitt List Int'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormSpecificCode(),
                  ),
                ),
              ),
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
                key: Key('textField_code_hex'),
                decoration: InputDecoration(
                  hintText: 'Write specific String code to transmit',
                  suffixIcon: IconButton(
                    onPressed: () => _textController.clear(),
                    icon: Icon(Icons.clear),
                  ),
                ),
                controller: _textController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
      ElevatedButton(
        key: Key('key_buttom_hex'),
        onPressed: () async {
          final validate = _formKey.currentState?.validate() ?? false;
          if (validate) {
            final String result = await IrSensorPlugin.transmitString(
                pattern: _textController.text);
            if (result.contains('Emitting')) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Broadcasting... ${_textController.text}')));
            }
          }
        },
        child: Text('Transmit Specific Code HEX'),
      )
    ]);
  }
}
