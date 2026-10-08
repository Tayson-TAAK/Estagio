public with sharing class AssociatedLocationTriggerHandler extends BaseTriggerHandler{
    private AssociatedLocationService service = new AssociatedLocationService(this);

    protected override void afterInsert(){
        this.service.afterInsert();
    }

    protected override void afterUpdate(){

        List<AssociatedLocation> alAntigo = this.oldList;

        for(AssociatedLocation al : (List<AssociatedLocation>) this.newList){
            for(AssociatedLocation alA : alAntigo){

                if( al.User__c != alA.User__c ){
                    this.service.afterUpdate_ChangeUser();
                }

                else if( al.ParentRecordId != alA.ParentRecordId){
                    this.service.afterUpdate_ChangeAccount();
                }
            }
        }
    }

    protected override void afterDelete(){
        this.service.afterDelete();
    }
}