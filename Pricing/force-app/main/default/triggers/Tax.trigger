trigger Tax on Tax__c (before insert) {
    new TaxHandler().run();
}