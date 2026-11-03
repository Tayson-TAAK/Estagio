public with sharing class AccountHandler extends BaseTriggerHandler{
    private AccountService service = new AccountService(this);

    protected override void beforeInsert(){
        this.service.beforeInsert();
    }

    protected override void beforeUpdate(){
        this.service.beforeUpdate();
    }
}