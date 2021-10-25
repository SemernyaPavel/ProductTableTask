public with sharing class AllProductTableController {
    public List<Product_Table__c> products{get; set;}
    public AllProductTableController() {
        setProducts();
    }

    public void setProducts(){
        products = [SELECT Id, Name, Product_Description__c, Image_URL__c, Unit_Price__c FROM Product_Table__c WHERE Units_Available__c > 0];
        for(Product_Table__c p : products){
            if(p.Product_Description__c.length() > 100){
                String descr = p.Product_Description__c.left(97) + '...';
                p.Product_Description__c = descr;
            }
        }
    }

}