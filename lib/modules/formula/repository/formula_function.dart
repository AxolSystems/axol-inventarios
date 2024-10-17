import '../../object/model/object_model.dart';
import '../../object/repository/object_repo.dart';
import '../../widget_link/model/widgetlink_model.dart';

class FormulaFunction {
  /*static double sum(List<double> numbers) {
    double result = 0;
    if (numbers.isNotEmpty) {
      for (double num in numbers) {
        result = result + num;
      }
    }
    return result;
  }*/

  static Future<dynamic> devExpressions(String expression, ObjectModel object,
      [WidgetLinkModel? link]) async {
    const String tExpression = 'expression';
    const String tDev = 'dev';
    List<String> functions = [];
    List<Map<String, dynamic>> functionsDev = [];

    functions = matchFunctions(expression);

    for (int i = 0; i < functions.length; i++) {
      String function = functions[i];
      if (functionsDev.isNotEmpty) {
        for (Map<String, dynamic> functionDev in functionsDev) {
          if (functions.contains(functionDev[tExpression])) {
            function = function.replaceAll(
                functionDev[tExpression], functionDev[tDev].toString());
          }
        }
      } // cambiar

      if (function.startsWith('if:')) {
        /// [if:(comparación lógica),(valor si verdadero),(valor si falso)]
        final dynamic value;
        final bool logicTest;
        final String param = extractParameters(function);
        final String paramLogic = param.split(',')[0];
        final String paramTrue = param.split(',')[1];
        final String paramFalse = param.split(',')[2];

        if (paramLogic.contains('==')) {
          logicTest = operLogic(double.tryParse(paramLogic.split('==').first),
              double.tryParse(paramLogic.split('==').last), '==');
        } else if (paramLogic.contains('>')) {
          logicTest = operLogic(double.tryParse(paramLogic.split('>').first),
              double.tryParse(paramLogic.split('>').last), '>');
        } else if (paramLogic.contains('>=')) {
          logicTest = operLogic(double.tryParse(paramLogic.split('>=').first),
              double.tryParse(paramLogic.split('>=').last), '>=');
        } else if (paramLogic.contains('<')) {
          logicTest = operLogic(double.tryParse(paramLogic.split('<').first),
              double.tryParse(paramLogic.split('<').last), '<');
        } else if (paramLogic.contains('<=')) {
          logicTest = operLogic(double.tryParse(paramLogic.split('<=').first),
              double.tryParse(paramLogic.split('<=').last), '<=');
        } else {
          if (paramLogic == 'TRUE') {
            logicTest = true;
          } else if (paramLogic == 'FALSE') {
            logicTest = false;
          } else {
            logicTest = false;
          }
        }

        value = fnIf(logicTest, paramTrue, paramFalse);
        functionsDev.add({tExpression: function, tDev: value});
      } else if (function.startsWith('prop:')) {
        ///[prop:(id de propiedad)]
        final dynamic value = fnProp(object, extractParameters(function));
        functionsDev.add({tExpression: function, tDev: value});
      } else if (function.startsWith('error:')) {
        /// [error:(Mensaje de error)]
        functionsDev.add({tExpression: function, tDev: function});
      } else if (function.startsWith('query_sum:')) {
        /// [query_sum:(return~/column_name)~~(column_name==valor),(column_name==valor)...]
        String propValue = extractParameters(function).split('~~').first;
        propValue = propValue.replaceFirst('return~/', '');
        final double total = await ObjectRepo.postgresQuerySum(
            link!,
            propValue.split(','),
            extractParameters(function).split('~').last.split(','));
        /*ObjectRepo.querySum(
          link!,
          propValue.split(','),
          extractParameters(function).split('~').last.split(','),
        );*/
        functionsDev.add({tExpression: function, tDev: total});
      } else if (function.startsWith('prop_name:')) {
        /// [prop_name:(id propiedad)]
        final dynamic value = link!.entity.propertyList
            .firstWhere((x) => x.key == extractParameters(function));
        functionsDev.add({tExpression: function, tDev: value});
      }

      if (i == (functions.length - 1)) {
        return functionsDev.firstWhere((x) => x[tExpression] == function,
            orElse: () => {})[tDev];
      }
    }
  }

  static bool operLogic(double? value0, double? value1, String oper) {
    if (value0 != null && value1 != null) {
      if (oper == '==') {
        return value0 == value1;
      } else if (oper == '>') {
        return value0 > value1;
      } else if (oper == '>=') {
        return value0 >= value1;
      } else if (oper == '<') {
        return value0 < value1;
      } else if (oper == '<=') {
        return value0 <= value1;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static dynamic fnIf(bool logic, dynamic isTrue, dynamic isFalse) {
    if (logic) {
      return isTrue;
    } else {
      return isFalse;
    }
  }

  static dynamic fnProp(ObjectModel object, String propId) {
    return object.map[propId];
  }

  static List<String> matchFunctions(String text) {
    final List<String> resultados = [];
    final regex = RegExp(r'\[([^\[\]]*)\]');
    // Encontrar la primera coincidencia más interna
    Match? match = regex.firstMatch(text);
    while (match != null) {
      resultados.add(match.group(1)!);
      // Reemplazar la sub-cadena encontrada para evitar bucles infinitos
      text = text.replaceFirst(regex, match.group(1)!);
      match = regex.firstMatch(text);
    }
    return resultados;
  }

  static String extractParentheses(String text) {
    // Expresión regular para encontrar todo lo que esté dentro de paréntesis
    final regex = RegExp(r'\((.*?)\)');
    final match = regex.firstMatch(text);
    if (match != null) {
      // Extraemos el contenido del primer grupo de captura (lo que está dentro de los paréntesis)
      return match.group(1)!;
    } else {
      // Si no se encuentra ningún paréntesis, retornamos una cadena vacía o un mensaje de error
      return ''; // O puedes lanzar una excepción: throw Exception('No parentheses found');
    }
  }

  static String extractParameters(String function) {
    final List<String> values;
    values = function.split(':');
    return values.elementAt(1);
  }
}
