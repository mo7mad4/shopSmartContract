// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0;

contract Shop{
    
    string public Shopname ;
    uint public count = 0; //لو حابين نعرف وين واصل الكاونت 

    constructor() public {
        Shopname = "Mr Mohammed Shop"; // اول ما يشتغل كونتراكت حياخذ اسم ويحطو في سطر 7 
    }

    struct Product { // هيكل لتخزين البيانات الخاصة في البرودكت
        uint id;
        string name;
        string description;
        bool sold;
        address payable owner;
        uint price;
    }


      event CreateProduct (
        uint id,
        string name,
        string description,
        bool sold,
        address payable owner,
        uint price
      );

      event PurchsedProduct (
        uint id,
        string name,
        string description,
        bool sold,
        address payable owner,
        uint price
      );

    mapping (uint =>Product) public shopProducts;  //products [1:{name : "product one, price: 20}]


    function createShopProduct(string memory name, uint price, string memory description) public {
        require(price > 0, "The price Shoud be More Than or equal 1");
        require(bytes(name).length > 0, "Your name is empty");
        require(bytes(description).length > 0, "Your Description is empty");
        count++; //زودنا الكوانت ب 1 
        shopProducts[count] = Product(count,name,description,false,payable (msg.sender),price); // address عشان يهندل  msg.sender  واضيفها ،، عملو لالنا , struct حجيب البيانات الي موجودة في   new id عشان انا اقدر اضيف 
        
        emit CreateProduct(count,name,description,false,payable (msg.sender),price);
    }
     
    function purchasedShopProduct(uint _id) public payable {
        Product memory singleProduct = shopProducts[_id];
        address payable seller = singleProduct.owner;
        singleProduct.owner = payable (msg.sender);
        require(seller != msg.sender,"can`t Buy your Product");
        require(msg.value >= singleProduct.price,"The value not equal price of the product");
        require(singleProduct.id > 0 && singleProduct.id <= count, "The id should be more than zero");
        require(!singleProduct.sold,"This Item Solded");
        singleProduct.sold = true;
        shopProducts[_id] = singleProduct;
        payable (seller).transfer(msg.value);
        emit PurchsedProduct(_id,singleProduct.name,singleProduct.description,true,payable (msg.sender),singleProduct.price);
    }

}

