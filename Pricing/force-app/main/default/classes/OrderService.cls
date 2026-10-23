public with sharing class OrderService {
    private TriggerUtil triggerUtil;
    private List<Order> newList;
    private List<Order> oldList;
    
    public OrderService(OrderHandler triggerHandler) {
        this.triggerUtil = new TriggerUtil(triggerHandler);
        this.newList = (List<Order>) triggerHandler.newList;
        this.oldList = (List<Order>) triggerHandler.oldList;
    }
    public void beforeUpdate(){
        List<Order> listOrder = this.newList;
        List<Id> listOrderID = new List<Id>();

        for(Order o : listOrder){
            listOrderID.add(o.Id);
        }

        List<OrderItem> listOrderItem = [SELECT Final_Price__c, OrderId FROM OrderItem WHERE orderId IN : listOrderID];

        for(Order o : listOrder){
            o.Total_Price_with_Tax__c = 0;
            for(OrderItem orderP : listOrderItem){
                if(orderP.OrderId == o.Id){
                    o.Total_Price_with_Tax__c += orderP.Final_Price__c;
                }
            }
        }
    }
}