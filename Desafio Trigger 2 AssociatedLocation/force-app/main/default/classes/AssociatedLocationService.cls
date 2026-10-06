public with sharing class AssociatedLocationService {
    private TriggerUtil triggerUtil;
    private List<AssociatedLocation> newList;
    private List<AssociatedLocation> oldList;
    private Map<Id, AssociatedLocation> newMap;
    private Map<Id, AssociatedLocation> oldMap;

    public AssociatedLocationService(AssociatedLocationTriggerHandler triggerHandler) {
        this.triggerUtil = new TriggerUtil(triggerHandler);
        this.newList = (List<AssociatedLocation>)triggerHandler.newList;
        this.oldList = (List<AssociatedLocation>)triggerHandler.oldList;
        this.newMap = (Map<Id, AssociatedLocation>) triggerHandler.newMap;
        this.oldMap = (Map<Id, AssociatedLocation>) triggerHandler.oldMap;
    }

    public void afterInsert(){
        /*
            Testar se esta funcionando conforme solicitado no documento
        */
        List<AccountTeamMember> accMember = [SELECT UserId FROM AccountTeamMember];

        List<AssociatedLocation> alList = this.newList;

        List<AssociatedLocation> tempAL = null;
        Boolean flag = true;
        for(AccountTeamMember atm : accMember){
            for(AssociatedLocation al : alList){
                if(atm.UserId == al.User__c){
                    flag = false;
                    tempAL.add(al);
                }
            }
        }

        List<AccountTeamMember> addAccMember = null;
        if(flag == false){
            for(AssociatedLocation al : tempAL){
                AccountTeamMember tempATM = new AccountTeamMember(AccountId = al.User__c);
                addAccMember.add(tempATM);
            }
            insert addAccMember;
        }
    }

    public void afterUpdateUser(){
        /*
            Testar se esta funcionando conforme solicitado no documento
         */

        List<AssociatedLocation> alNovo = this.newList;

        Set<Id> userIds = new Set<Id>();
        for (AssociatedLocation al : alNovo) {
            if (al.User__c != null) {
                userIds.add(al.User__c);
            }
        }

        List<AssociatedLocation> alAntigo = [
            SELECT Id, User__c
            FROM AssociatedLocation
            WHERE User__c NOT IN :userIds
        ];

        List<AccountTeamMember> addATM = null;
        for(AssociatedLocation al : alNovo){
            for(AssociatedLocation alAnt : alAntigo){
                if(al.User__c != alAnt.User__c){
                    AccountTeamMember tempATM = new AccountTeamMember(AccountId = al.User__c);
                    addATM.add(tempATM);
                }
            }
        }

        insert addATM;
    }

    public void afterUpdateAccount(){
        Map<Id, AssociatedLocation> alMapNovo = (Map<Id, AssociatedLocation>) this.newMap;
        Map<Id, AssociatedLocation> alMapAntigo = (Map<Id, AssociatedLocation>) this.oldMap;


        Set<Id> chaves = alMapNovo.keySet();
        Boolean flag;
        for(Id i : chaves){
            flag = true;

            if(alMapNovo.get(i).ParentRecordId != alMapAntigo.get(i).ParentRecordId){
                flag = false;
            }
            
            if(!flag){
                List<AssociatedLocation> auxAl = [SELECT Id, User__c 
                                                  FROM AssociatedLocation 
                                                  WHERE User__c = :alMapAntigo.get(i).User__c];
                
                
            }
        }
    }
}