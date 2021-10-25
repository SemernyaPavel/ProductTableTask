public with sharing class OneProductController {
    public Product_Table__c product{get; set;}
    public Contact con{get; set;}
    public Integer 	unitCount{get; set;}
    public Decimal totalAmount{get; set;}
    public Id productId{get; set;}

    public OneProductController() {
        con = new Contact();
        con.LastName = 'required';
        setProduct();
        unitCount = 1;
        totalAmount = 0;
        setTotalAmount();
    }

    public void setProduct(){
        productId = ApexPages.currentPage().getParameters().get('id');
        product = [SELECT Id, Name, Product_Description__c, Image_URL__c, Unit_Price__c, Units_Available__c FROM Product_Table__c WHERE id =: productId];
    }

    public void setTotalAmount(){
        totalAmount = unitCount * product.Unit_Price__c;
    }

    public void placeOrder(){
        if(product.Units_Available__c - unitCount >= 0){
            product.Units_Available__c = product.Units_Available__c - unitCount;
            update product;
            List<Contact> c = [SELECT id, FirstName, LastName, Email FROM Contact WHERE Email =: con.Email];
            Contact newCon = new Contact();
            if(!c.isEmpty()){
                newCon.Id = c.get(0).Id;
                newCon.FirstName = con.FirstName;
                newCon.lastName = con.LastName;
                newCon.Email = con.Email;
                update newCon;
            } else {
                newCon.FirstName = con.FirstName;
                newCon.LastName = con.LastName;
                newCon.Email = con.Email;
                insert newCon;
            }
            Order_Table__c order = new Order_Table__c(
                Product_Table__c = product.Id,
                Units__c = unitCount,
                Order_Amount__c = totalAmount,
                Contact__c = newCon.Id
            );
            insert order;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Success'));
        } else {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'No Enough Products'));
        }
    }
}