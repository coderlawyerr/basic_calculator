import 'dart:math';

class Calculator {
  double toplama(List<double> sayilar) {
    return sayilar.reduce((a, b) => a + b);
  }

  double cikartma(List<double> sayilar) {
    return sayilar.reduce((a, b) => a - b);
  }

  double carpma(List<double> sayilar) {
    return sayilar.reduce((a, b) => a * b);
  }

  double bolme(List<double> sayilar) {
    if (sayilar.contains(0)) {
      return double.nan;
    } else {
      return sayilar.reduce((a, b) => a / b);
    }
  }

  double ustalma(List<double> sayilar) {
    if (sayilar.length < 2) {
      return double.nan; // En azından iki sayı gerekli
    } else {
      double sonuc = sayilar[0];
      for (int i = 1; i < sayilar.length; i++) {
        sonuc = pow(sonuc, sayilar[i]).toDouble();
      }
      return sonuc;
    }
  }

  double karekok(List<double> sayilar) {
    if (sayilar.isEmpty) {
      return double.nan; // Liste boş
    } else {
      double sonuc = 1;
      for (var sayi in sayilar) {
        sonuc *= sqrt(sayi);
      }
      return sonuc;
    }
  }
}
