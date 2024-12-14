// ignore_for_file: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ir_sensor_plugin/ir_sensor_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('ir_sensor_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await IrSensorPlugin.platformVersion, '42');
  });
}
