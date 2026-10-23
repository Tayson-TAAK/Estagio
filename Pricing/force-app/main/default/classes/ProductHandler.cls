public with sharing class ProductHandler extends BaseTriggerHandler{
    private ProductService service = new ProductService(this);

    protected override void afterInsert(){
        this.service.afterInsert();
    }

    protected override void beforeUpdate(){
        this.service.beforeUpdate();
    }
}