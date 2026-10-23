trigger ProductTrigger on Product2 (after insert, before update) {
    new ProductHandler().run();
}