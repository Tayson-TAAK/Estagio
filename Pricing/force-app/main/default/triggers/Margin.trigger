trigger Margin on Margin__c (before insert) {
    new MarginHandler().run();
}