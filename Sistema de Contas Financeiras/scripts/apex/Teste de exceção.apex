// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

Conta conta = new ContaCorrente(1000, '123');

try {
    conta.sacar(5000);
} catch (SaldoInsuficienteException e) {
    System.debug(e.getMessage());
}

