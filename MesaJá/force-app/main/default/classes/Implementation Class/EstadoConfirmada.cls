public with sharing class EstadoConfirmada extends EstadoReserva {
    //Construtor
    public EstadoConfirmada() {
        super('CONFIRMADA');
    }

    //@Override Metodos
    public override void cancelar(){
        this.estadoAtual = 'CANCELADA';
    }
}