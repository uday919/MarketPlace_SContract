// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
contract MarketPlace{
    struct item{
        uint256 id;
        address payable seller;
        string name;
        uint256 price;
        bool isSold;
    }
    uint256 public itemCount=0;
    mapping (uint256=>item) public items;

    event itemListed(uint256 indexed itemId,address indexed seller,string name,uint256 price);
    event itemPurchased(uint256 indexed itemId,address indexed buyer,address indexed seller,uint256 price);

    function listitem(string memory _name,uint256 _price) external{
        require(bytes(_name).length>0,"Item name is required");
        require(_price>0,"Price should be greater than 0");

        itemCount++;
        items[itemCount]=item(itemCount,payable(msg.sender),_name,_price,false);

        emit itemListed(itemCount, msg.sender, _name, _price);
    }
    function buyItem(uint256 _itemId)external payable{
        item storage Item=items[_itemId];
        require(Item.id==_itemId,'item does not exist');
        require(msg.value==Item.price,"incorrect ether sent");
        require(!Item.isSold,"item already soldout");
        require(msg.sender != Item.seller,"seller cannot buy their own item");

        Item.isSold=true;
        Item.seller.transfer(msg.value);
        
        emit itemPurchased(_itemId,msg.sender,Item.seller,Item.price);
    }
}