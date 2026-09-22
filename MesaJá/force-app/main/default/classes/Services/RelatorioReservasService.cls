public with sharing class RelatorioReservasService {
    //Construtor ======================================================================================================
    public RelatorioReservasService() { }

    //Metodos =========================================================================================================
    public static Map<Documento, List<Restaurante.Reserva>> gerarRelatorioReservasConfirmadasPorCpf(List<Documento> cpfs, List<Restaurante> restaurantes){
        
        Map<Documento, List<Restaurante.Reserva>> relatorio = new Map<Documento, List<Restaurante.Reserva>>();

        for(Documento cpf : cpfs){
            relatorio.put(cpf, new List<Restaurante.Reserva>());
        }

        for(Restaurante restaurante : restaurantes){
            for(Restaurante.Reserva reserva : restaurante.getReservas()){
                Documento cpfReserva = reserva.getCliente().getDocumento();
                if(relatorio.containsKey(cpfReserva) && reserva.getStatus().estadoAtual == 'CONFIRMADA'){
                    relatorio.get(cpfReserva).add(reserva);
                }
            }
        }
        return relatorio;
    }
}