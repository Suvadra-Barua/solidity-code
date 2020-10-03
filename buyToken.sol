pragma solidity ^0.5.1;
contract sendEther{
    
    mapping(address=>uint8) public balances;
    address payable wallet;
    event purchase(
        address indexed _buyer,
        uint8 amount);
    constructor(address payable _wallet) public{
        wallet=_wallet;
    }
    
    //it will work even if balances is not greater than value
    function() external payable{
        buyToken();
    } 
    function buyToken() payable public{
        //buy a token
        balances[msg.sender]+=1;
        //send ether to a smart contract
        wallet.transfer(msg.value);
        emit purchase(msg.sender,1);
    }
    
    
}
