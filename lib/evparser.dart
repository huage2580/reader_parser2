import 'dart:ffi';
import 'dart:io';
import 'parser_bindings.dart';
import 'package:ffi/ffi.dart' as f2;

class EVParserHolder{
  static final DynamicLibrary _dylib = Platform.environment['FLUTTER_TEST'] == 'true'
      ? (Platform.isWindows
      ? DynamicLibrary.open('test/build/Debug/evparser.dll')
      : Platform.isMacOS
      ? DynamicLibrary.open('test/build/evparser.dylib')
      : DynamicLibrary.open('test/build/evparser.so'))
      : (Platform.isWindows
      ? DynamicLibrary.open('evparser.dll')
      : Platform.isAndroid
      ? DynamicLibrary.open('evparser.so')
      : DynamicLibrary.process());

  late EVParser _evParser;

  EVParserHolder.getInstance(){
    _evParser = EVParser(_dylib);
  }

  String StartTransaction(String input){
    var out = _evParser.StartTransaction(input.toNativeUtf8());
    var outString = out.toDartString();
    // f2.malloc.free(out);
    return outString;
  }

  String ParseRuleRaw(String tId,String rule){
    var out = _evParser.ParseRuleRaw(tId.toNativeUtf8(), rule.toNativeUtf8());
    var outString = out.toDartString();
    // f2.malloc.free(out);
    return outString;
  }

  List<String> ParseRuleStr(String tId,String rule){
    var out = _evParser.ParseRuleStr(tId.toNativeUtf8(), rule.toNativeUtf8());
    return toList(out);
  }

  List<String> ParseRuleStrForParent(String tId,String rule,int index){
    var out = _evParser.ParseRuleStrForParent(tId.toNativeUtf8(), rule.toNativeUtf8(),index);
    return toList(out);
  }

  int QueryBatchResultSize(String tId){
    return _evParser.QueryBatchResultSize(tId.toNativeUtf8());
  }

  void EndTransaction(String tId){
    _evParser.EndTransaction(tId.toNativeUtf8());
  }

  List<String> toList(Pointer<Pointer<f2.Utf8>> p){
    List<String> result = [];
    var index = 0;
    while (p.elementAt(index).value.address != 0){
      var p1 = p.elementAt(index).value;
      result.add(p1.toDartString());
      index ++;
      // f2.malloc.free(p1);
    }
    // f2.malloc.free(p);
    return result;
  }


}