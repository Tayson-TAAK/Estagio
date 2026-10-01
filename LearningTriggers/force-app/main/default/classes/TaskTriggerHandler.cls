public with sharing class TaskTriggerHandler extends BaseTriggerHandler{
    protected override void beforeInsert() {
        Set<Id> caseIds = new Set<Id>();

        for (Task novaTask : (List<Task>)this.newList) {
            if (novaTask.WhatId != null) {
                caseIds.add(novaTask.WhatId);
            }
        }

        Set<Id> casesTaskAberto = new Set<Id>();

        for (Task taskAbertos : [SELECT WhatId
                                 FROM Task
                                 WHERE WhatId IN :caseIds
                                 AND Status IN ('Not Started', 'In Progress', 'Waiting on someone else')]) 
        {
            casesTaskAberto.add(taskAbertos.WhatId);
        }

        for (Task novaTask : (List<Task>)this.newList) {
            if (casesTaskAberto.contains(novaTask.WhatId)) {
                novaTask.addError('Já existe uma tarefa em aberto nesse caso. Encerre-a antes de abrir uma nova');
            }
        }
    }
}