public with sharing class MenorMesaViavel implements PoliticaAlocacaoMesa {
    //Construtor
    public MenorMesaViavel() {
    }
    
    //Implementação do método da interface
    public Mesa selecionarMesa(List<Mesa> mesas, QuantidadePessoas qtdPessoa, LocalMesa localPreferencia, PeriodoReserva periodo) {
        Mesa mesaSelecionada = mesas.isEmpty() ? null : mesas[0];
        for (Mesa mesa : mesas){
            if(mesa.getCapacidade() < mesaSelecionada.getCapacidade() ){
                mesaSelecionada = mesa;
            }
        }
        return mesaSelecionada;
    }
}