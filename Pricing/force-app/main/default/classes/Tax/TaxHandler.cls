public with sharing class TaxHandler extends BaseTriggerHandler{
    private TaxService service = new TaxService(this);

    protected override void beforeInsert(){
        this.service.beforeInsert();
    }
}