public with sharing class TaskTriggerHandler extends BaseTriggerHandler{
    protected override void beforeInsert(){
        List<Task> taskList = null;

        taskList = [SELECT WhatId FROM Task WHERE Status IN ('Not Started','In Progress', 'Waiting on someone else') 
                                                  AND whatId NOT IN :this.newList];

        if(!(taskList.isEmpty())){
            insert taskList;
        }
    }
}