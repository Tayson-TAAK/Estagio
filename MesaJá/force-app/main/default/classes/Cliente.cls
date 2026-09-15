public with sharing class Cliente {
    //Atributos
    private String nome, cpf;

    //Metodos de acesso
    public String getNome() { return nome; }
    public String getCpf() { return cpf; }

    //Construtor
    public Cliente(String nome, String cpf) {
        this.nome = nome;
        this.cpf = cpf;
    }
}