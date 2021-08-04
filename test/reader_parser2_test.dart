import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reader_parser2/reader_parser2.dart';

void main() {
  const MethodChannel channel = MethodChannel('reader_parser2');

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
    expect(await ReaderParser2.platformVersion, '42');
  });
}
