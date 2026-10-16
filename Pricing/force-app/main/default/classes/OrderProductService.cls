public with sharing class OrderProductService {
    private TriggerUtil triggerUtil;
    private List<OrderItem> newList;
    private List<OrderItem> oldList;
    private Map<Id, OrderItem> newMap;
    private Map<Id, OrderItem> oldMap;

    public OrderProductService(OrderProductHandler triggerHandler) {
        this.triggerUtil = new TriggerUtil(triggerHandler);
        this.newList = (List<OrderItem>) triggerHandler.newList;
        this.oldList = (List<OrderItem>) triggerHandler.oldList;
        this.newMap = (Map<Id, OrderItem>) triggerHandler.newMap;
        this.oldMap = (Map<Id, OrderItem>) triggerHandler.oldMap;
    }

    public void beforeInsert(){
        Set<ID> idProducts = new Set<ID>;
        Set<ID> idProductsHierarchies = new Set<ID>;

        for(OrderItem orderP : this.newList){
            if(orderP.Product2Id != null){
                idProducts.add(orderP.Product2Id);
            }
        }
        Product2[] listProduct = [SELECT Id, Name, ProductCode, Product_Hierarchy__c, Production_Cost__c FROM Product2 WHERE ID IN :idProducts];

        

        Margin listMargin = [SELECT Value__c, Id 
                             FROM Margin__c 
                             WHERE Product__c IN :this.newList OR 
                                   Product_Hierarchy__c IN :this.newList];

        for(OrderItem orderP : this.newList){
            orderP.Product2;
        }



    }

    public void beforeUpdate(){ 

    }
}