// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:basic_calculator/color.dart';
import 'package:basic_calculator/i%C5%9Flemler/i%C5%9Flemler.dart';
import 'package:basic_calculator/widget/button.dart';

import 'package:flutter/material.dart';

class BasicCalculator extends StatefulWidget {
  const BasicCalculator({super.key});

  @override
  State<BasicCalculator> createState() => _BasicCalculatorState();
}

class _BasicCalculatorState extends State<BasicCalculator> {
  List<double> _extractNumbers(String input) {
    return [];
  }

  var userQuestion = ""; //kullanıcının  gırdıgı soruyu tutan  değişken
  var userAnswer = ""; // hesaplanan cevabı  tutan değişken
  late HesapMakinasi hesapMakinasi = HesapMakinasi();
  void hesapla() {
    List<double> numbers = _extractNumbers(userQuestion);
    if (userQuestion.contains('+')) {
      userAnswer = hesapMakinasi.toplama(numbers).toString();
    } else if (userQuestion.contains('-')) {
      userAnswer = hesapMakinasi.cikartma(numbers).toString();
    } else if (userQuestion.contains('x') || userQuestion.contains('*')) {
      userAnswer = hesapMakinasi.carpma(numbers).toString();
    } else if (userQuestion.contains('/')) {
      userAnswer = hesapMakinasi.bolme(numbers).toString();
    } else if (userQuestion.contains('^')) {
      userAnswer = hesapMakinasi.ustalma(numbers).toString();
    } else {
      // Diğer durumları kontrol et
    }
    //sonucu yazsıın
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<String> buttons = [
      "C",
      "Del",
      "()",
      "/",
      "7",
      "8",
      "9",
      "x",
      "4",
      "5",
      "6",
      "-",
      "1",
      "2",
      "3",
      "+",
      "0",
      "✓",
      "=",
      "^"
    ];
////verilen string bır operator mu  kontrol eden fonksıyon
    bool isOperator(String x) {
      if (x == 'C' ||
          x == 'Del' ||
          x == '()' ||
          x == '/' ||
          x == '9' ||
          x == '8' ||
          x == '7' ||
          x == '6' ||
          x == '5' ||
          x == '4' ||
          x == '3' ||
          x == '2' ||
          x == '1' ||
          x == '0' ||
          x == '✓' ||
          x == '+' ||
          x == '-' ||
          x == '=' ||
          x == '^' ||
          x == 'x') {
        return true;
      }
      return false;
    }

    // esıttır fonksıyonun ıslem yapıldıgı fonksıyon
    void equelPressed() {
      setState(() {
        hesapla();
      });
    }

/////////son karakterı sılen fonksıyon
    void deleteLastItem() {
      if (userQuestion == "") {
        return;
      } else {
        setState(() {
          userQuestion = userQuestion.substring(0, userQuestion.length - 1);
        });
      }
    }

//////ekranın temızlenmesını  sağlayan  ve degerını sıfırlayan fonksıyon
    void _onDoubleTap() {
      setState(() => userQuestion = "");
      setState(() => userAnswer = "");
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Spacer(),
                _userQuestion(userQuestion, Alignment.bottomRight),
                const SizedBox(height: 10),
                _userAnswer(userAnswer, Alignment.bottomRight),
                const SizedBox(height: 20),
              ],
            ),
          )),
          Expanded(
            flex: 2,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (context, index) {
                var button = buttons[index];
                // Clear
                if (index == 0) {
                  return CalculatorButton(
                    onTap: () => setState(() => userQuestion = ""),
                    onDoubleTap: _onDoubleTap,
                    buttonText: button,
                    color: isOperator(button) ? primaryColor : secondColor,
                    textColor: isOperator(button) ? textColor : textColor,
                  );
                  // Delete Last Item
                } else if (index == 1) {
                  return CalculatorButton(
                    onTap: deleteLastItem,
                    buttonText: buttons[index],
                    color: isOperator(button) ? primaryColor : secondColor,
                    textColor: isOperator(button) ? textColor : textColor,
                  );
                }
                // Equel
                else if (index == buttons.length - 1) {
                  return CalculatorButton(
                    buttonText: button,
                    onTap: () => setState(() => equelPressed()),
                    color: isOperator(button) ? primaryColor : secondColor,
                    textColor: isOperator(button) ? textColor : textColor,
                  );
                } else {
                  return CalculatorButton(
                    buttonText: button,
                    onTap: () => setState(() => userQuestion += buttons[index]),
                    color: isOperator(button) ? primaryColor : secondColor,
                    textColor: isOperator(button) ? textColor : textColor,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

///// kullanıcının sorusunu gosteren fonksıyon
  Container _userAnswer(String title, AlignmentGeometry alignment) {
    return Container(
      alignment: alignment,
      child: Text(
        title,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: answerTextColor,
            ),
      ),
    );
  }

// cevabı gosteren
  Container _userQuestion(String title, AlignmentGeometry alignment) {
    return Container(
        alignment: alignment,
        child: Text(
          title,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: questionTextColor.withOpacity(0.5),
              ),
        ));
  }
}
