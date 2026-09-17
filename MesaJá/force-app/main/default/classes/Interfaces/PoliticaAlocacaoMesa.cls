public interface PoliticaAlocacaoMesa {
    Mesa selecionarMesa(List<Mesa> mesas, QuantidadePessoas qtdPessoa, LocalMesa localPreferencia, PeriodoReserva periodo);
}