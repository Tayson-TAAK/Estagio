public class ReservaComparator implements Comparator<Restaurante.Reserva> {
    public Integer compare(Restaurante.Reserva a, Restaurante.Reserva b) {
        Integer ordemA = getOrdemPeriodo(a.getPeriodo());
        Integer ordemB = getOrdemPeriodo(b.getPeriodo());

        if (ordemA != ordemB) {
            return ordemA < ordemB ? -1 : 1;
        }

        Integer qtdA = a.getQtdPessoa().getQuantidade();
        Integer qtdB = b.getQtdPessoa().getQuantidade();

        if (qtdA != qtdB) {
            return qtdA > qtdB ? -1 : 1;
        }
        return 0;
    }

    private Integer getOrdemPeriodo(PeriodoReserva periodo) {
        if (periodo == PeriodoReserva.MANHA) return 1;
        if (periodo == PeriodoReserva.TARDE) return 2;
        if (periodo == PeriodoReserva.NOITE) return 3;
        return 999;
    }
}