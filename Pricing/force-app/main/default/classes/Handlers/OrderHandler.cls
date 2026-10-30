public with sharing class OrderHandler extends BaseTriggerHandler{
    private OrderService service = new OrderService(this);

    protected override void beforeUpdate(){
        this.service.beforeUpdate();
    }
}