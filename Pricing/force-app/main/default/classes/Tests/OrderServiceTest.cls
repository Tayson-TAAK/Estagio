/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest
private class OrderServiceTest {
    //Criaçao de objetos ---------------------------------------------------------------------
    //Country
    static List<Country__c> createCountry(Integer quantity){
        List<Country__c> listCountry = new List<Country__c>();
        for(Integer i = 0; i < quantity; i++){
           Country__c country = new Country__c(   
                Name = 'Country' + i,
                Abbreviation__c = 'C' + i
            ); 

           listCountry.add(country);
        }
        return listCountry;
    }

    //State
    static List<State__c> createState(Integer quantity, Id countryId){
        List<State__c> listState = new List<State__c>();
        for(Integer i = 0; i < quantity; i++){
           State__c state = new State__c(   
                Name = 'State' + i,
                Abbreviation__c = 'S' + i,
                Country__c = countryId
            ); 

           listState.add(state);
        }
        return listState;
    }

    //City
    static List<City__c> createCity(Integer quantity, Id stateId){
        List<City__c> listCity = new List<City__c>();
        for(Integer i = 0; i < quantity; i++){
           City__c city = new City__c(   
                Name = 'City' + i,
                State__c = stateId,
                IBGE_Code__c = 10100 + i
            ); 

           listCity.add(city);
        }
        return listCity;
    }

    //Account
    static List<Account> createAccount(Integer quantity, Id accGroupID){
        List<Account> listAccount = new List<Account>();
        for(Integer i = 0; i < quantity; i++){
           Account account = new Account(   
                Name = 'Account'+i,
                CNPJ__c = generateCNPJ(),
                Account_Group__c = accGroupID
            ); 

           listAccount.add(account);
        }
        return listAccount;
    }

    //Account Group
    static List<Account_Group__c> createAccountGroup(Integer quantity){
        List<Account_Group__c> listAccountGroup = new List<Account_Group__c>();
        for(Integer i = 0; i < quantity; i++){
            Account_Group__c accountGroup = new Account_Group__c(   
                Name = 'AccountGroup'+i,
                Code__c = 90000 + i
            );

            listAccountGroup.add(accountGroup);
        }
        return listAccountGroup;
    }

    //Account Address
    static List<Account_Address__c> createAccountAddress(Integer quantity, Id accID, Id cityId){
        List<Account_Address__c> listAccountAddress = new List<Account_Address__c>();
        for(Integer i = 0; i < quantity; i++){
            Account_Address__c accountAddress = new Account_Address__c( 
                Name = 'Endereço' + i,
                Account__c = accID,
                Code__c = 8000 + i,
                City__c = cityId,
                Thoroughfare__c = 'Rua' + i,
                Postal_Code__c = 91000000 + i,
                Neighborhood__c = 'Vila' + i
            );

            listAccountAddress.add(accountAddress);
        }
        return listAccountAddress;
    }

    //Distribution Center
    static List<Distribution_Center__c> createDistributionCenter(Integer quantity){
        List<Distribution_Center__c> listDistributionCenter = new List<Distribution_Center__c>();
        for(Integer i = 0; i < quantity; i++){
            Distribution_Center__c distributionCenter = new Distribution_Center__c(   
                Name = 'Centro de Distribuição' + i,
                Name__c = 'Centro de Distribuição' + i,
                Code__c = 2000 + i
            );

            listDistributionCenter.add(distributionCenter);
        }
        return listDistributionCenter;
    }

    //Product
    static List<Product2> createProduct(Integer quantity){
        List<Product2> listProduct = new List<Product2>();
        for(Integer i = 0; i < quantity; i++){
            Product2 product = new Product2(    
                Name = 'Produto' + i ,
                Product_Hierarchy__c = 'a07g800000rmRNeAAM',
                Production_Cost__c = 12 * i + 1
            );

            listProduct.add(product);                             
        }
        return listProduct;
    }

    //Tax
    static List<Tax__c> createTax(Integer quantity, Id distributionCenterId, Id productId){
        List<Tax__c> listTax = new List<Tax__c>();
        for(Integer i = 0; i < quantity; i++){
            Tax__c tax = new Tax__c(   
                Name = 'Tax' + i,
                Distribution_Center__c = distributionCenterId,
                State__c = 'a03g800000sD9WDAA0',
                Status__c = 'Approved',
                Tax_on_Cost__c = 12 * i + 1,
                Product__c = productId
            );

            listTax.add(tax);
        }
        return listTax;
    }

