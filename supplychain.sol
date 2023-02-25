// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.0;

contract supplychain{
    
    address owner;

    constructor(){
        owner=msg.sender;
    }

    uint count = 0;
    uint sold = 0;

    modifier onlyOwner {
      require(msg.sender == owner);
      _;
   }

    struct Record{
        uint256 timestamp;
        address from;
        address to;
    }

    mapping(uint256 => Record[]) Records;
    mapping(uint256 => address) owners;

        function manufacture() public onlyOwner {
            Record memory r;
            r.from = msg.sender;
            r.to = msg.sender;
            r.timestamp = block.timestamp;
            Records[count].push(r);
            owners[count] = msg.sender;
            count++;
        }
    
    function AddRecord(uint item, address _to ) public {
        require(owners[item] == msg.sender);
        require(sold == 0);
        Record memory r;
        r.from = owners[item];
        r.to = _to;
        r.timestamp = block.timestamp;
        Records[item].push(r);
        owners[item] = _to;
    }


    function getRecords(uint item) public view returns(Record[] memory){
        return Records[item];
    }

    function sell(uint item, address _customer) public {
        require(owners[item] == msg.sender);
        require(sold == 0);
        Record memory r;
        r.from = owners[item];
        r.to = _customer;
        r.timestamp = block.timestamp;
        Records[item].push(r);
        sold = 1;
    }
}