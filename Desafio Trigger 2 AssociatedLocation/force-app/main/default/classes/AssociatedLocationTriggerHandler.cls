public with sharing class AssociatedLocationTriggerHandler extends BaseTriggerHandler{
    protected override void afterInsert(){
        // List<AssociatedLocation> alList = [SELECT Id, CreatedById FROM AssociatedLocation WHERE CreatedById IN :this.newList];

        // List<Id> userIdList = new List<Id>();
        // for(AssociatedLocation al : alList){
        //     userIdList.add(al.CreatedById);
        // }

        // List<Account> accList = [SELECT Id, Name, CreatedById FROM Account WHERE CreatedById IN :userIdList];

        // List<User> users = [SELECT Id, Name FROM User];

        // List<Account> accToAdd = null;
        // for(Id u : userIdList){
        //     if(!(accList.isEmpty())){
        //         Account account = new Account();
        //         account.Owner = users.indexOf(u);
        //         accToAdd.add(account);
        //     }
        // }
        // insert accToAdd;

        
    }
}