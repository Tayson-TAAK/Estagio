public with sharing class OrderProductService {
    private TriggerUtil triggerUtil;
    private List<OrderItem> newList;
    private List<OrderItem> oldList;
    
    public OrderProductService(OrderProductHandler triggerHandler) {
        this.triggerUtil = new TriggerUtil(triggerHandler);
        this.newList = (List<OrderItem>) triggerHandler.newList;
        this.oldList = (List<OrderItem>) triggerHandler.oldList;
    }
    
    public void beforeInsert() {
        List<OrderItem> itemsToProcess = this.newList;
        Set<Id> productIds = new Set<Id>();
        Set<Id> orderIds = new Set<Id>();
        
        //Pegando Ids de produto e pedido relacionados a ordemItem ------------------------------------------
        for (OrderItem item : itemsToProcess) {
            if (item.Product2Id != null) { 
                productIds.add(item.Product2Id);
            }
            if (item.OrderId != null) {
                orderIds.add(item.OrderId);
            }
        }
        
        //Account / Account Group ---------------------------------------------------------------------------
        Map<Id, Order> orderMap = new Map<Id, Order>([  SELECT Id, AccountId, Account.Account_Group__c, Status 
                                                        FROM Order 
                                                        WHERE Id IN :orderIds ]);
        
        //Product / Product Hierarchy -----------------------------------------------------------------------
        Map<Id, Product2> productMap = new Map<Id, Product2>([ SELECT Id, Product_Hierarchy__c, Production_Cost__c 
                                                               FROM Product2 
                                                               WHERE Id IN :productIds ]);
        
        Set<Id> productHierarchyIds = new Set<Id>();
        for (Product2 p : productMap.values()) {
            if (p.Product_Hierarchy__c != null) {
                productHierarchyIds.add(p.Product_Hierarchy__c);
            }
        }
        
        //City / State / Country ----------------------------------------------------------------------------
        Set<Id> accountIds = new Set<Id>();
        Set<Id> accountGroupIds = new Set<Id>();
        for (Order order : orderMap.values()) {
            if (order.AccountId != null) {
                accountIds.add(order.AccountId);
                if (order.Account.Account_Group__c != null) {
                    accountGroupIds.add(order.Account.Account_Group__c);
                }
            }
        }
        
        Map<Id, Account_Address__c> accAddressMap = new Map<Id, Account_Address__c>();
        Set<Id> cityIds = new Set<Id>();
        Set<Id> stateIds = new Set<Id>();
        Set<Id> countryIds = new Set<Id>();
        
        List<Account_Address__c> accAddressList = [SELECT Id, Account__c, City__c, City__r.State__c, City__r.State__r.Country__c 
                                                  FROM Account_Address__c 
                                                  WHERE Account__c IN :accountIds ];
        for (Account_Address__c accAddress : accAddressList) {
            accAddressMap.put(accAddress.Account__c, accAddress);
            if (accAddress.City__c != null) {
                cityIds.add(accAddress.City__c);
            }
            if (accAddress.City__r != null && accAddress.City__r.State__c != null) {
                stateIds.add(accAddress.City__r.State__c);
            }
            if (accAddress.City__r != null && accAddress.City__r.State__r != null && accAddress.City__r.State__r.Country__c != null) {
                countryIds.add(accAddress.City__r.State__r.Country__c);
            }
        }

        //Buscando as melhores condições --------------------------------------------------------------------
        //Taxa
        Map<Id, Tax__c> taxByProductId = new Map<Id, Tax__c>();
        List<Tax__c> taxApproved = [SELECT Id, Product__c, Tax_on_Cost__c 
                                   FROM Tax__c 
                                   WHERE Product__c IN :productIds AND Status__c = 'Approved' 
                                   ORDER BY Tax_on_Cost__c];
        for (Tax__c t : taxApproved) {
            taxByProductId.put(t.Product__c, t);
        }
        
        //Frete
        List<Freight__c> listFreight = [ SELECT Id, Value__c, Product__c, Product_Hierarchy__c, City__c, State__c, Country__c, CreatedDate
                                         FROM Freight__c 
                                         WHERE Status__c = 'Approved'
                                         AND (Product__c IN :productIds OR Product_Hierarchy__c IN :productHierarchyIds) 
                                         AND (City__c IN :cityIds OR State__c IN :stateIds OR Country__c IN :countryIds) ];
        
        //Margem
        List<Margin__c> listMargin = [  SELECT Id, Value__c, Product__c, Product_Hierarchy__c, Account__c, Account_Group__c, City__c, State__c, Country__c, CreatedDate
                                        FROM Margin__c 
                                        WHERE Status__c = 'Approved'
                                        AND (Product__c IN :productIds OR Product_Hierarchy__c IN :productHierarchyIds)
                                        AND (Account__c IN :accountIds OR Account_Group__c IN :accountGroupIds)
                                        AND (City__c IN :cityIds OR State__c IN :stateIds OR Country__c IN :countryIds) ];

        //Adicionando os valores nos campos correspondentes -------------------------------------------------
        for (OrderItem orderP : itemsToProcess) {
            Product2 product = productMap.get(orderP.Product2Id);
            Order order = orderMap.get(orderP.OrderId);

            //Verificando se status de order esta ativo
            if(order != null && order.Status == 'Activated'){
                orderP.addError('[!] It is not permitted to modify the order, as it is currently active [!]');
            }
            
            Account_Address__c address = null;
            if(order != null){
                address = accAddressMap.get(order.AccountId);
            }
            
            //Taxa
            if (taxByProductId.containsKey(orderP.Product2Id)) {
                orderP.TaxPercentage__c = taxByProductId.get(orderP.Product2Id).Tax_on_Cost__c;
            } else {
                orderP.addError('[!] The sale of this product is not authorized due to a lack of parameters (Tax). Please contact the Pricing team [!]');
                continue;
            }
            
            //Frete -----------------------------------------------------------------------------------------
            //Product (100)
            //Product_Hierarchy (50)
            //City (10)
            //State (5) 
            //Country (1)
            Decimal freightVal = null;
            Integer bestFreightScore = -1;

            if (address != null && address.City__r != null) {
                Id cityId = address.City__c;
                Id stateId = address.City__r.State__c;
                Id countryId = (address.City__r.State__r != null) ? address.City__r.State__r.Country__c : null;

                for (Freight__c f : listFreight) {
                    Boolean matchesProduct = (f.Product__c != null && f.Product__c == orderP.Product2Id);
                    Boolean matchesHierarchy = (product != null && f.Product_Hierarchy__c != null && f.Product_Hierarchy__c == product.Product_Hierarchy__c);
                    
                    Boolean matchesLocation = (f.City__c != null && f.City__c == cityId) ||
                                              (f.State__c != null && f.State__c == stateId) ||
                                              (f.Country__c != null && f.Country__c == countryId);

                    if ((matchesProduct || matchesHierarchy) && matchesLocation) {
                        Integer currentScore = 0;
                        if (matchesProduct) currentScore += 100;
                        else if (matchesHierarchy) currentScore += 50;

                        if (f.City__c == cityId) currentScore += 10;
                        else if (f.State__c == stateId) currentScore += 5;
                        else if (f.Country__c == countryId) currentScore += 1;

                        if (currentScore > bestFreightScore) {
                            bestFreightScore = currentScore;
                            freightVal = f.Value__c;
                        }
                    }
                }
            }

            if (freightVal != null) {
                orderP.FreightValue__c = freightVal;
            } else {
                orderP.addError('[!] The sale of this product is not authorized due to a lack of parameters (Freight). Please contact the Pricing team [!]');
                continue;
            }

            //Margem ----------------------------------------------------------------------------------------
            //Product (100)
            //Product_Hierarchy (50)
            //Account (20)
            //Account_Group (10)
            //City (3)
            //State (2) 
            //Country (1)

            Decimal marginPercent = null;
            Integer bestMarginScore = -1;

            if (order != null && address != null && address.City__r != null) {
                Id cityId = address.City__c;
                Id stateId = address.City__r.State__c;
                Id countryId = (address.City__r.State__r != null) ? address.City__r.State__r.Country__c : null;

                for (Margin__c m : listMargin) {
                    Boolean matchesProduct = (m.Product__c != null && m.Product__c == orderP.Product2Id);
                    Boolean matchesHierarchy = (product != null && m.Product_Hierarchy__c != null && m.Product_Hierarchy__c == product.Product_Hierarchy__c);
                    
                    Boolean matchesAccount = (m.Account__c != null && m.Account__c == order.AccountId);
                    Boolean matchesGroup = (order.Account.Account_Group__c != null && m.Account_Group__c != null && m.Account_Group__c == order.Account.Account_Group__c);

                    Boolean matchesLocation = (m.City__c != null && m.City__c == cityId) ||
                                              (m.State__c != null && m.State__c == stateId) ||
                                              (m.Country__c != null && m.Country__c == countryId);

                    if ((matchesProduct || matchesHierarchy) && (matchesAccount || matchesGroup) && matchesLocation) {
                        Integer currentScore = 0;
                        if (matchesProduct) currentScore += 100;
                        else if (matchesHierarchy) currentScore += 50;

                        if (matchesAccount) currentScore += 20;
                        else if (matchesGroup) currentScore += 10;

                        if (m.City__c == cityId) currentScore += 3;
                        else if (m.State__c == stateId) currentScore += 2;
                        else if (m.Country__c == countryId) currentScore += 1;

                        if (currentScore > bestMarginScore) {
                            bestMarginScore = currentScore;
                            marginPercent = m.Value__c;
                        }
                    }
                }
            }

            if (marginPercent != null) {
                orderP.MarginPercentage__c = marginPercent;
            } else {
                orderP.addError('[!] The sale of this product is not authorized due to a lack of parameters (Margin). Please contact the Pricing team [!]');
                continue;
            }
        }
    }
    
    public void beforeUpdate() {
        beforeInsert();
    }
}