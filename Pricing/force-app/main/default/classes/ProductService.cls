public with sharing class ProductService {
    private TriggerUtil triggerUtil;
    private List<Product2> newList;
    private List<Product2> oldList;
    private Map<Id, Product2> newMap;
    private Map<Id, Product2> oldMap;
    
    public ProductService(ProductHandler triggerHandler) {
        this.triggerUtil = new TriggerUtil(triggerHandler);
        this.newList = (List<Product2>) triggerHandler.newList;
        this.oldList = (List<Product2>) triggerHandler.oldList;
        this.newMap = new Map<Id, Product2>();
        if (triggerHandler.newMap != null) {
            for (Id recordId : triggerHandler.newMap.keySet()) {
                this.newMap.put(recordId, (Product2) triggerHandler.newMap.get(recordId));
            }
        }
        
        this.oldMap = new Map<Id, Product2>();
        if (triggerHandler.oldMap != null) {
            for (Id recordId : triggerHandler.oldMap.keySet()) {
                this.oldMap.put(recordId, (Product2) triggerHandler.oldMap.get(recordId));
            }
        }
    }

    public void beforeInsert(){
        Integer qtdMargin = [SELECT COUNT() FROM Margin__c WHERE Product__c IN :this.newMap.keySet()];
        Integer qtdFreight = [SELECT COUNT() FROM Freight__c WHERE Product__c IN :this.newMap.keySet()];
        Integer qtdTax = [SELECT COUNT() FROM Tax__c WHERE Product__c IN :this.newMap.keySet()];

        for(Product2 p : this.newList){
            if(p.Production_Cost__c == null){
                p.Production_Cost__c.addError('Production Cost is required');
            }
            if(qtdMargin == 0){
                p.addError('No Margin record found for this Product');
            }
            if(qtdFreight == 0){
                p.addError('No Freight record found for this Product');
            }
            if(qtdTax == 0){
                p.addError('No Tax record found for this Product');
            }
        }
    }

    public void beforeUpdate(){   
    }
}