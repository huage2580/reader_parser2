


import 'package:reader_parser2/evparser.dart';
import 'package:reader_parser2/regexp_rule.dart';

///
///解析网页内容
///

class HParser {
  static const VERSION = "v20210806_1735";

  late String _htmlString;
  late EVParserHolder _parserHolder;
  late String tId;

  HParser(String htmlString){
    _htmlString = htmlString;
    _parserHolder = EVParserHolder.getInstance();
    tId = _parserHolder.StartTransaction(_htmlString);
  }

  List<String> parseRuleStrings(String? rule){
    if(rule == null || rule.isEmpty){
      return [];
    }
    return _parserHolder.ParseRuleStr(tId, rule);
  }

  String? parseRuleString(String? rule){
    if(rule == null || rule.isEmpty){
      return null;
    }
    var temp = parseRuleStrings(rule);
    var result = temp.join('\n');
    return result;
  }

  //返回批量ID
  String parseRuleRaw(String rule){
    return _parserHolder.ParseRuleRaw(tId, rule);
  }

  int queryBatchSize(String bId){
    return _parserHolder.QueryBatchResultSize(bId);
  }

  List<String> parseRuleStringsForParent(String bId,String? rule,int index){
    if(rule == null || rule.isEmpty){
      return [];
    }
    return _parserHolder.ParseRuleStrForParent(bId, rule, index);
  }

  String? parseRuleStringForParent(String bId,String? rule,int index){
    if(rule == null || rule.isEmpty){
      return null;
    }
    var result = parseRuleStringsForParent(bId, rule, index);
    return result.length>0?result[0]:null;
  }



  void destoryBatch(String bId){
    _parserHolder.EndTransaction(bId);
  }

  void destory(){
    _parserHolder.EndTransaction(tId);
  }


  static String parseReplaceRule(String input,String rule){
    var text = input;
    //净化替换
    if(rule!= "" && rule.startsWith(RegexpRule.PARSER_TYPE_REG_REPLACE)){
      var sl = rule.split(RegexpRule.PARSER_TYPE_REG_REPLACE);
      if(sl.length <= 1){
        throw Exception("无法解析的替换规则->$rule");
        return text;
      }

      var _groupFunction = (m){
        // 替换$1之类的数据
        var f_str = sl[2];
        var group_reg = RegExp(RegexpRule.REGEXP_GROUP);
        f_str = f_str.replaceAllMapped(group_reg, (match) => m.group(int.parse(match.group(1)!)));
        return f_str;
      };

      var regexp = RegExp(sl[1],multiLine: true);
      if(sl.length == 2){
        text = input.replaceAll(regexp, '');
      }else if(sl.length == 3){
        text = input.replaceAllMapped(regexp, _groupFunction);
      }else if(sl.length == 4){
        text = input.replaceFirstMapped(regexp,_groupFunction);
      }
    }
    return text;
  }


}