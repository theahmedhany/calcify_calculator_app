import 'package:calcify_calculator_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:math_expressions/math_expressions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> symbols = [
    'AC',
    '( )',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '−',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'Ans',
    '=',
  ];

  String input = '';
  String output = '';

  final List<String> operators = ['%', '÷', '×', '+', '−'];

  bool isLastCharOperator() {
    return operators.contains(input.isNotEmpty ? input[input.length - 1] : '');
  }

  bool hasUnclosedParenthesis() {
    return input.split('(').length > input.split(')').length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFF8F7),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 10),
            const CustomAppBar(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: Text(
                input,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff646D76),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                output,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff192032),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  if (input.isNotEmpty) {
                    setState(() {
                      input = input.substring(0, input.length - 1);
                    });
                  }
                },
                icon: const Icon(
                  Icons.backspace_outlined,
                  color: Color(0xff192032),
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: symbols.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (symbols[index] == 'AC') {
                      setState(() {
                        input = '';
                        output = '';
                      });
                    } else if (symbols[index] == '( )') {
                      setState(() {
                        if (hasUnclosedParenthesis()) {
                          input += ')';
                        } else {
                          input += '(';
                        }
                      });
                    } else if (symbols[index] == 'Ans') {
                      setState(() {
                        input = output.replaceAll("= ", "");
                        output = '';
                      });
                    } else if (operators.contains(symbols[index])) {
                      if (!isLastCharOperator()) {
                        setState(() {
                          input += symbols[index];
                        });
                      }
                    } else if (symbols[index] == '=') {
                      try {
                        String finalInput = input
                            .replaceAll('×', '*')
                            .replaceAll('÷', '/')
                            .replaceAll('−', '-');
                        Expression exp = Parser().parse(finalInput);
                        double result =
                            exp.evaluate(EvaluationType.REAL, ContextModel());
                        setState(() {
                          if (result == result.toInt()) {
                            output = "= ${result.toInt()}";
                          } else {
                            output = "= $result";
                          }
                        });
                      } catch (e) {
                        setState(() {
                          output = 'Error.';
                        });
                      }
                    } else {
                      setState(() {
                        input += symbols[index];
                      });
                    }
                  },
                  child: InnerShadow(
                    shadows: [
                      Shadow(
                        color: symbols[index] == 'AC'
                            ? Color.fromARGB(255, 46, 138, 148)
                            : const Color(0xff42C6D5),
                        blurRadius: 10,
                      )
                    ],
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: buttonsBackgroundColor(symbols[index]),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        symbols[index],
                        style: TextStyle(
                          color: buttonsTextColor(symbols[index]),
                          fontSize: (symbols[index] == 'Ans' ||
                                  symbols[index] == 'AC')
                              ? 24
                              : 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Color buttonsBackgroundColor(String symbol) {
    if (symbol == 'AC') {
      return const Color(0xff42C6D5);
    } else if (operators.contains(symbol) || symbol == '=' || symbol == '( )') {
      return const Color(0xffE6FBFE);
    } else {
      return const Color(0xff192032);
    }
  }

  Color buttonsTextColor(String symbol) {
    if (operators.contains(symbol) || symbol == '( )' || symbol == '=') {
      return const Color(0xff192032);
    } else {
      return Colors.white;
    }
  }
}
