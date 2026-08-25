public class ContaPoupanca extends Conta {
    public ContaPoupanca(Integer numeroConta, String nomeTitular) {
        super(numeroConta, nomeTitular);
    }

    public override Decimal calcularTaxa(){
        return this.getSaldo() * 0.05;
    }
}