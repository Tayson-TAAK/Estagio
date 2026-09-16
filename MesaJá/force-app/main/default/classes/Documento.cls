public with sharing class Documento {
    //Atributos
    private final String cpf;

    //Metodos de acesso
    public String getCpf() { return cpf; }

    //Construtor
    public Documento(String cpf) {
        this.cpf = cpf;
    }
}