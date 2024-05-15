
import '../utilities/format.dart';

class Test {
  void test() {
    DateTime time = DateTime(2024, 5, 17);
    int a = time.millisecondsSinceEpoch;
    for (int i = 1; i <= 52; i++) {
      time = DateTime.fromMillisecondsSinceEpoch(
          time.millisecondsSinceEpoch + 604800000);
      print('''
    Pagaré No. ${i < 10 ? "0$i" : i}/52

Valle de las Palmas, Tecate Baja California a 15 de mayo del 2024
Carmen Alicia Ibarra Córdova.
Por este pagaré me obligo incondicionalmente a pagar a la orden del Sr. José Núñez Duarte, en Avenida Benito Juárez, parcela 64, Interior C, Valle De las Palmas, Tecate, Baja California, el día ${FormatDate.ddMonthYearTest(time)}, la cantidad de \$1,169.85 (un mil ciento sesenta y nueve pesos 85/100 M.N.)

Este pagare forma parte de una serie numerada del 1 al 52 y todos están sujetos a la condición de que al no pagarse cualquiera de ellos a su vencimiento, serán exigibles todos los que le sigan en número, además de los ya vencidos. Desde la fecha de vencimiento hasta el día de su liquidación, causara intereses moratorios al tipo de 2.5% mensual.

Acepta _____________________
    ''');
    }
  }
}