    //Freight
    static List<Freight__c> createFreight(Integer quantity, Id distributionCenterId, Id productId, Id cityId){
        List<Freight__c> listFreight = new List<Freight__c>();
        for(Integer i = 0; i < quantity; i++){
            Freight__c freight = new Freight__c(
                Name = 'Frete'+i,
                Product__c = productId,
                Distribution_Center__c = distributionCenterId,
                Status__c = 'Approved',
                Value__c = 91 * i + 1,
                City__c = cityId
            );

            listFreight.add(freight);
        }
        return listFreight;
    }

    //Margin
    static List<Margin__c> createMargin(Integer quantity, Id distributionCenterId, Id productId, Id accountId, Id cityId){
        List<Margin__c> listMargin = new List<Margin__c>();
        for(Integer i = 0; i < quantity; i++){
            Margin__c margin = new Margin__c(
                Name = 'Margem'+i,
                Product__c = productId,
                Distribution_Center__c = distributionCenterId,
                Account__c = accountId,
                Status__c = 'Approved',
                Value__c = 0.12 * i + 1,
                City__c = cityId
            );

            listMargin.add(margin);
        }
        return listMargin;
    }

    //Contract
    static List<Contract> createContract(Integer quantity, Id accountId){
        List<Contract> listContract = new List<Contract>();
        for(Integer i = 0; i < quantity; i++){
            Contract contract = new Contract(
                AccountId = accountId,
                StartDate = Date.today(),
                ContractTerm = 10
            );

            listContract.add(contract);
        }
        return listContract;
    }

    //Payment Term
    static List<Payment_Term__c> createPaymentTerm(Integer quantity){
        List<Payment_Term__c> listPaymentTerm = new List<Payment_Term__c>();
        for(Integer i = 0; i < quantity; i++){
            Payment_Term__c paymentTerm = new Payment_Term__c(
                Name = 'TermoDePagamento' + i,
                Code__c = 190 * (i+1)
            );

            listPaymentTerm.add(paymentTerm);
        }
        return listPaymentTerm;
    }

    //Location
    static List<Schema.Location> createLocation(Integer quantity){
        List<Schema.Location> listLocation = new List<Schema.Location>();
        for(Integer i = 0; i < quantity; i++){
            Schema.Location location = new Schema.Location(
                Name = 'Enderço' + i
            );

            listLocation.add(location);
        }
        return listLocation;
    }

    //Address
    static List<Schema.Address> createAddress(Integer quantity, Id locationId){
        List<Schema.Address> listAddress = new List<Schema.Address>();
        for(Integer i = 0; i < quantity; i++){
            Schema.Address address = new Schema.Address(
                ParentId = locationId,
                City__c = 'a01g8000017EpNqAAK'
            );

            listAddress.add(address);
        }
        return listAddress;
    }

    //Order
    static List<Order> createOrder(Integer quantity, Id contractId, Id accountId, Id paymentTermId, Id distributionCenterId, Id addressId, Id pricebookStandardId){
        List<Order> listOrder = new List<Order>();
        for(Integer i = 0; i < quantity; i++){
            Order order = new Order(
                ContractId = contractId,
                AccountId = accountId,
                Payment_Term__c = paymentTermId,
                Shipping_Method__c = 'CIF',
                Distribution_Center__c = distributionCenterId,
                EffectiveDate = Date.today(),
                Delivery_Date__c = Date.today() + 1,
                Status = 'Draft', 
                Address__c = addressId,
                Pricebook2Id = pricebookStandardId
            );

            listOrder.add(order);
        }
        return listOrder;
    }

    //PricebookEntry
    static List<PricebookEntry> createPricebookEntry(Integer quantity, Id standardId, Product2 product){
        List<PricebookEntry> listPricebookEntry = new List<PricebookEntry>();
        for(Integer i = 0; i < quantity; i++){
            PricebookEntry pricebookEntry = new PricebookEntry(
                Pricebook2Id = standardId,
                Product2Id = product.Id,
                UnitPrice = product.Production_Cost__c + (100 / (10 - i)),
                IsActive = true
            );
            listPricebookEntry.add(pricebookEntry);
        }
        return listPricebookEntry;
    }

    //OrderProduct
    static List<OrderItem> createOrderItem(Integer quantity, Id productId, PricebookEntry pricebookEntry, Id orderId){
        List<OrderItem> listOrderItem = new List<OrderItem>();
        for(Integer i = 0; i < quantity; i++){
            OrderItem orderItem = new OrderItem(
                Product2Id = productId,
                Quantity = 1,
                PricebookEntryId = pricebookEntry.Id,
                OrderId = orderId,
                UnitPrice = pricebookEntry.UnitPrice
            );

            listOrderItem.add(orderItem);
        }
        return listOrderItem;
    }
    
