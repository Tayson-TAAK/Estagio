public with sharing class CadastroDeContas {
    //Atributos
    List<Conta> contas = new List<Conta>();

    //Construtor
    public CadastroDeContas() {
        this.contas = new List<Conta>();
    }

    //Getters and Setters
    public List<Conta> getContas() { return contas; }
    public void setContas(List<Conta> contas) { this.contas = contas; }

    //Métodos
    public void adicionarConta(Conta conta) {
        this.contas.add(conta);
    }

    public void exibirContas(){
        for(Conta conta : contas){
            System.debug('Número da Conta: ' + conta.getNumeroConta());
            System.debug('Nome do Titular: ' + conta.getNomeTitular());
            System.debug('Saldo: ' + conta.getSaldo());
        }
    }

    public Decimal calcularTaxaTotal(List<Conta> contas){
        return 0;
    }
}