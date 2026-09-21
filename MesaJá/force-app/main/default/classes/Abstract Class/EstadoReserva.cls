public with sharing abstract class EstadoReserva {
    //Atributos ============================================================================================================
    public String estadoAtual;

    //Construtor ===========================================================================================================
    public EstadoReserva(String estadoAtual) {
        this.estadoAtual = estadoAtual;
    }

    //Metodos ==============================================================================================================
    public virtual void confirmar(){}
    public virtual void cancelar(){}
    public virtual void promover(){}
}