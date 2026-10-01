trigger Product_Trigger on Product2 (before insert) {
    new Product_TriggerHandler().run();
}