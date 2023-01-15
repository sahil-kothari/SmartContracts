pragma solidity ^0.8.0;

contract Insurance {
    address payable owner;
    mapping(address => bool) policyHolders;
    mapping(address => uint) policyTimestamps;
    mapping(address => string) policyHolderDocuments;
    mapping(address => uint) policyInvestment;
    uint constant returnPercent = 20; // 20% ROI

    constructor() public {
        owner = msg.sender;
    }

    function buyPolicy() public payable {
        require(msg.value >= 1 ether, "The premium must be at least 1 ether.");
        policyHolders[msg.sender] = true;
        policyTimestamps[msg.sender] = now;
        policyInvestment[msg.sender] += msg.value;
    }

    function uploadDocument(string memory _ipfsHash) public {
        require(policyHolders[msg.sender], "You must have a policy to upload a document.");
        policyHolderDocuments[msg.sender] = _ipfsHash;
    }

    function payPremium() public payable {
        require(policyHolders[msg.sender], "You must have a policy to pay a premium.");
        require(msg.value >= 1 ether, "The premium must be at least 1 ether.");
        policyTimestamps[msg.sender] = now;
        policyInvestment[msg.sender] += msg.value;
    }

    function claim() public {
        require(policyHolders[msg.sender], "You must have a policy to claim.");
        require(now >= policyTimestamps[msg.sender] + 30 days, "You must have paid your premium within the last 30 days to claim.");
        require(policyHolderDocuments[msg.sender] != "", "You must have uploaded a document to claim.");
       
        
        IPFS.get(policyHolderDocuments[msg.sender], function (err, files) {
            if(err){
                revert("Error Occured,verifying the document");
            }else{
                uint returnAmount = (policyInvestment[msg.sender] * returnPercent) / 100;
                msg.sender.transfer(returnAmount);
            }
        });
    }

    function cancelPolicy() public {
        require(policyHolders[msg.sender], "You must have a policy to cancel.");
        policyHolders[msg.sender] = false;
        delete policyTimestamps[msg.sender];
        delete policyHolderDocuments[msg.sender];
        delete policyInvestment[msg.sender];
    }

    function getPolicyCount() public view returns(uint) {
        return address(this).balance;
    }

    function getPolicyHolders() public view returns (address[] memory) {
            address[] memory policyHoldersArr = new address[](policyHolders.length);
            uint i;
            for (i = 0; i < policyHolders.length; i++) {
                if (policyHolders[address(i)]) {
                    policyHoldersArr.push(address(i));
                }
            }
            return policyHoldersArr;
        }
}