void main() {
  var dataAtual = DateTime.now();
  var diaAtual = 30;
  var mesAtual = dataAtual.month;
  var anoAtual = dataAtual.year;
  var primeiroDiaDoMes = DateTime(anoAtual, mesAtual, 1);
  var diaDaSemanaPrimeiroDia = primeiroDiaDoMes.weekday;

  print("| D | S | T | Q | Q | S | S |");

  var contadorDia = 1;
  var posicaoAtual = 1;

  for (var posicao = 1; posicao <= 42 && contadorDia <= diaAtual; posicao++) {
    var linha = "";

    for (var diaSemana = 1; diaSemana <= 7; diaSemana++) {
      if (posicaoAtual < diaDaSemanaPrimeiroDia) {
        linha += "    ";
      } else if (contadorDia <= diaAtual) {
        if (contadorDia < 10) {
          linha += "| ${contadorDia} ";
        } else {
          linha += "|${contadorDia} ";
        }
        contadorDia++;
      }
      posicaoAtual++;
    }

    print(linha + "|");

    if (contadorDia > diaAtual) {
      break;
    }
  }
}
