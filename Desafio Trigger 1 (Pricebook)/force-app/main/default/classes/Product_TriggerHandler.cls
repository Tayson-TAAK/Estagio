public with sharing class Product_TriggerHandler extends BaseTriggerHandler {
    protected override void beforeInsert(){
        List<Pricebook2> listPrice = new List<Pricebook2>();
        List<PricebookEntry> listPriceEntry = new List<PricebookEntry>();

        for(Product2 product : (List<Product2>) this.newList){
            Pricebook2 pricebook = new Pricebook2();
            pricebook.Name = product.Name;

            listPrice.add(pricebook);

            for(CurrencyType isoCode : [SELECT IsoCode
                                  FROM CurrencyType
                                  WHERE IsActive = true] )
            {
                PricebookEntry pricebookEntry = new PricebookEntry();
                pricebookEntry.isActive = true;
                pricebookEntry.CurrencyIsoCode = isoCode.IsoCode;
                pricebookEntry.UnitPrice = 0;
                pricebookEntry.Pricebook2 = pricebook;
                pricebookEntry.Product2 = product;
                pricebookEntry.UseStandardPrice = true;

                listPriceEntry.add(pricebookEntry);
            }
        }

        insert listPrice;
        insert listPriceEntry;
    }
}