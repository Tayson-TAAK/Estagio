public with sharing class OrderProductService {
    private TriggerUtil triggerUtil;
    private List<AssociatedLocation> newList;
    private List<AssociatedLocation> oldList;
    private Map<Id, AssociatedLocation> newMap;
    private Map<Id, AssociatedLocation> oldMap;

    public OrderProductService(OrderProductHandler triggerHandler) {
        this.triggerUtil = new TriggerUtil(triggerHandler);
        this.newList = (List<AssociatedLocation>)triggerHandler.newList;
        this.oldList = (List<AssociatedLocation>)triggerHandler.oldList;
        this.newMap = (Map<Id, AssociatedLocation>) triggerHandler.newMap;
        this.oldMap = (Map<Id, AssociatedLocation>) triggerHandler.oldMap;
    }

    public void afterInsert(){

    }

    public void afterUpdate(){ 

    }
}