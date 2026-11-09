/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest
private class OrderServiceTest {
    //Criaçao de objetos ---------------------------------------------------------------------
    //Account
    static List<Account> createAccount(Integer quantity, Id accGroupID){
        List<Account> listAccount = new List<Account>();
        for(Integer i = 0; i < quantity; i++){
           Account account = new Account(   
                                            Name = 'Account'+i,
                                            CNPJ__c = generateCNPJ(), //Gerar automaticamente [!]
                                            Account_Group__c = accGroupID
                                        ); 
           listAccount.add(account);
           System.debug(account);
        }
        return listAccount;
    }

    //Account Group
    static List<Account_Group__c> createAccountGroup(Integer quantity){
        List<Account_Group__c> listAccountGroup = new List<Account_Group__c>();
        for(Integer i = 0; i < quantity; i++){
            Account_Group__c accountGroup = new Account_Group__c(   
                                                                    Name = 'AccountGroup'+i,
                                                                    Code__c = 90000 + i
                                                                );
            listAccountGroup.add(accountGroup);
            System.debug(accountGroup);
        }
        return listAccountGroup;
    }

    //Metodos auxiliares ---------------------------------------------------------------------
    static void verifyDatabaseResult(List<Database.SaveResult> listDBResult, Boolean typeValidation){

        if(typeValidation == true) {
            for(Database.SaveResult dbResult : listDBResult){
                Assert.isTrue(dbResult.isSuccess());
            }
        }else if (typeValidation == false){
            for(Database.SaveResult dbResult : listDBResult){
                Assert.isFalse(dbResult.getErrors().size() != 0);
            }
        }
    }

    public static String generateCNPJ() {
        List<Integer> digits = new List<Integer>();
        
        // Gera os primeiros 12 dígitos aleatórios (de 0 a 9)
        for (Integer i = 0; i < 12; i++) {
            digits.add(Integer.valueOf(Math.floor(Math.random() * 10)));
        }

        // Cálculo do primeiro dígito verificador
        List<Integer> weightsFirst = new List<Integer>{5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
        Integer sum = 0;
        for (Integer i = 0; i < weightsFirst.size(); i++) {
            sum += digits[i] * weightsFirst[i];
        }

        Integer firstDigit = (Math.mod(sum, 11) < 2) ? 0 : 11 - Math.mod(sum, 11);
        digits.add(firstDigit);

        // Cálculo do segundo dígito verificador
        List<Integer> weightsSecond = new List<Integer>{6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
        sum = 0;
        for (Integer i = 0; i < weightsSecond.size(); i++) {
            sum += digits[i] * weightsSecond[i];
        }

        Integer secondDigit = (Math.mod(sum, 11) < 2) ? 0 : 11 - Math.mod(sum, 11);
        digits.add(secondDigit);

        String cnpj = '';
        for (Integer d : digits) {
            cnpj += String.valueOf(d);
        }
        return cnpj;
    }

    @IsTest
    static void myUnitTest() {
        List<Database.SaveResult> listDatabaseResult;

        //Account Group - Insert
        List<Account_Group__c> listAccountGroup = new List<Account_Group__c>();
        listAccountGroup.addAll(createAccountGroup(3));

        listDatabaseResult = Database.insert(listAccountGroup);
        verifyDatabaseResult(listDatabaseResult, true);

        //Account - Insert
        List<Account> listAccount = new List<Account>();
        listAccount.addAll(createAccount(3, listAccountGroup[0].Id));

        listDatabaseResult = Database.insert(listAccount);
        verifyDatabaseResult(listDatabaseResult, true);

        //Account - Update
        Account accountChanged = listAccount[0];
        accountChanged.Name = 'AccountUpdated';
        listAccount[0] = accountChanged;

        listDatabaseResult = Database.update(listAccount);
        verifyDatabaseResult(listDatabaseResult, true);
    }
}