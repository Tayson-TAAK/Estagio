// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

static void testBeforeInsertTaxAssignment(){
    // 1. Criar dados de teste (Produto)
    Product2 testProduct = new Product2(
        Name = 'Produto Teste', 
        IsActive = true
    );
    insert testProduct;

    // 2. Criar dados de teste (Imposto associado aßo produto)
    Tax__c testTax = new Tax__c(
        Name = 'Imposto Teste', 
        Product__c = testProduct.Id, 
        Tax_on_Cost__c = 15.50 // Valor de exemplo para o percentual
    );
    insert testTax;

    // 3. Criar uma Conta e um Pedido (Necessários para associar o OrderItem)
    Account testAcc = new Account(
        Name = 'Cliente Teste'
    );
    insert testAcc;

    Pricebook2 standardPricebook = new Pricebook2(
        Id = Test.getStandardPricebookId(), 
        IsActive = true
    );
    update standardPricebook;

    Order testOrder = new Order(
        AccountId = testAcc.Id, 
        EffectiveDate = Date.today(), 
        Status = 'Draft', 
        Pricebook2Id = standardPricebook.Id
    );
    insert testOrder;

    PricebookEntry testPbe = new PricebookEntry(
        Pricebook2Id = standardPricebook.Id, 
        Product2Id = testProduct.Id, 
        UnitPrice = 100.00, 
        IsActive = true
    );
    insert testPbe;

    // 4. Testar a inserção do OrderItem (Dispara o Before Insert)
    Test.startTest();
    OrderItem testOrderItem = new OrderItem(
        OrderId = testOrder.Id, 
        PricebookEntryId = testPbe.Id, 
        Quantity = 1, 
        UnitPrice = 100.00, 
        Product2Id = testProduct.Id
    );
    insert testOrderItem;
    Test.stopTest();

    // 5. Validar se o campo TaxPercentage__c foi preenchido corretamente
    OrderItem insertedItem = [SELECT Id, TaxPercentage__c
                              FROM OrderItem
                              WHERE Id = :testOrderItem.Id];
    System.assertEquals(15.50, insertedItem.TaxPercentage__c, 'O percentual de imposto deve ser atribuído corretamente.');
}