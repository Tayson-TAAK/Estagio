trigger Product_Trigger on Product2 (after insert) {
    new Product_TriggerHandler().run();
}