public with sharing class Reserva {
    //Atributos
    private Cliente cliente;
    private Restaurante restaurante;
    private Mesa mesa;
    private Integer quantidadePessoas;
    private LocalMesa localPreferencia;
    private PeriodoReserva periodo;
    private StatusReserva status;

    //Metodos de acesso
    public Cliente getCliente() { return cliente; }
    public Restaurante getRestaurante() { return restaurante; }
    public Mesa getMesa() { return mesa; }
    public Integer getQuantidadePessoas() { return quantidadePessoas; }
    public LocalMesa getLocalPreferencia() { return localPreferencia; }
    public PeriodoReserva getPeriodo() { return periodo; }
    public StatusReserva getStatus() { return status; }

    //Construtor
    public Reserva(Cliente cliente, Restaurante restaurante, Mesa mesa, 
                   Integer quantidadePessoas, LocalMesa localPreferencia, 
                   PeriodoReserva periodo, StatusReserva status) {
        this.cliente = cliente;
        this.restaurante = restaurante;
        this.mesa = mesa;
        this.quantidadePessoas = quantidadePessoas;
        this.localPreferencia = localPreferencia;
        this.periodo = periodo;
        this.status = status;
    }
    public Reserva(Cliente cliente, Restaurante restaurante, 
                   Integer quantidadePessoas, LocalMesa localPreferencia, 
                   PeriodoReserva periodo, StatusReserva status) {
        this.cliente = cliente;
        this.restaurante = restaurante;
        this.quantidadePessoas = quantidadePessoas;
        this.localPreferencia = localPreferencia;
        this.periodo = periodo;
        this.status = status;
    }
}