public with sharing class ContaCorrente extends Conta {
    //Construtor
    public ContaCorrente(Integer numeroConta, String nomeTitular) {
        super(numeroConta, nomeTitular);
    }

    //Métodos
    public override Decimal calcularTaxa() {
        return this.getSaldo() * 0.01;
    }
}