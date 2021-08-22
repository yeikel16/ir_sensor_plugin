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

  /// Change the frequency with which it is transmitted. Default is 38020 Hz
  static Future<String> setFrequencies(int newFrequencie) async {
    final String newFrequency = await _channel
        .invokeMethod('setFrequency', {"setFrequency": newFrequencie});
    return newFrequency;
  }

  /// It transmits an infrared pattern, return a String "Emitting" if there was
  /// no problem in the process.
  ///
  /// This method receives a String
  ///
  /// The value [pattern] has to be a string that contains the behavior in `HEX`.
  ///
  /// Example:
  ///
  /// `TV_POWER_HEX = "0000 006d 0022 0003 00a9 00a8 0015 003f 0015 003f 0015 003f
  /// 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015
  /// 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f
  /// 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0040 0015
  /// 0015 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 0702
  /// 00a9 00a8 0015 0015 0015 0e6e"`;
  static Future<String> transmitString({required String pattern}) async {
    debugPrint("Send code for Emitter: $pattern");
    final String result = await _channel
        .invokeMethod('codeForEmitter', {"codeForEmitter": pattern});
    return result;
  }

  /// This method receives a Int List
  ///
  /// var SAMSUNG_POWER = [169,168,21,63,21,63,21,63,21,21,21,21,21,21,
  /// 21,21,21,21,21,63,21,63,21,63,21,21,21,21,21,21,21,21,21,21,21,21,21,63,21,
  /// 21,21,21,21,21,21,21,21,21,21,21,21,64,21,21,21,63,21,63,21,63,21,63,21,63,
  /// 21,63,21,1794,169,168,21,21,21,3694];

  static Future<String> transmitListInt({required List<int> list}) async {
    //debugPrint("Send code for Emitter: $pattern");
    final String result = await _channel
        .invokeMethod('transmitListInt', {"transmitListInt": list});
    return result;
  }
}
