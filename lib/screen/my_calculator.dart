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
  double userAnswer = 0; // hesaplanan cevabı  tutan değişken
  Calculator hesapmakinasi =
      Calculator(); //calculator  sınıfını import edıyoruz  hesapmakinası ile  o sınıftaki mate işlemleri cagrıyoruz

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
              //kullanıcının gırmıs oldugu text
              userQuestion,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              ///sonuc textı
              userAnswer.toString(),
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
          buildRow(
            [
              '(',
              ')',
            ],
          ),
          SizedBox(height: 95),
          buildExitButton(),
        ],
      ),
    );
  }

  Widget buildExitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // Çıkış butonunun işlevselliği buraya gelecek
          },
          child: Text(
            'Çıkış',
            style: const TextStyle(fontSize: 24),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors
                .black, // Çıkış butonunun rengini buradan ayarlayabilirsiniz
          ),
        ),
      ],
    );
  }

//butonları olsuturan satırları olusturur

  Widget buildRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons
          .map((button) => buildButton(button))
          .toList(), //her bır buld button lıste seklınde donduruyoruz
    );
  }

//tek  bır butonu olustururu
  Widget buildButton(String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (label == 'C') {
            //tum verieri siler
            userQuestion = '';
            userAnswer = 0.0;
          } else if (label == '=') {
            //hesaplama yapar
            calculate();
          } else if (label == 'Del') {
            //kullanıcının gırmıs oldugu en son verının silmesini sağlar
            if (userQuestion.isNotEmpty) {
              //kullanıcı gırmıs oldugu verı bos degılse
              userQuestion = userQuestion.substring(
                  //kullancının gırmıs oldugu verıyı substring ile  en son verısını sılen yer
                  0, //0. indeks silsin
                  userQuestion.length - 1 //en son verıden sılmesını sağlar
                  );
            }
          } else {
            userQuestion += label;
            //yukardakı hıc bır sarta uymazssa
            // kullanıcının gırısı ekranda goster
          }
        });
      },
      child: Text(
        //her bır butonun texı
        label,
        style: const TextStyle(fontSize: 24),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Colors.purple, // Buton rengini buradan ayarlayabilirsiniz
      ),
    );
  }

//hesaplama yapan bır fonk
  void calculate() {
    String cleanedInput = userQuestion.replaceAll(
        ' ', ''); // kullanıcın bosluk gırerse ou sıfırla

    if (cleanedInput.isEmpty) return; // Boş ifade kontrolü

    cleanedInput =
        evaluateParentheses(cleanedInput); // Parantezleri değerlendir

    List<String> tokens =
        tokenizeExpression(cleanedInput); // İfadeyi tokenlere ayır

    userAnswer = performOperation(tokens); // Matematiksel işlemleri yap

    setState(() {
      print('UserAnswer: $userAnswer'); // Kullanıcı cevabını yazdır
    });
  }

  String evaluateParentheses(String input) {
    // Parantez içindeki ifadeyi alır
    while (input.contains('(')) {
      //// parantez yakalar yoksa boş dondur
      String innerExpression =
          RegExp(r'\(([^()]+)\)').firstMatch(input)?.group(1) ?? '';

      // İfadeyi hesaplar ve sonucu bir dizeye dönüştürür
      String innerResult =
          performOperation(tokenizeExpression(innerExpression)).toString();

      // İfadeyi, ilk parantez içindeki ifadeyle değiştirir
      input = input.replaceFirst('($innerExpression)', innerResult);
    }
    return input;
  }

//ifadenin tokenleri olustururlur , bir matematik ifadesini parçalara bölen bir analiz yapar.
//
  List<String> tokenizeExpression(String expression) {
    ///tokn yaklar
    List<String> tokens =
        []; //Bu liste, ifadeyi parçalara ayırmak için kullanılacak.
    String currentToken =
        ''; // ifadeyi parçalara bölmek için kullanılacak geçici bir depolama alanıdır.

    ///mevcut ındex
    for (int i = 0; i < expression.length; i++) {
      //her bır karakterı kontrol etmek ıcın  dongu baslatılır
      String char = expression[
          i]; //e.dongu ifade uzerınde  her bır karakterı kontrol eder
      if (char == '+' ||
          char == '-' ||
          char == '*' ||
          char == '/' ||
          char == '^') {
        if (currentToken.isNotEmpty) {
          //Eğer currentToken içinde bir veri varsa (yani bir sayı veya sembol),
          // bu veri tokens listesine eklenir ve currentToken boş bir string olarak sıfırlanır.
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
        currentToken += char; //Eğer karakter bir operatör veya karekök sembolü
        //değilse, bu karakteri currentToken'a ekler.
      }
    }
    if (currentToken.isNotEmpty) {
      tokens.add(currentToken); //o ankı lıstesıne eklıyo
    }
    return tokens;
  }

  double performOperation(List<String> tokens) {
    //
    //bir dizeyi tokenize edilmiş hâliyle alır ve bu tokenler
    // aracılığıyla matematiksel işlemler yaparak sonucu döndürür.
    final List<double> numbers = []; // Hesaplama için sayıları depolayan liste
    final List<String> operators =
        []; // Kullanılacak operatörleri depolayan liste

    for (int i = 0; i < tokens.length; i++) {
      final token = tokens[i]; // İşlenecek token

      // Eğer token bir operatörse, operatör listesine ekler
      if (isOperator(token)) {
        operators.add(token);
      } else {
        // Token karekök işaretiyse
        if (token == '√') {
          // Bir sonraki token sayıysa karekök işlemini uygular
          //Eğer bir sonraki token bir sayı değilse veya bir operatörse,
          // karekök işlemi yapılıyor ve sonucu numbers listesine ekleniyor.
          if (i + 1 < tokens.length && !isOperator(tokens[i + 1])) {
            numbers.add(hesapmakinasi.karekok([double.parse(tokens[++i])]));
          }
        } else {
          // Token bir sayıysa, sayı listesine ekler
          numbers.add(double.parse(token)); //tokun double cınsınden
          /// pars eder number lıstesıne eklenır

          //"Eğer operatörler dizisi boş değilse ve bir sonraki elemanın indeksi mevcut dizinin uzunluğundan
          //küçükse ve bir sonraki eleman bir operatör değilse, işlem yap."
          if (operators.isNotEmpty &&
              i + 1 < tokens.length &&
              !isOperator(tokens[i + 1])) {
            applyOperator(numbers, operators);
          }
        }
      }
    }

    // Operatörlerin kalmışsa uygulanması
    while (operators.isNotEmpty) {
      applyOperator(numbers, operators);
    }

    // Hesaplama sonucunu döndürür
    return numbers.first;
  }

  void applyOperator(List<double> numbers, List<String> operators) {
    if (numbers.length < 2) {
      // İşlem için yeterli sayıda eleman yoksa, işlem yapma
      return;
    }
    //işlem bol baslamasın fln
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

    ///
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
