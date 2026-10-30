public with sharing class MarginService {
    private TriggerUtil triggerUtil;
    private List<Margin__c> newList;
    private List<Margin__c> oldList;
    
    public MarginService(MarginHandler triggerHandler) {
        this.triggerUtil = new TriggerUtil(triggerHandler);
        this.newList = (List<Margin__c>) triggerHandler.newList;
        this.oldList = (List<Margin__c>) triggerHandler.oldList;
    }
    
    public void beforeInsert() {
        //Gerando o texto que sera usado em Duplicate_Control_ID__c -----------------------------------------------------------------
        List<String> marginsToSearch = new List<String>();
        for(Margin__c margin : this.newList){
            String textToEnhance = '';
            if(margin.Product__c != null){
                textToEnhance += margin.Product__c;
            }
            if(margin.Account__c != null){
                textToEnhance += margin.Product__c == null ? '' + margin.Account__c : '-' + margin.Account__c;
            }
            if(margin.State__c != null){
                textToEnhance += margin.Product__c == null && margin.Account__c == null ? '' + margin.State__c : '-' + margin.State__c;
            }

            if(textToEnhance != ''){
                margin.Duplicate_Control_ID__c = textToEnhance;
                marginsToSearch.add(margin.Duplicate_Control_ID__c);
            }else{
                margin.Duplicate_Control_ID__c = null;
            }
        }
        
        //Verificando se existe duplicatas na org -----------------------------------------------------------------------------------
        if(!marginsToSearch.isEmpty()){
            List<Margin__c> marginsDuplicatedOnOrg = [SELECT Duplicate_Control_ID__c FROM Margin__c WHERE Duplicate_Control_ID__c IN :marginsToSearch];
            for(Margin__c margin : this.newList){
                for(Margin__c marginOnOrg : marginsDuplicatedOnOrg){
                    if(margin.Duplicate_Control_ID__c == marginOnOrg.Duplicate_Control_ID__c){
                        margin.addError('There is already a margin with these specific characteristics');
                    }
                }
            }
        }

        
    }
}