public with sharing class Restaurante {
    //Atributos
    private String nome, endereco;
    private List<Mesa> mesas;
    private List<Reserva> reservas;
    private List<Reserva> listaEspera;

    //Metodos de acesso
    public String getNome() { return nome; }
    public String getEndereco() { return endereco; }
    public List<Mesa> getMesas() { return mesas; }
    public List<Reserva> getReservas() { return reservas; }
    public List<Reserva> getListaEspera() { return listaEspera; }

    //Construtor
    public Restaurante(String nome, String endereco) {
        this.nome = nome;
        this.endereco = endereco;
        this.mesas = new List<Mesa>();
        this.reservas = new List<Reserva>();
        this.listaEspera = new List<Reserva>();
    }

    //Metodos
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

    public Reserva criarReserva(Cliente cliente, Integer quantidadePessoas, LocalMesa localPreferencia, PeriodoReserva periodo, boolean aceitaListaEspera){
        List<Mesa> mesasDisponiveis = buscarDisponibilidade(quantidadePessoas, localPreferencia);
        Mesa mesaSelecionada = mesasDisponiveis.isEmpty() ? null : mesasDisponiveis[0];
        Reserva reserva;
        Boolean isReservada = false;

        if(mesasDisponiveis.isEmpty()){
            System.debug('Não há mesas disponíveis para a reserva');
            if(aceitaListaEspera){ 
                reserva = new Reserva(cliente, this, quantidadePessoas, localPreferencia, periodo, StatusReserva.PENDENTE);
                listaEspera.add(reserva);
                return reserva;
            }
            return null;
        } else {
            for (Mesa mesa : mesasDisponiveis){
                if(mesa.getCapacidade() < mesaSelecionada.getCapacidade() ){
                    mesaSelecionada = mesa;
                }
            }

            for(Reserva r : reservas){
                if(r.getMesa() == mesaSelecionada){
                    System.debug('Mesa já reservada para o período selecionado');
                    isReservada = true;
                    break;
                }
            }

            if(isReservada){
                System.debug('Mesa já reservada para o período selecionado');
                if(aceitaListaEspera){ 
                    reserva = new Reserva(cliente, this, quantidadePessoas, localPreferencia, periodo, StatusReserva.PENDENTE);
                    listaEspera.add(reserva);
                }else{
                    return null;
                }
            } else {
                reserva = new Reserva(cliente, this, mesaSelecionada, quantidadePessoas, localPreferencia, periodo, StatusReserva.CONFIRMADA);
                reservas.add(reserva);
            }
            return reserva;
        }  
    }

    public void cancelarReserva(Reserva reserva){
        if(reservas.contains(reserva)){
            reservas.remove(reservas.indexOf(reserva));
            System.debug('Reserva cancelada com sucesso');

            for(Reserva r : listaEspera){
                if(r.getMesa() == reserva.getMesa() && r.getPeriodo() == reserva.getPeriodo()){
                    reservas.add(r);
                    listaEspera.remove(listaEspera.indexOf(r));
                    System.debug('Reserva da lista de espera confirmada com sucesso');
                    break;
                }
            }
        } else if(listaEspera.contains(reserva)){
            listaEspera.remove(listaEspera.indexOf(reserva));
            System.debug('Reserva na lista de espera cancelada com sucesso');
        } else {
            System.debug('Reserva não encontrada'); 
        }
    }

    public static Map<String, List<Reserva>> gerarRelatorioReservasConfirmadasPorCpf(List<String> cpfs, List<Restaurante> restaurantes){
        
        Map<String, List<Reserva>> relatorio = new Map<String, List<Reserva>>();
        for(String cpf : cpfs){
            List<Reserva> reservasConfirmadas = new List<Reserva>();
            for(Restaurante restaurante : restaurantes){
                for(Reserva reserva : restaurante.getReservas()){
                    if((reserva.getCliente()).getDocumento().getCpf() == cpf && reserva.getStatus() == StatusReserva.CONFIRMADA){
                        reservasConfirmadas.add(reserva);
                    }
                }
            }
            relatorio.put(cpf, reservasConfirmadas);
            System.debug('Relatório de reservas confirmadas para o CPF ' + cpf + ': ' + reservasConfirmadas);
        }
        return relatorio;
    }

    //Classes Internas
    public with sharing class Reserva {
        //Atributos
        private Cliente cliente;
        private Restaurante restaurante;
        private Mesa mesa;
        private QuantidadePessoas qtdPessoa;
        private LocalMesa localPreferencia;
        private PeriodoReserva periodo;
        private StatusReserva status;

        //Metodos de acesso
        public Cliente getCliente() { return cliente; }
        public Restaurante getRestaurante() { return restaurante; }
        public Mesa getMesa() { return mesa; }
        public QuantidadePessoas getQtdPessoa() { return qtdPessoa; }
        public LocalMesa getLocalPreferencia() { return localPreferencia; }
        public PeriodoReserva getPeriodo() { return periodo; }
        public StatusReserva getStatus() { return status; }

        //Construtor
        private Reserva(Cliente cliente, Restaurante restaurante, 
                    Mesa mesa, Integer qtdPessoa, LocalMesa localPreferencia, 
                    PeriodoReserva periodo, StatusReserva status) {
            this.cliente = cliente;
            this.restaurante = restaurante;
            this.mesa = mesa;
            this.qtdPessoa = new QuantidadePessoas(qtdPessoa);
            this.localPreferencia = localPreferencia;
            this.periodo = periodo;
            this.status = status;
        }
        private Reserva(Cliente cliente, Restaurante restaurante, 
                    Integer qtdPessoa, LocalMesa localPreferencia, 
                    PeriodoReserva periodo, StatusReserva status) {
            this.cliente = cliente;
            this.restaurante = restaurante;
            this.qtdPessoa = new QuantidadePessoas(qtdPessoa);
            this.localPreferencia = localPreferencia;
            this.periodo = periodo;
            this.status = status;
        }
    }
}