import 'package:basic_calculator/color.dart';
import 'package:basic_calculator/calculator/colculator.dart';
import 'package:flutter/material.dart';

class BasicCalculator extends StatefulWidget {
  const BasicCalculator({super.key});

  @override
  State<BasicCalculator> createState() => _BasicCalculatorState();
}

class _BasicCalculatorState extends State<BasicCalculator> {
  String userQuestion = ""; //kullanıcının  gırdıgı soruyu tutan  değişken
  String userAnswer = ""; // hesaplanan cevabı  tutan değişken
  Calculator hesapmakinasi = Calculator(); //mat iş gerç sınıf

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              userQuestion,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              userAnswer,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          //butonu olusturmak için metodu çağırır
          buildRow(['C', 'Del', '/', '=']),
          buildRow(['7', '8', '9', '*']),
          buildRow(['4', '5', '6', '-']),
          buildRow(['1', '2', '3', '+']),
          buildRow(['.', '0', '^', '√']),
          buildRow([
            '(',
            ')',
          ]),
        ],
      ),
    );
  }

//butonları olsuturan satırları olusturur
  Widget buildRow(List<String> buttons) {
    //her bır butonu yan yana getırmesını sağlıyor
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) {
        return buildButton(button);
      }).toList(),
    );
  }

//tek  bır butonu olustururu
  Widget buildButton(String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (label == 'C') {
            userQuestion = '';
            userAnswer = '';
          } else if (label == '=') {
            calculate();
          } else if (label == 'Del') {
            if (userQuestion.isNotEmpty) {
              ///bos degılse
              userQuestion = userQuestion.substring(
                  0,
                  userQuestion.length -
                      1); //kullanıcıdan alacagımız verı en son yazdıgı kısmı sılmek
            }
          } else {
            userQuestion += label;

            ///kullanıcıdan aldıgım verıyle butondakı verıyı ekle
          }
        });
      },
      child: Text(
        label,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

//kullanıcının gırdııgı  ifadeyi hesaplar
  void calculate() {
    String cleanedInput = userQuestion.replaceAll(' ', ''); //boslugu sıl
    if (cleanedInput.isEmpty) {
      //eger bossa bos dondur
      return;
    }
    cleanedInput = evaluateParentheses(
        // e.parantezleri değ.işlem önceliği belır
        cleanedInput); //sılınıne ınput parantezlerı degerlendırlıen kullanıcı verısıne esıtlwenır
    List<String> tokens =
        tokenizeExpression(cleanedInput); // ifadeyi parçalayarak token donustr;
    userAnswer = performOperation(tokens)
        .toString(); // Operatörlerin ve sayıların listelerini kullanarak
    // matematiksel işlemleri sırayla yapıyor.
    setState(() {
      print('UserAnswer: $userAnswer');
    });
  }

//parantezleri değerlendirir ve işlem öncelikleri
  String evaluateParentheses(String input) {
    while (input.contains('(')) {
      RegExp exp = RegExp(r'\(([^()]+)\)');
      String innerExpression = exp.firstMatch(input)?.group(1) ?? '';
      String innerResult =
          performOperation(tokenizeExpression(innerExpression)).toString();
      input = input.replaceFirst('($innerExpression)', innerResult);
    }
    return input;
  }

//ifadenin tokenleri olustururlur
//
  List<String> tokenizeExpression(String expression) {
    List<String> tokens = [];
    String currentToken = ''; //string değişken

    ///mevcut ındex
    for (int i = 0; i < expression.length; i++) {
      //bır dongu baslatılır
      String char = expression[
          i]; //e.dongu ifade uzerınde  her bır karakterı kontrol eder
      if (char == '+' ||
          char == '-' ||
          char == '*' ||
          char == '/' ||
          char == '^') {
        if (currentToken.isNotEmpty) {
          tokens.add(currentToken);
          currentToken = '';
        }
        tokens.add(char);
      } else if (char == '√') {
        // Karekök sembolü için ayrı bir durum ekleyin
        if (currentToken.isNotEmpty) {
          tokens.add(currentToken);
          currentToken = '';
        }
        tokens.add('√');
      } else {
        currentToken += char;
      }
    }
    if (currentToken.isNotEmpty) {
      tokens.add(currentToken);
    }
    return tokens;
  }

////işlem yapar token lıstesını ısler
  double performOperation(List<String> tokens) {
    List<double> numbers = [];
    List<String> operators = [];

    for (int i = 0; i < tokens.length; i++) {
      String token = tokens[i];

      if (isOperator(token)) {
        // Eğer token bir operatörse, operators listesine ekle
        operators.add(token);
      } else {
        // Eğer token bir sayı veya karekök işareti ise, numbers listesine ekle
        if (token == '√') {
          // Eğer karekök işareti ise, bir sonraki elemanı al ve karekök işlemini uygula
          if (i + 1 < tokens.length && !isOperator(tokens[i + 1])) {
            numbers.add(hesapmakinasi.karekok([double.parse(tokens[i + 1])]));
            i++; // Bir sonraki elemanı geç
          }
        } else {
          // Eğer token bir sayı ise, numbers listesine ekle
          numbers.add(double.parse(token));

          // Operatör varsa ve bir sonraki sayı varsa, önceki operatörü uygula
          if (operators.isNotEmpty &&
              i + 1 < tokens.length &&
              !isOperator(tokens[i + 1])) {
            applyOperator(numbers, operators);
          }
        }
      }
    }

    // Kalan operatörleri uygula
    while (operators.isNotEmpty) {
      //işlemi operator listesi boşalana kadar  işlem yapar
      applyOperator(numbers, operators); //listelerini parametre olarak
      //alır ve listenin başındaki operatörü kullanarak işlem yapar.
    }

    // Sonuç döndür
    return numbers.first;
  }

  void applyOperator(List<double> numbers, List<String> operators) {
    if (numbers.length < 2) {
      // İşlem için yeterli sayıda eleman yoksa, işlem yapma
      return;
    }

    String operator = operators.removeAt(0);
//performOperation() fonksiyonunda token listesindeki her bir öğeyi değerlendirerek, operatörlerin
// kendine özgü işlemlerini gerçekleştirmektedir.
//ullanıcının girdiği matematiksel ifadeyi işlemek ve sonucunu hesaplamaktır. Bunun için kullanıcının girdiği ifadeyi parçalara ayırmak ve
// bu parçaları uygun matematiksel işlemlerle işlemek gerekiyor.
    switch (operator) {
      case '+':
        numbers[1] = hesapmakinasi.toplama([numbers[0], numbers[1]]);
        break;
      case '-':
        numbers[1] = hesapmakinasi.cikartma([numbers[0], numbers[1]]);
        break;
      case '*':
        numbers[1] = hesapmakinasi.carpma([numbers[0], numbers[1]]);
        break;
      case '/':
        numbers[1] = hesapmakinasi.bolme([numbers[0], numbers[1]]);
        break;
      case '^':
        numbers[1] = hesapmakinasi.ustalma([numbers[0], numbers[1]]);
        break;
      case '√': // Karekök operatörü eklendi
        if (numbers[0] >= 0) {
          numbers[0] = hesapmakinasi.karekok([numbers[0]]);
        } else {
          // Karekök işlemi negatif sayılara uygulanamaz
          throw const FormatException('Invalid square root operation');
        }
        break;
      default:
        break;
    }

    numbers.removeAt(0);
  }

  bool isOperator(String token) {
    //token bır operator olup olmadıgını kabul eder
    return token == '+' ||
        token == '-' ||
        token == '*' ||
        token == '/' ||
        token == '^';
  }
}
