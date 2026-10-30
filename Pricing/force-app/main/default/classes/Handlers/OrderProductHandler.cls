public with sharing class OrderProductHandler extends BaseTriggerHandler{
    private OrderProductService service = new OrderProductService(this);

    protected override void beforeInsert(){
        this.service.beforeInsert();
    }

    protected override void beforeUpdate(){
        this.service.beforeUpdate();
    }
}