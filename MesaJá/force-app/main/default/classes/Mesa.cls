public with sharing class Mesa {
    //Atributos
    private IdentificadorMesa numero;
    private final QuantidadePessoas capacidade;
    private LocalMesa local;
    
    //Metodos de acesso
    public IdentificadorMesa getNumero() { return numero; }
    public QuantidadePessoas getCapacidade() { return capacidade; }
    public LocalMesa getLocal() { return local; }

    //Construtor
    public Mesa(Integer numero, Integer capacidade, LocalMesa local) {
        this.numero = new IdentificadorMesa(numero);
        this.capacidade = new QuantidadePessoas(capacidade);
        this.local = local;
    }
}