    //Metodos auxiliares ---------------------------------------------------------------------
    static void verifyDatabaseResult(List<Database.SaveResult> listDBResult, Boolean typeValidation){
        for(Database.SaveResult dbResult : listDBResult){
            if(typeValidation == true) {
                Assert.isTrue(dbResult.isSuccess());
            } else if (typeValidation == false){
                Assert.isFalse(dbResult.isSuccess());
            } 
        }
    }

    public static String generateCNPJ() {
        List<Integer> digits = new List<Integer>();
        
        // Gera os primeiros 12 dígitos aleatórios (de 0 a 9)
        for (Integer i = 0; i < 12; i++) {
            digits.add(Integer.valueOf(Math.floor(Math.random() * 10)));
        }

        // Cálculo do primeiro dígito verificador
        List<Integer> weightsFirst = new List<Integer>{5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
        Integer sum = 0;
        for (Integer i = 0; i < weightsFirst.size(); i++) {
            sum += digits[i] * weightsFirst[i];
        }

        Integer firstDigit = (Math.mod(sum, 11) < 2) ? 0 : 11 - Math.mod(sum, 11);
        digits.add(firstDigit);

        // Cálculo do segundo dígito verificador
        List<Integer> weightsSecond = new List<Integer>{6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
        sum = 0;
        for (Integer i = 0; i < weightsSecond.size(); i++) {
            sum += digits[i] * weightsSecond[i];
        }

        Integer secondDigit = (Math.mod(sum, 11) < 2) ? 0 : 11 - Math.mod(sum, 11);
        digits.add(secondDigit);

        String cnpj = '';
        for (Integer d : digits) {
            cnpj += String.valueOf(d);
        }
        return cnpj;
    }

    @IsTest
    static void myUnitTest() {
        List<Database.SaveResult> listDatabaseResult;

        //Account Group - Insert ------------------------------------------------------------------
        List<Account_Group__c> listAccountGroup = new List<Account_Group__c>();
        listAccountGroup.addAll(createAccountGroup(3));

        listDatabaseResult = Database.insert(listAccountGroup);
        verifyDatabaseResult(listDatabaseResult, true);

        //Account - Insert ------------------------------------------------------------------------
        List<Account> listAccount = new List<Account>();
        listAccount.addAll(createAccount(3, listAccountGroup[0].Id));

        listDatabaseResult = Database.insert(listAccount);
        verifyDatabaseResult(listDatabaseResult, true);

        //Account - Update ------------------------------------------------------------------------
        Account accountChanged = listAccount[0];
        accountChanged.Name = 'AccountUpdated';
        listAccount[0] = accountChanged;

        listDatabaseResult = Database.update(listAccount);
        verifyDatabaseResult(listDatabaseResult, true);

        //Country ---------------------------------------------------------------------------------
        List<Country__c> listCountry = new List<Country__c>();
        listCountry.addAll(createCountry(1));

        listDatabaseResult = Database.insert(listCountry);
        verifyDatabaseResult(listDatabaseResult, true);

        //State -----------------------------------------------------------------------------------
        List<State__c> listState = new List<State__c>();
        listState.addAll(createState(1, listCountry[0].Id));

        listDatabaseResult = Database.insert(listState);
        verifyDatabaseResult(listDatabaseResult, true);

        //City ------------------------------------------------------------------------------------
        List<City__c> listCity = new List<City__c>();
        listCity.addAll(createCity(1, listState[0].Id));

        listDatabaseResult = Database.insert(listCity);
        verifyDatabaseResult(listDatabaseResult, true);

        //Account Address - Insert ----------------------------------------------------------------
        List<Account_Address__c> listAccountAddress = new List<Account_Address__c>();
        listAccountAddress.addAll(createAccountAddress(2, listAccount[0].Id, listCity[0].Id));

        listDatabaseResult = Database.insert(listAccountAddress);
        verifyDatabaseResult(listDatabaseResult, true);

        //Distribution Center ---------------------------------------------------------------------
        List<Distribution_Center__c> listDistributionCenter = new List<Distribution_Center__c>();
        listDistributionCenter.addAll(createDistributionCenter(2));

        listDatabaseResult = Database.insert(listDistributionCenter);
        verifyDatabaseResult(listDatabaseResult, true);

        //Location --------------------------------------------------------------------------------
        List<Schema.Location> listLocation = new List<Schema.Location>();
        listLocation.addAll(createLocation(2));

        listDatabaseResult = Database.insert(listLocation);
        verifyDatabaseResult(listDatabaseResult, true);

        //Address ---------------------------------------------------------------------------------
        List<Schema.Address> listAddress = new List<Schema.Address>();
        listAddress.addAll(createAddress(2, listLocation[0].Id));

        listDatabaseResult = Database.insert(listAddress);
        verifyDatabaseResult(listDatabaseResult, true);

        //Product - Insert ------------------------------------------------------------------------
        List<Product2> listProduct = new List<Product2>();
        listProduct.addAll(createProduct(3));

        listDatabaseResult = Database.insert(listProduct);
        verifyDatabaseResult(listDatabaseResult, true);
        
        //Tax -------------------------------------------------------------------------------------
        List<Tax__c> listTax = new List<Tax__c>();
        listTax.addAll(createTax(2, listDistributionCenter[0].Id, listProduct[0].Id));

        listDatabaseResult = Database.insert(listTax);
        verifyDatabaseResult(listDatabaseResult, true);

        //Freight ---------------------------------------------------------------------------------
        List<Freight__c> listFreight = new List<Freight__c>();
        listFreight.addAll(createFreight(2, listDistributionCenter[0].Id, listProduct[0].Id, listCity[0].Id));

        listDatabaseResult = Database.insert(listFreight);
        verifyDatabaseResult(listDatabaseResult, true);

        //Margin ----------------------------------------------------------------------------------
        List<Margin__c> listMargin = new List<Margin__c>();
        listMargin.addAll(createMargin(2, listDistributionCenter[0].Id, listProduct[0].Id, listAccount[0].Id, listCity[0].Id));

        listDatabaseResult = Database.insert(listMargin);
        verifyDatabaseResult(listDatabaseResult, true);

        //Product - Update ------------------------------------------------------------------------
        Product2 productChanged = listProduct[0];
        productChanged.Name = 'ProductUpdated';
        listProduct[0] = productChanged;

        listDatabaseResult = Database.update(listProduct);
        verifyDatabaseResult(listDatabaseResult, true);

        //Contract --------------------------------------------------------------------------------
        List<Contract> listContract = new List<Contract>();
        listContract.addAll(createContract(2, listAccount[0].Id));

        listDatabaseResult = Database.insert(listContract);
        verifyDatabaseResult(listDatabaseResult, true);

        //Payment Term ----------------------------------------------------------------------------
        List<Payment_Term__c> listPaymentTerm = new List<Payment_Term__c>();
        listPaymentTerm.addAll(createPaymentTerm(2));

        listDatabaseResult = Database.insert(listPaymentTerm);
        verifyDatabaseResult(listDatabaseResult, true);
        
        //Pricebook & Pricebook Entry -------------------------------------------------------------
        Id standardId = Test.getStandardPricebookId();
        List<PricebookEntry> listPricebookEntry = new List<PricebookEntry>();
        listPricebookEntry.addAll(createPricebookEntry(1, standardId, listProduct[0]));

        listDatabaseResult = Database.insert(listPricebookEntry);
        verifyDatabaseResult(listDatabaseResult, true);

        //Order - Insert --------------------------------------------------------------------------
        List<Order> listOrder = new List<Order>();
        listOrder.addAll(createOrder(2, listContract[0].Id, 
                listAccount[0].Id, 
                listPaymentTerm[0].Id, 
                listDistributionCenter[0].Id, 
                listAddress[0].Id,
                standardId
            )
        );

        listDatabaseResult = Database.insert(listOrder);
        verifyDatabaseResult(listDatabaseResult, true);

        //OrderProduct - Insert -------------------------------------------------------------------
        List<OrderItem> listOrderItem = new List<OrderItem>();
        listOrderItem.addAll(createOrderItem(1, listProduct[0].Id, listPricebookEntry[0], listOrder[0].Id));

        listDatabaseResult = Database.insert(listOrderItem);
        verifyDatabaseResult(listDatabaseResult, true);

        //Order - Update --------------------------------------------------------------------------
        Order orderChanged = listOrder[0];
        orderChanged.Shipping_Method__c = 'FOB';
        listOrder[0] = orderChanged;

        listDatabaseResult = Database.update(listOrder);
        verifyDatabaseResult(listDatabaseResult, true);

        // ----------------------------------------------------------------------------------------
        // | Tratativas dos if
        // ----------------------------------------------------------------------------------------

        accountChanged.CNPJ__c = '1';
        System.Debug(Database.update(accountChanged));
        // try{
            
        // }catch(DmlException exMsg){
        //     System.debug(exMsg);
        // }
    }
}