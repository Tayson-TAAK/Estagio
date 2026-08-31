//Criando objetos das classes
Conta contaC1 = new ContaCorrente(1000, 'Alberto');
Conta contaC2 = new ContaCorrente(2000, 'Bruna');

Conta contaP1 = new ContaPoupanca(500, 'Carlos');

contaC1.depositar(1000);
contaC2.depositar(2000);
contaP1.depositar(500);

//Exercício 19.1 — Trabalhando com listas
List<Conta> contas = new List<Conta>();
contas.add(contaC1);
contas.add(contaC2);
contas.add(contaP1);

Decimal totalTaxas = 0;
for(Conta c : contas) {
    totalTaxas += c.calcularTaxa();
    System.debug('Taxa da conta de ' + c.getNomeTitular() + ': ' + c.calcularTaxa());
}
System.debug('Total de taxas: ' + totalTaxas);

//Exercício 19.2 — Evitando contas duplicadas
Set<Integer> numeros = new Set<Integer>();
for(Conta c : contas) {
    if(numeros.contains(c.getNumeroConta())){
        System.debug('Número da conta já existe: ' + c.getNumeroConta());
    }else{
        numeros.add(c.getNumeroConta());
        System.debug('Número da conta adicionado: ' + c.getNumeroConta());
    }
}
System.debug('Números das contas: ' + numeros);

//Exercício 19.3 — Conta por número
Map<Integer, Conta> mapaContas = new Map<Integer, Conta>();
for(Conta c : contas) {
    mapaContas.put(c.getNumeroConta(), c);
}
System.debug('Conta com número 1000: ' + mapaContas.get(1000).getNomeTitular());
System.debug('Conta com número 500: ' + mapaContas.get(500).getNomeTitular());

//Exercício 19.4 — Cruzando coleções
for(Integer numero : numeros){
    Conta c = mapaContas.get(numero);
    System.debug('Número da conta: ' + numero + ', Titular: ' + c.getNomeTitular() + ', Saldo: ' + c.getSaldo());
}