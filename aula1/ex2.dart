void main() {
    int mesInformado = 11;
    int mesAtual = DateTime.now().month;

    if (mesAtual > mesInformado) {
        print("Mês atual ${mesAtual} é maior que o mês informado ${mesInformado}.");
    } else if (mesAtual == mesInformado) {
        print("Mês atual ${mesAtual} é igual ao mês informado ${mesInformado}.");
    } else {
        print("Mês atual ${mesAtual} é menor que o mês informado ${mesInformado}.");
    }
}