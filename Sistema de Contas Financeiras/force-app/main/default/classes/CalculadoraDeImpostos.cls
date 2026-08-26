public with sharing class CalculadoraDeImpostos {
    //Atributos
    List<Tributavel> tributaveis = new List<Tributavel>();

    //Construtor
    public CalculadoraDeImpostos(List<Tributavel> tributaveis) {
        this.tributaveis = tributaveis;
    }

    //Getters and Setters
    public List<Tributavel> getTributaveis() { return tributaveis; }
    public void setTributaveis(List<Tributavel> tributaveis) { this.tributaveis = tributaveis; }

    //Métodos
    public Decimal calcularImpostoTotal(){
        Decimal total = 0;
        for(Tributavel tributavel : tributaveis){
            total += tributavel.calcularImposto();         
        }
        return total;
    }
}