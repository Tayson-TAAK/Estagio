public with sharing class AccountService {
    private TriggerUtil triggerUtil;
    private List<Account> newList;
    private List<Account> oldList;
    
    public AccountService(AccountHandler triggerHandler) {
        this.triggerUtil = new TriggerUtil(triggerHandler);
        this.newList = (List<Account>) triggerHandler.newList;
        this.oldList = (List<Account>) triggerHandler.oldList;
    }

    public void beforeInsert(){
        for(Account acc : this.newList){
            String cnpjCleaned = acc.CNPJ__c.trim().replaceAll('[./-]', '').toUpperCase();
            
            if(cnpjCleaned.length() != 14){
                acc.addError('[!] CNPJ has an invalid length [!]');
            } else { 
                List<Integer> charsCNPJ = cnpjCleaned.getChars();

                //Calcula o primeiro digito de validacao do CNPJ ------------------------------------------------------
                List<Integer> weightsFirstDigit = new List<Integer> {5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
                Integer sum = 0;

                for(Integer i = 0; i < weightsFirstDigit.size(); i ++){
                    sum += (charsCNPJ[i] - 48) * weightsFirstDigit[i]; 
                }

                Integer firstDigit = (Math.mod(sum, 11) < 2) ? 0 : 11 - Math.mod(sum, 11);

                //Calcula o segundo digito de validacao do CNPJ -------------------------------------------------------
                List<Integer> weightsSecondDigit = new List<Integer> {6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
                sum = 0;
                for(Integer i = 0; i < weightsSecondDigit.size(); i ++){
                    if(i == 12){
                        sum += firstDigit * weightsSecondDigit[i]; 
                    } else {
                        sum += (charsCNPJ[i] - 48) * weightsSecondDigit[i]; 
                    }
                }

                Integer secondDigit = (Math.mod(sum, 11) < 2) ? 0 : 11 - Math.mod(sum, 11);

                //Verifica se os digitos calculados batem com o digito fornecido pelo usuario -------------------------
                if(firstDigit != (charsCNPJ[12] - 48) || secondDigit != (charsCNPJ[13] - 48)){
                    acc.addError('[!] Invalid CNPJ [!]');
                } else {
                    acc.CNPJ__c = cnpjCleaned;
                }
            }
        }
    } 

    public void beforeUpdate(){
        beforeInsert();
    }
}