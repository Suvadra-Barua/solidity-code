// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.7;
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";

contract DocumentVerification is Ownable
{
    address[] verifiers;
    struct ApplicationInfo 
    { 
        uint applicationId;
        address documentOwner;
        string description;
        string ipfsUrl;
        uint totalYesVote;
        uint totalNoVote;
        bool applicationStatus;
    }
    mapping(uint=>ApplicationInfo) applicationIdToApplicationInfo;
    ApplicationInfo[] Applications;
    uint nextApplicationId;
    
    constructor()
    {
        transferOwnership(msg.sender);
    }
    //onlyowner can add verifiers
    function addVerifiers(address verifierAddress) public onlyOwner 
    {
        verifiers.push(verifierAddress);
    }
    //Anyone can apply for document verification
    function documentRegistration(string memory _description, string memory _ipfsUrl) public 
    {
        ApplicationInfo memory newApplication=ApplicationInfo(
            nextApplicationId,
            msg.sender,
            _description,
            _ipfsUrl,
            0,
            0,
            false);
        applicationIdToApplicationInfo[nextApplicationId]=newApplication;
        applications.push(newApplication);
        nextApplicationId++;
    }
    //Function to check if an address is a verifiers
    function checkIfVerifiers(address addressToCheck) public view returns(bool) {
        bool isVerifier;
            for(uint i=0;i<verifiers.length;i++)
            {
                if(verifiers[i]==addressToCheck)
                {
                    isVerifier=true;
                }
            }
            return isVerifier;
    }
    //Check all pending applications of document Verification
    function getAllPendingApplications() public view returns(ApplicationInfo[] memory)
    {
        return applications;
    }
    
    function executeApplicationSuccessful(uint applicationId) private
    {
    }
    function executeApplicationUnsuccessful(uint applicationId) private
    {
    }
    //Verifiers can vote on an application
    //voteverdict=1(Yes),2(No)
    function vote(uint applicationId, uint voteVerdict) public 
    {
        require(checkIfVerifiers(msg.sender),"Only verifiers are allowed to vote");
        require(voteVerdict==1||voteVerdict==2,"Wrong vote verdict");
        if(voteVerdict==1){
                applicationIdToApplicationInfo[applicationId].yesVote++;
                if(applicationIdToApplicationInfo[applicationId].yesVote>=verifiers.length/2)
                {
                    executeApplicationSuccessful(applicationId);
                }
        }
        else{
            applicationIdToApplicationInfo[applicationId].noVote++;
            if(applicationIdToApplicationInfo[applicationId].noVote>=verifiers.length/2)
                {
                    executeApplicationUnsuccessful(applicationId);
                }
        }
    }
 }
