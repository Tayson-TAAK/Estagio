public with sharing abstract class Conta {
    public static Integer totalDeContas = 0;

    //Atributos
    private Integer numeroConta;
    private String nomeTitular;
    private Decimal saldo;

    //Construtor
    public Conta(Integer numeroConta, String nomeTitular) {
        this.numeroConta = numeroConta;
        this.nomeTitular = nomeTitular;
        this.saldo = 0.0;
        totalDeContas++;
    }

    //Getters and Setters
    public Integer getNumeroConta() { return numeroConta; }
    public String getNomeTitular() { return nomeTitular; }
    public Decimal getSaldo() { return saldo; }

    public void setNumeroConta(Integer numeroConta) { this.numeroConta = numeroConta; }
    public void setNomeTitular(String nomeTitular) { this.nomeTitular = nomeTitular; }
    public void setSaldo(Decimal saldo) { this.saldo = saldo; }

    //Métodos
    public void depositar(Decimal valor) {
        ValidadorFinanceiro.validar(valor);
        this.saldo = this.saldo + valor;
    }

    //Métodos abstratos
    public abstract Decimal calcularTaxa();
}