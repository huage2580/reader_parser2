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
    var ip = input.toNativeUtf8();
    var out = _evParser.StartTransaction(ip);
    var outString = out.toDartString();
    f2.malloc.free(ip);
    _free(out);
    return outString;
  }

  String ParseRuleRaw(String tId,String rule){
    var tp = tId.toNativeUtf8();
    var rp = rule.toNativeUtf8();
    var out = _evParser.ParseRuleRaw(tp, rp);
    var outString = out.toDartString();
    // f2.malloc.free(out);
    f2.malloc.free(tp);
    f2.malloc.free(rp);
    _free(out);
    return outString;
  }

  List<String> ParseRuleStr(String tId,String rule){
    var tp = tId.toNativeUtf8();
    var rp = rule.toNativeUtf8();
    var out = _evParser.ParseRuleStr(tp, rp);
    f2.malloc.free(tp);
    f2.malloc.free(rp);
    return toList(out);
  }

  List<String> ParseRuleStrForParent(String tId,String rule,int index){
    var tp = tId.toNativeUtf8();
    var rp = rule.toNativeUtf8();
    var out = _evParser.ParseRuleStrForParent(tp,rp,index);
    f2.malloc.free(tp);
    f2.malloc.free(rp);
    return toList(out);
  }

  int QueryBatchResultSize(String tId){
    var tp = tId.toNativeUtf8();
    var out = _evParser.QueryBatchResultSize(tp);
    f2.malloc.free(tp);
    return out;
  }

  void EndTransaction(String tId){
    var tp = tId.toNativeUtf8();
    _evParser.EndTransaction(tp);
    f2.malloc.free(tp);
  }

  void _free(Pointer pointer){
    _evParser.FreeStr(pointer);
  }

  List<String> toList(Pointer<Pointer<f2.Utf8>> p){
    List<String> result = [];
    var index = 0;
    while (p.elementAt(index).value.address != 0){
      var p1 = p.elementAt(index).value;
      result.add(p1.toDartString());
      index ++;
      // f2.malloc.free(p1);
      _free(p1);
    }
    // f2.malloc.free(p);
    _free(p);
    return result;
  }


}