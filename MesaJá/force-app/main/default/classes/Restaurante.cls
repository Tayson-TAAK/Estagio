public with sharing class Restaurante {
    //Atributos ============================================================================================================
    private String nome, endereco;
    private List<Mesa> mesas;
    private List<Reserva> reservas;
    private List<Reserva> listaEspera;

    //Metodos de acesso ====================================================================================================
    public String getNome() { return nome; }
    public String getEndereco() { return endereco; }
    public List<Mesa> getMesas() { return mesas; }
    public List<Reserva> getReservas() { return reservas; }
    public List<Reserva> getListaEspera() { return listaEspera; }

    //Construtor ===========================================================================================================
    public Restaurante(String nome, String endereco) {
        this.nome = nome;
        this.endereco = endereco;
        this.mesas = new List<Mesa>();
        this.reservas = new List<Reserva>();
        this.listaEspera = new List<Reserva>();
    }

    //Metodos ==============================================================================================================
    public void adicionarMesa(Mesa mesa){
        if(mesa.getCapacidade() > 0){
            for(Mesa m : mesas){
                if(m.getNumero() == mesa.getNumero()){
                    System.debug('Mesa já cadastrada');
                    return;
                }
            }
            mesas.add(mesa);
        }else{
            System.debug('Capacidade da mesa deve ser maior que 0');
        }
    }
    public void adicionarMesa(List<Mesa> mesasAdicionar){
        for(Mesa mesa : mesasAdicionar){
            adicionarMesa(mesa);
        }
    }
    //---------------//

    public List<Mesa> buscarDisponibilidade(Integer quantidadePessoas, LocalMesa localPreferencia){
        List<Mesa> mesasDisponiveis = new List<Mesa>();
        for(Mesa mesa : this.mesas){
            if(mesa.getCapacidade() >= quantidadePessoas && mesa.getLocal() == localPreferencia){
                mesasDisponiveis.add(mesa);
            }
        }

        if(mesasDisponiveis.isEmpty()){
            System.debug('Não há mesas disponíveis para a reserva');
        } else {
            System.debug('Mesas disponíveis: ' + mesasDisponiveis);
        }
        return mesasDisponiveis;
    }
    //---------------//

    public void criarReserva(Cliente cliente, Integer quantidadePessoas, LocalMesa localPreferencia, PeriodoReserva periodo, boolean aceitaListaEspera){
        List<Mesa> mesasDisponiveis = buscarDisponibilidade(quantidadePessoas, localPreferencia);
        Reserva reserva;
        Boolean isReservada = false;

        if(mesasDisponiveis.isEmpty()){
            System.debug('Não há mesas disponíveis para a reserva');
            GerenciadorReservas.criarReserva(cliente, this, quantidadePessoas, localPreferencia, periodo, aceitaListaEspera);
        } else {
            Mesa mesaSelecionada = new MenorMesaViavel().selecionarMesa(mesasDisponiveis, new QuantidadePessoas(quantidadePessoas), localPreferencia, periodo);

            for(Reserva r : reservas){
                if(r.getMesa() == mesaSelecionada){
                    System.debug('Mesa já reservada para o período selecionado');
                    isReservada = true;
                    break;
                }
            }

            if(isReservada){
                System.debug('Mesa já reservada para o período selecionado');
                GerenciadorReservas.criarReserva(cliente, this, quantidadePessoas, localPreferencia, periodo, aceitaListaEspera);
            } else {
                GerenciadorReservas.criarReserva(cliente, this, mesaSelecionada, quantidadePessoas, localPreferencia, periodo);
            }
        }  
    }
    //---------------//

    public void cancelarReserva(Reserva reserva){
        GerenciadorReservas.cancelarReserva(reserva, this);
    }

    //Classes Internas =====================================================================================================
    public class Reserva {
        //Atributos ========================================================================================================
        private Cliente cliente;
        private Restaurante restaurante;
        private Mesa mesa;
        private QuantidadePessoas qtdPessoa;
        private LocalMesa localPreferencia;
        private PeriodoReserva periodo;
        private EstadoReserva status;

        //Metodos de acesso ================================================================================================
        public Cliente getCliente() { return cliente; }
        public Restaurante getRestaurante() { return restaurante; }
        public Mesa getMesa() { return mesa; }
        public QuantidadePessoas getQtdPessoa() { return qtdPessoa; }
        public LocalMesa getLocalPreferencia() { return localPreferencia; }
        public PeriodoReserva getPeriodo() { return periodo; }
        public EstadoReserva getStatus() { return status; }

        //Construtores =====================================================================================================
        public Reserva(Cliente cliente, Restaurante restaurante, 
                    Mesa mesa, Integer qtdPessoa, LocalMesa localPreferencia, 
                    PeriodoReserva periodo, EstadoReserva status) {
            this.cliente = cliente;
            this.restaurante = restaurante;
            this.mesa = mesa;
            this.qtdPessoa = new QuantidadePessoas(qtdPessoa);
            this.localPreferencia = localPreferencia;
            this.periodo = periodo;
            this.status = status;
        }
        public Reserva(Cliente cliente, Restaurante restaurante, 
                    Integer qtdPessoa, LocalMesa localPreferencia, 
                    PeriodoReserva periodo, EstadoReserva status) {
            this.cliente = cliente;
            this.restaurante = restaurante;
            this.qtdPessoa = new QuantidadePessoas(qtdPessoa);
            this.localPreferencia = localPreferencia;
            this.periodo = periodo;
            this.status = status;
        }
    }
}