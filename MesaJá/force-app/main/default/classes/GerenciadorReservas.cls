public with sharing class GerenciadorReservas {
    //Construtor
    public GerenciadorReservas() {}

    //Metodos
    public static Restaurante.Reserva criarReserva(Cliente cliente, Restaurante restaurante, Integer qtdPessoas, LocalMesa localPreferencia, PeriodoReserva periodo, boolean aceitaListaEspera) {
        if(aceitaListaEspera){ 
            Restaurante.Reserva reserva = new Restaurante.Reserva(cliente, restaurante, qtdPessoas, localPreferencia, periodo, new EstadoPendente());
            restaurante.getListaEspera().add(reserva);
            System.debug('Reserva adicionada à lista de espera');
            return reserva;
        }
        return null;
    }
    public static Restaurante.Reserva criarReserva(Cliente cliente, Restaurante restaurante, Mesa mesa, Integer qtdPessoas, LocalMesa localPreferencia, PeriodoReserva periodo) {
        Restaurante.Reserva reserva = new Restaurante.Reserva(cliente, restaurante, mesa, qtdPessoas, localPreferencia, periodo, new EstadoConfirmada());
        restaurante.getReservas().add(reserva);
        System.debug('Reserva confirmada com sucesso');
        return reserva;
    }

    public static void cancelarReserva(Restaurante.Reserva reserva, Restaurante restaurante) {
        if(restaurante.getReservas().contains(reserva)){
            restaurante.getReservas().remove(restaurante.getReservas().indexOf(reserva));
            System.debug('Reserva cancelada com sucesso');

            for(Restaurante.Reserva r : restaurante.getListaEspera()){
                if(r.getMesa() == reserva.getMesa() && r.getPeriodo() == reserva.getPeriodo()){
                    restaurante.getReservas().add(r);
                    restaurante.getListaEspera().remove(restaurante.getListaEspera().indexOf(r));
                    System.debug('Reserva da lista de espera confirmada com sucesso');
                    break;
                }
            }
        } else if(restaurante.getListaEspera().contains(reserva)){
            restaurante.getListaEspera().remove(restaurante.getListaEspera().indexOf(reserva));
            System.debug('Reserva na lista de espera cancelada com sucesso');
        } else {
            System.debug('Reserva não encontrada'); 
        }
    }
}