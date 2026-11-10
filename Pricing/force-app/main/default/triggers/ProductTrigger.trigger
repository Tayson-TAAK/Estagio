trigger ProductTrigger on Product2 (before update) {
    new ProductHandler().run();
}