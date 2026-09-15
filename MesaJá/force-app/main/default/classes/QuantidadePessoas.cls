public with sharing class QuantidadePessoas {
    //Atributos
    private integer quantidade;

    //Metodos de acesso
    public integer getQuantidade() { return quantidade; }

    //Construtor
    public QuantidadePessoas(integer quantidade) {
        if(quantidade <= 0){
            throw new IllegalArgumentException('A quantidade de pessoas deve ser maior que 0');
        }
        this.quantidade = quantidade;
    }
}