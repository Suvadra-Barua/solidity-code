pragma solidity ^0.5.9;

contract proposalVote{
    struct voter{
        uint8 weight;
        bool voted;
        uint vote;
        bool registered;
    }
    
    struct proposal{
        uint voteCount;
    }
    address chairperson;
    proposal[] proposals;
    mapping(address=>voter) voters;
    
    constructor(uint8 _numPrposal) public{
        chairperson=msg.sender;
        voters[chairperson].weight=1;
        proposals.length=_numPrposal;
    }
    
    function register(address toVoter) public{
        if(msg.sender!=chairperson ||voters[toVoter].registered || voters[toVoter].voted) return;
       voters[toVoter].registered=true;
        voters[toVoter].voted=false;
        voters[toVoter].weight=1;
        
    }
    
    function vote(uint8 _proposalNo) public{
        voter storage sender=voters[msg.sender];
        if(sender.voted||_proposalNo>=proposals.length) return;
        if(sender.registered){
        proposals[_proposalNo].voteCount+=sender.weight;
        sender.voted=true;
        sender.vote=_proposalNo;
        }
        
    }
    
    function _winningProposal() view public returns(uint8 winner){
        uint winningVoteCount=0;
        for(uint8 i=0;i<proposals.length;i++){
            if(proposals[i].voteCount>winningVoteCount){
                winningVoteCount=proposals[i].voteCount;
                winner=i;
            }
        }
    }
}
