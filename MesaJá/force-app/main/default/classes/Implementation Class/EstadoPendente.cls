public with sharing class EstadoPendente extends EstadoReserva{
    //Construtor ===========================================================================================================
    public EstadoPendente() {
        super('PENDENTE');
    }

    //@Override Metodos ====================================================================================================
    public override void cancelar(){
        this.estadoAtual = 'CANCELADA';
    }
    public override void confirmar(){
        this.estadoAtual = 'CONFIRMADA';
    }
}