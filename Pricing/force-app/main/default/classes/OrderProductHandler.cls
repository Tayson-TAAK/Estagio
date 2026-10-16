public with sharing class OrderProductHandler extends BaseTriggerHandler{
    private OrderProductService service = new OrderProductService(this);

    protected override void afterInsert(){
        this.service.afterInsert();
    }

    protected override void afterUpdate(){
        this.service.afterUpdate();
    }
}