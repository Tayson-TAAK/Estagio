public with sharing class MarginHandler extends BaseTriggerHandler{
    private MarginService service = new MarginService(this);

    protected override void beforeInsert(){
        this.service.beforeInsert();
    }
}