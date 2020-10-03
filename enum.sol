pragma solidity ^0.5.1;

contract mineEnum{
    
    enum carState { ready,steady,go,run,finish }
    carState public state;
    
    constructor() public{
        state=carState.ready;
        
    }
    
    function active() public{
        state=carState.go;
        if(state==carState.go){
            state=carState.run;
        }
    }
    
    function running() view public returns(bool){
            return state==carState.run;
    
    }
}
