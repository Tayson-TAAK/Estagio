public with sharing class RelatorioReservasService {
    //Construtor ======================================================================================================
    public RelatorioReservasService() { }

    //Metodos =========================================================================================================
    public static Map<String, List<Restaurante.Reserva>> gerarRelatorioReservasConfirmadasPorCpf(List<String> cpfs, List<Restaurante> restaurantes){
        
        Map<String, List<Restaurante.Reserva>> relatorio = new Map<String, List<Restaurante.Reserva>>();
        for(String cpf : cpfs){
            relatorio.clear();
            List<Restaurante.Reserva> reservasConfirmadas = new List<Restaurante.Reserva>();
            for(Restaurante restaurante : restaurantes){
                for(Restaurante.Reserva reserva : restaurante.getReservas()){
                    if((reserva.getCliente()).getDocumento().getCpf() == cpf && reserva.getStatus().estadoAtual == 'CONFIRMADA'){
                        reservasConfirmadas.add(reserva);
                    }
                }
            }
            relatorio.put(cpf, reservasConfirmadas);
            System.debug('Relatório de reservas confirmadas para o CPF ' + cpf + ': ' + reservasConfirmadas);
        }
        return relatorio;
    }
}