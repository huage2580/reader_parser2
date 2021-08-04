
import 'dart:async';

import 'package:flutter/services.dart';

class ReaderParser2 {
  static const MethodChannel _channel =
      const MethodChannel('reader_parser2');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
