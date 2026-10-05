public with sharing class Product_TriggerHandler extends BaseTriggerHandler {
    protected override void afterInsert(){
        List<PricebookEntry> listPriceEntry = new List<PricebookEntry>();
        List<CurrencyType> moedas = [SELECT IsoCode FROM CurrencyType WHERE IsActive = true];
        Pricebook2 price = [SELECT Id FROM Pricebook2 WHERE isStandard = true];


        for(Product2 product : (List<Product2>) this.newList){

            for(CurrencyType isoCode : moedas)
            {
                PricebookEntry pricebookEntry = new PricebookEntry(CurrencyIsoCode = isoCode.IsoCode,
                                                                    UnitPrice = 0,
                                                                    Product2Id = product.Id, 
                                                                    Pricebook2Id = price.Id);
                listPriceEntry.add(pricebookEntry);
            }
        }
        insert listPriceEntry;
    }
}