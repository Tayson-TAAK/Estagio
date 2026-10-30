trigger Freight on Freight__c (before insert) {
    new FreightHandler().run();
}