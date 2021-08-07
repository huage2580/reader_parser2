import 'package:expressions/expressions.dart';
import 'package:reader_parser2/regexp_rule.dart';

///简单表达式计算
class HEvalParser {
  var context;

  HEvalParser(this.context);

  dynamic _eval(String expression) {
    var input = expression.replaceAll("\"", "^");
    Expression exp = Expression.parse(input);
    // Evaluate expression
    final evaluator = const ExpressionEvaluator();
    var output = evaluator.eval(exp, context).toString();
    output = output.replaceAll("^", "\"");
    return output;
  }

  String parse(String? input) {
    if(input == null || input.trim().isEmpty){
      return input??"";
    }
    var regexp = RegExp(RegexpRule.EXP_MATCH);
    var mapper = (Match match) {
      var expression = match.group(1);
      return _eval(expression!).toString();
    };
    return input.replaceAllMapped(regexp, mapper);
  }
}
