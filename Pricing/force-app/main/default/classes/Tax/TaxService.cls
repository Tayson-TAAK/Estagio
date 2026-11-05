public with sharing class TaxService {
    private TriggerUtil triggerUtil;
    private List<Tax__c> newList;
    private List<Tax__c> oldList;
    
    public TaxService(TaxHandler triggerHandler) {
        this.triggerUtil = new TriggerUtil(triggerHandler);
        this.newList = (List<Tax__c>) triggerHandler.newList;
        this.oldList = (List<Tax__c>) triggerHandler.oldList;
    }
    
    public void beforeInsert() {
        //Gerando o texto que sera usado em Duplicate_Control_ID__c -----------------------------------------------------------------
        List<String> taxToSearch = new List<String>();
        for(Tax__c tax : this.newList){
            String textToEnhance = '';
            if(tax.Product__c != null){
                textToEnhance += tax.Product__c;
            }
            if(tax.State__c != null){
                textToEnhance += tax.Product__c == null ? '' + tax.State__c : '-' + tax.State__c;
            }

            if(textToEnhance != ''){
                tax.Duplicate_Control_ID__c = textToEnhance;
                taxToSearch.add(tax.Duplicate_Control_ID__c);
            }else{
                tax.Duplicate_Control_ID__c = null;
            }
        }
        
        //Verificando se existe duplicatas na org -----------------------------------------------------------------------------------
        if(!taxToSearch.isEmpty()){
            List<Tax__c> taxDuplicatedOnOrg = [SELECT Duplicate_Control_ID__c FROM Tax__c WHERE Duplicate_Control_ID__c IN :taxToSearch];
            for(Tax__c tax : this.newList){
                for(Tax__c taxOnOrg : taxDuplicatedOnOrg){
                    if(tax.Duplicate_Control_ID__c == taxOnOrg.Duplicate_Control_ID__c){
                        tax.addError('[!] There is already a tax with these specific characteristics [!]');
                    }
                }
            }
        }
    }
}