pragma solidity ^0.4.0;

contract getset {
    uint value;
    
     uint public a;
    
    function getValue() public view  returns(uint){
        return value;
    }
    function setValue(uint _value){
        value=_value;
        a=_value+1;
    }
   
}
