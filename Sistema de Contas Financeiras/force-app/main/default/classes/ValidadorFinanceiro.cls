public with sharing class ValidadorFinanceiro {
    //Construtor
    public ValidadorFinanceiro() {
    }

    //Métodos
    public static void validar(Decimal valor){
        if(valor <= 0){
            throw new IllegalArgumentException('O valor deve ser maior que zero.');
        }
    }
}