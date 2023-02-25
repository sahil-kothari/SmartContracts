// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
//import "@openzeppelin/contracts/utils/Strings.sol";

contract spare_parts{
    address owner;
    uint256 transaction_id=0;
    uint256 store_owner_id=0;
    constructor() public {
        owner=msg.sender;
    }

    struct store_owner{
        uint256 store_owner_id;
        address store_owner_wallet;
        string name;
        string _address;
        bool registered;
    }
    
    struct parts{
        uint256 part_id;
        
        string part_name;
        string cost;
        string warranty;
        string sold_to_name;
        address sold_to;
        bool sold;
        uint256 timestamp;
    }

    struct Transactions{
        address seller;
        address reciever;
        string From;
        string To;
        uint256 part_id;
        uint256 timestamp;
    }

    Transactions private singleTransaction;
    Transactions[] private  AllTransactions;

    store_owner private singleOwner;
    store_owner[] private  AllOwners;

    parts private singlePart;
    parts[] private totalParts;


    mapping(address => store_owner) Store_owners;
    mapping(uint256 => parts) items;
    mapping(uint256 => store_owner) Store_owners1;
    mapping(uint256 => Transactions) transaction;

    function Register(
        
        string memory _name,
        string memory _address
    
    ) public payable {
        singleOwner=store_owner(store_owner_id,msg.sender,_name,_address,true);
        Store_owners[msg.sender]=singleOwner;
        Store_owners1[store_owner_id]=singleOwner;
        AllOwners.push(singleOwner);
        store_owner_id++;
        //return "your ID is ";
        //return "Your ID is "+string(store_owner_id);
    }

    modifier only_store_owner{
        require(Store_owners[msg.sender].registered==true);
        _;
    }

    function sell(
        
        uint256 _part_id,
        string memory _part_name,
        string memory _cost,
        string memory _warranty,
        string memory _sold_to_name,
        address _to
        
        ) 
        public payable only_store_owner{
            singlePart=parts(_part_id,_part_name,_cost,_warranty,_sold_to_name,_to,true,block.timestamp);
            items[_part_id]=singlePart;
            totalParts.push(singlePart);

            singleTransaction=Transactions(msg.sender,_to,Store_owners[msg.sender].name,_sold_to_name,_part_id,block.timestamp);
            transaction[transaction_id]=singleTransaction;
            AllTransactions.push(singleTransaction);
            transaction_id++;
    }

    function CheckPart(uint256 _part_id) public payable returns(parts memory){
        require(items[_part_id].sold==true);
        return items[_part_id];
    }

    function View_owner(uint256 _store_owner_id) public view returns(store_owner memory) {
        require(Store_owners1[_store_owner_id].registered==true);
        return Store_owners1[_store_owner_id];
    }

    function displayAllOwners() public view returns(store_owner[] memory){
        return AllOwners;
    }

    function ViewTransaction(uint256 _transaction_id) public view returns(Transactions memory){
        return transaction[_transaction_id];
    }

    


}