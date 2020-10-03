pragma solidity ^0.5.1;

contract mineAddname{
    uint public peopleCount;
    mapping (uint=>people) public addPeople;
    struct people{
        uint id;
        string first_name;
        string last_name;
    }
    address owner;
    
    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }
    constructor() public{
        owner=msg.sender;
    }
    
    function addBiodata(string memory _firstname,string memory _lastname) public onlyOwner{
       increase();
       addPeople[peopleCount]=people(peopleCount,_firstname,_lastname);
        
    }
    
    function increase() internal{
         peopleCount+=1;
    }
} 
