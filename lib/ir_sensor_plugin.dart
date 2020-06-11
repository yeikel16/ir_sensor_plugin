import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class IrSensorPlugin {
  static const MethodChannel _channel = const MethodChannel('ir_sensor_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Check whether the device has an infrared emitter.
  /// 
  /// Returns `"true"` if the device has an infrared emitter, else `"false"` .
  static Future<bool> get hasIrEmitter async {
    final bool hasIrEmitter = await _channel.invokeMethod('hasIrEmitter');
    return hasIrEmitter;
  }

  /// Query the infrared transmitter's supported carrier frequencies in `Hertz`.
  static Future<String> get getCarrierFrequencies async {
    final String getCaFreqs =
        await _channel.invokeMethod('getCarrierFrequencies');
    return getCaFreqs;
  }
  
  /// Transmit an infrared pattern, return a String `"Emitting"` if there was no problem in the process.
  /// 
  /// The value [pattern] has to be a string that contains the behavior in `HEX`, example:
  /// `TV_POWER_HEX = "0000 006d 0022 0003 00a9 00a8 0015 003f 0015 003f 0015 003f 
  /// 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015 
  /// 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f
  /// 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0040 0015 
  /// 0015 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 0702 
  /// 00a9 00a8 0015 0015 0015 0e6e"`;
  static Future<String> transmit({String pattern}) async {
    debugPrint("Send code for Emitter: $pattern");
    final String result =
        await _channel.invokeMethod('codeForEmitter', {"codeForEmitter": pattern});
    return result;
  }
}
