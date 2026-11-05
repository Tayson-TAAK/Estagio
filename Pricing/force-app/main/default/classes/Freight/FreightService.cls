public with sharing class FreightService {
    private TriggerUtil triggerUtil;
    private List<Freight__c> newList;
    private List<Freight__c> oldList;
    
    public FreightService(FreightHandler triggerHandler) {
        this.triggerUtil = new TriggerUtil(triggerHandler);
        this.newList = (List<Freight__c>) triggerHandler.newList;
        this.oldList = (List<Freight__c>) triggerHandler.oldList;
    }
    
    public void beforeInsert() {
        //Gerando o texto que sera usado em Duplicate_Control_ID__c -----------------------------------------------------------------
        List<String> freightToSearch = new List<String>();
        for(Freight__c freight : this.newList){
            String textToEnhance = '';
            if(freight.Product__c != null){
                textToEnhance += freight.Product__c;
            }
            if(freight.State__c != null){
                textToEnhance += freight.Product__c == null ? '' + freight.State__c : '-' + freight.State__c;
            }

            if(textToEnhance != ''){
                freight.Duplicate_Control_ID__c = textToEnhance;
                freightToSearch.add(freight.Duplicate_Control_ID__c);
            }else{
                freight.Duplicate_Control_ID__c = null;
            }
        }
        
        //Verificando se existe duplicatas na org -----------------------------------------------------------------------------------
        if(!freightToSearch.isEmpty()){
            List<Freight__c> freightDuplicatedOnOrg = [SELECT Duplicate_Control_ID__c FROM Freight__c WHERE Duplicate_Control_ID__c IN :freightToSearch];
            for(Freight__c freight : this.newList){
                for(Freight__c freightOnOrg : freightDuplicatedOnOrg){
                    if(freight.Duplicate_Control_ID__c == freightOnOrg.Duplicate_Control_ID__c){
                        freight.addError('[!] There is already a freight with these specific characteristics [!]');
                    }
                }
            }
        }
    }
}