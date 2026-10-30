public with sharing class FreightHandler extends BaseTriggerHandler{
    private FreightService service = new FreightService(this);

    protected override void beforeInsert(){
        this.service.beforeInsert();
    }
}