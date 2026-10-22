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
        
        //Pegando Ids de produto e pedido relacionados a ordemItem -----------------------------------------
        for (OrderItem item : itemsToProcess) {
            if (item.Product2Id != null) { 
                productIds.add(item.Product2Id);
            }
            if (item.OrderId != null) {
                orderIds.add(item.OrderId);
            }
        }
        
        //Account / Account Group --------------------------------------------------------------------------
        Map<Id, Order> orderMap = new Map<Id, Order>([  SELECT Id, AccountId, Account.Account_Group__c, Status 
                                                        FROM Order 
                                                        WHERE Id IN :orderIds ]);
        
        //Product / Product Hierarchy ----------------------------------------------------------------------
        Map<Id, Product2> productMap = new Map<Id, Product2>([ SELECT Id, Product_Hierarchy__c, Production_Cost__c 
                                                            FROM Product2 
                                                            WHERE Id IN :productIds ]);
        
        Set<Id> productHierarchyIds = new Set<Id>();
        for (Product2 p : productMap.values()) {
            if (p.Product_Hierarchy__c != null) {
                productHierarchyIds.add(p.Product_Hierarchy__c);
            }
        }
        
        //City / State / Country ---------------------------------------------------------------------------
        Set<Id> accountIds = new Set<Id>();
        Set<Id> accountGroupIds = new Set<Id>();
        for (Order ord : orderMap.values()) {
            if (ord.AccountId != null) {
                accountIds.add(ord.AccountId);
                if (ord.Account.Account_Group__c != null) {
                    accountGroupIds.add(ord.Account.Account_Group__c);
                }
            }
        }
        
        Map<Id, Account_Address__c> accAddressMap = new Map<Id, Account_Address__c>();
        Set<Id> cityIds = new Set<Id>();
        Set<Id> stateIds = new Set<Id>();
        Set<Id> countryIds = new Set<Id>();
        
        List<Account_Address__c> accAddressList = new List<Account_Address__c>();
        accAddressList = [SELECT Id, Account__c, City__c, City__r.State__c, City__r.State__r.Country__c 
                          FROM Account_Address__c 
                          WHERE Account__c IN :accountIds ];
        for (Account_Address__c accAddress : accAddressList) {
            accAddressMap.put(accAddress.Account__c, accAddress);
            if (accAddress.City__c != null) {
                cityIds.add(accAddress.City__c);
            }
            if (accAddress.City__r.State__c != null) {
                stateIds.add(accAddress.City__r.State__c);
            }
            if (accAddress.City__r.State__r.Country__c != null) {
                countryIds.add(accAddress.City__r.State__r.Country__c);
            }
        }

        //Buscando as melhores condições -------------------------------------------------------------------
        //Taxa
        Map<Id, Tax__c> taxByProductId = new Map<Id, Tax__c>();
        List<Tax__c> taxApproved = new List<Tax__c>();
        taxApproved = [SELECT Id, Product__c, Tax_on_Cost__c 
                       FROM Tax__c 
                       WHERE Product__c IN :productIds AND Status__c = 'Aprovado' ];
        for (Tax__c t : taxApproved) {
            taxByProductId.put(t.Product__c, t);
        }
        
        //Frete
        List<Freight__c> listFreight = new List<Freight__c>();
        listFreight = [ SELECT Id, Value__c, Product__c, Product_Hierarchy__c, City__c, State__c, Country__c, CreatedDate
                        FROM Freight__c 
                        WHERE Status__c = 'Aprovado'
                        AND (Product__c IN :productIds OR Product_Hierarchy__c IN :productHierarchyIds OR City__c IN :cityIds OR State__c IN :stateIds OR Country__c IN :countryIds) ];
        
        //Margem
        List<Margin__c> listMargin = new List<Margin__c>();
        listMargin = [  SELECT Id, Value__c, Product__c, Product_Hierarchy__c, Account__c, Account_Group__c, City__c, State__c, Country__c, CreatedDate
                        FROM Margin__c 
                        WHERE Status__c = 'Aprovado'
                        AND (Product__c IN :productIds OR Product_Hierarchy__c IN :productHierarchyIds OR Account__c IN :accountIds OR Account_Group__c IN :accountGroupIds OR City__c IN :cityIds OR State__c IN :stateIds OR Country__c IN :countryIds) ];

        //Adicionando os valores nos campos correspondentes ------------------------------------------------
        for (OrderItem orderP : itemsToProcess) {
            Product2 product = productMap.get(orderP.Product2Id);
            Order order = orderMap.get(orderP.OrderId);
            
            Account_Address__c address = null;
            if(order != null){
                address = accAddressMap.get(order.AccountId);
            }
            
            //Taxa
            Decimal taxPercent = 0;
            if (taxByProductId.containsKey(orderP.Product2Id)) {
                orderP.TaxPercentage__c = taxByProductId.get(orderP.Product2Id).Tax_on_Cost__c;
            } else {
                orderP.addError('Não está autorizada a venda deste produto devido à falta de parâmetros. Contate o time de Pricing.');
                continue;
            }
            
            //Frete
            Decimal freightVal = null;
            for (Freight__c f : listFreight) {
                if (
                    (f.Product__c == orderP.Product2Id) || (product != null && f.Product_Hierarchy__c == product.Product_Hierarchy__c) || 
                    (address != null) && (f.City__c == address.City__c || f.State__c == address.City__r.State__c || f.Country__c == address.City__r.State__r.Country__c)
                ){
                    freightVal = f.Value__c;
                    break;
                }
            }
            if (freightVal != null) {
                orderP.FreightValue__c = freightVal;
            } else {
                orderP.addError('Não está autorizada a venda deste produto devido à falta de parâmetros. Contate o time de Pricing.');
                continue;
            }

            //Margem
            Decimal marginPercent = null;
            for (Margin__c m : listMargin) {
                if (
                    (m.Product__c == orderP.Product2Id) || (product != null && m.Product_Hierarchy__c == product.Product_Hierarchy__c) || 
                    (order != null) && (m.Account__c == order.AccountId || m.Account_Group__c == order.Account.Account_Group__c) || 
                    (address != null) && (m.City__c == address.City__c || m.State__c == address.City__r.State__c || m.Country__c == address.City__r.State__r.Country__c)
                ){
                    marginPercent = m.Value__c;
                    break;
                }
            }
            if (marginPercent != null) {
                orderP.MarginPercentage__c = marginPercent;
            } else {
                orderP.addError('Não está autorizada a venda deste produto devido à falta de parâmetros. Contate o time de Pricing.');
                continue;
            }
        }
    }
    
    public void beforeUpdate() {
        beforeInsert();
    }
}