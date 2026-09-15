public with sharing class Mesa {
    //Atributos
    private Integer numero;
    private Integer capacidade;
    private LocalMesa local;
    
    //Metodos de acesso
    public Integer getNumero() { return numero; }
    public Integer getCapacidade() { return capacidade; }
    public LocalMesa getLocal() { return local; }

    //Construtor
    public Mesa(Integer numero, Integer capacidade, LocalMesa local) {
        this.numero = numero;
        this.capacidade = capacidade;
        this.local = local;
    }
}