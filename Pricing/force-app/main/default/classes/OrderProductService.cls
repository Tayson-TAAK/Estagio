public with sharing class OrderProductService {
    private TriggerUtil triggerUtil;
    private List<OrderItem> newList;
    private List<OrderItem> oldList;
    private Map<Id, OrderItem> newMap;
    private Map<Id, OrderItem> oldMap;
    
    public OrderProductService(OrderProductHandler triggerHandler) {
        this.triggerUtil = new TriggerUtil(triggerHandler);
        this.newList = (List<OrderItem>) triggerHandler.newList;
        this.oldList = (List<OrderItem>) triggerHandler.oldList;
        this.newMap = new Map<Id, OrderItem>();
        if (triggerHandler.newMap != null) {
            for (Id recordId : triggerHandler.newMap.keySet()) {
                this.newMap.put(recordId, (OrderItem) triggerHandler.newMap.get(recordId));
            }
        }
        
        this.oldMap = new Map<Id, OrderItem>();
        if (triggerHandler.oldMap != null) {
            for (Id recordId : triggerHandler.oldMap.keySet()) {
                this.oldMap.put(recordId, (OrderItem) triggerHandler.oldMap.get(recordId));
            }
        }
    }
    
    public void beforeInsert(){
        
        //Product / Product Hierarchy
        List<Id> listIdProduct = new List<Id>();
        List<Id> listIdProductHierarchy = new List<Id>();
        List<Id> listAccountId = new List<Id>();
        
        for(OrderItem OrderP : this.newList){
            if(OrderP.Product2Id != null){
                listIdProduct.add(OrderP.Product2Id);
                listIdProductHierarchy.add(OrderP.Product2.Product_Hierarchy__c);
            }
            listAccountId.add(OrderP.Order.AccountId);
        }
        
        //Account / Account Group
        List<Account> listAccount = [SELECT Id, Account_Group__c 
                                     FROM Account 
                                     WHERE Id IN :listAccountId];
        List<Id> listAccountGroup = new List<Id>();
        for(Account acc : listAccount){
            listAccountGroup.add(acc.Account_Group__c);
        }
        
        //City / State / Country
        List<Account_Address__c> listAccountAddress = [SELECT Id, Account__c, City__c 
                                                       FROM Account_Address__c 
                                                       WHERE Account__c IN :listAccountId];
        list<Id> listCity = new List<Id>();
        list<Id> listState = new List<Id>();
        list<Id> listCountry = new List<Id>();
        for(Account_Address__c accAddress : listAccountAddress){
            listCity.add(accAddress.City__c);
            listState.add(accAddress.City__r.State__c);
            listCountry.add(accAddress.City__r.State__r.Country__c);
        }
        
        //-- Imposto - Prioridade --------------------------------------------------
        List<Tax__c> listTax = new List<Tax__c>();
        
        //Produto
        listTax = [SELECT Id, Product__c, Tax_on_Cost__c 
                                From Tax__c 
                                WHERE Product__c IN :listIdProduct LIMIT 1];
        
        //-- Frete - Prioridade --------------------------------------------------
        List<Freight__c> listFreight = new List<Freight__c>();
        
        //Produto
        listFreight = [SELECT Id, Value__c, Product__c, Product_Hierarchy__c, City__c, State__c, Country__c
                                     FROM Freight__c 
                                     WHERE Product__c IN :listIdProduct OR 
                                           Product_Hierarchy__c IN :listIdProductHierarchy];
        //Localidade
        if(listFreight.size() == 0){
            listFreight = [SELECT Id, Value__c, City__c, State__c, Country__c
                           FROM Freight__c WHERE City__c IN :listCity OR
                                                 State__c IN :listState OR
                                                 Country__c IN :listCountry];
        }
        
        //-- Margem - Prioridade --------------------------------------------------
        List<Margin__c> listMargin = new List<Margin__c>();
        
        //Produto
        listMargin = [SELECT Id, Value__c, Product__c, Product_Hierarchy__c, City__c, State__c, Country__c
                      FROM Margin__c
                      WHERE Product__c IN :listIdProduct OR 
                            Product_Hierarchy__c IN :listIdProductHierarchy];
        //Conta
        if(listMargin.size() == 0){
            listMargin = [SELECT Id, Value__c, Account__c, Account_Group__c
                          FROM Margin__c
                          WHERE Product__c IN :listIdProduct OR 
                                Product_Hierarchy__c IN :listIdProductHierarchy];
            //Localidade
        }if(listMargin.size() == 0){
            listMargin = [SELECT Id, Value__c, City__c, State__c, Country__c
                           FROM Margin__c WHERE City__c IN :listCity OR
                                                State__c IN :listState OR
                                                Country__c IN :listCountry];
        }
        
        if(listTax.size() == 0 || listFreight.size() == 0 || listMargin.size() == 0){
            throw new IllegalArgumentException('Não está autorizada a venda deste produto devido à falta de parâmetros. Contate o time de Pricing.');
        }
        
        //--(Codigo de inserção dos valores de margem, frete e imposto)------------
        List<OrderItem> listOrderItem = this.newList;
        Integer lastIndex = listOrderItem.size();
        Boolean flag = true;
        for(Integer i = 0; i < lastIndex; i++){
            if(listOrderItem[i].Quantity == 0 || listOrderItem[i].Final_Price__c == 0){
                listOrderItem[i].addError('Quantidade e/ou Preço Final não podem ser nulos');
            }
            
            //Adicionando TaxPercentage
            for(Tax__c tax : listTax){
                if(tax.Product__c == 
                listOrderItem[i].Product2Id){
                    listOrderItem[i].TaxPercentage__c = tax.Tax_on_Cost__c;
                }
            }
            
            //Adicionando FreightValue
            for(Freight__c freight : listFreight){
                //Produto
                if( flag &&
                    freight.Product__c == listOrderItem[i].Product2Id ||
                    freight.Product_Hierarchy__c == listOrderItem[i].Product2.Product_Hierarchy__c
                ){
                    listOrderItem[i].FreightValue__c = freight.Value__c;
                    listFreight.remove(listFreight.indexOf(freight));
                    flag = false;
                }
                
                //Localização
                if( flag &&
                    freight.City__c == listAccountAddress[i].City__c ||
                    freight.State__c == listAccountAddress[i].City__r.State__c ||
                    freight.Country__c == listAccountAddress[i].City__r.State__r.Country__c
                ){
                    listOrderItem[i].FreightValue__c = freight.Value__c;
                    listFreight.remove(listFreight.indexOf(freight));
                    flag = false;
                }
                
                flag = true;
            }
            
            //Adicionando MarginPercentage 
            for(Margin__c margin : listMargin){
                //Produto
                if( flag &&
                    margin.Product__c == listOrderItem[i].Product2Id ||
                    margin.Product_Hierarchy__c == listOrderItem[i].Product2.Product_Hierarchy__c
                ){
                    listOrderItem[i].MarginPercentage__c = margin.Value__c;
                    listMargin.remove(listMargin.indexOf(margin));
                    flag = false;
                }

                //Conta
                if( flag &&
                    margin.Account__c == listAccountId[i] ||
                    margin.Account_Group__c == listAccountGroup[i]
                ){
                    listOrderItem[i].MarginPercentage__c = margin.Value__c;
                    listMargin.remove(listMargin.indexOf(margin));
                    flag = false;
                }

                //Localização
                if( flag &&
                    margin.City__c == listAccountAddress[i].City__c ||
                    margin.State__c == listAccountAddress[i].City__r.State__c ||
                    margin.Country__c == listAccountAddress[i].City__r.State__r.Country__c
                ){
                    listOrderItem[i].MarginPercentage__c = margin.Value__c;
                    listMargin.remove(listMargin.indexOf(margin));
                    flag = false;
                }
                
                flag = true;
            }
        }
        
    }
    
    public void beforeUpdate(){
        
    }
}