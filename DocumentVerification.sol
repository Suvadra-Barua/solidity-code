// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.7;
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";
// A platform to make different platform to verify document
//question will arise 

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
        //applicationStatus=0(onGoingVote),1(voting finished/successful),2(voting finished and unsuccessful)
        uint8 applicationStatus;
    }
    mapping(uint=>ApplicationInfo) applicationIdToApplicationInfo;
    ApplicationInfo[] applications;
    uint nextApplicationId;
    uint[] allApprovedApplicationId;
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
            0);
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
        allApprovedApplicationId.push(applicationId);
        applicationIdToApplicationInfo[applicationId].applicationStatus=1;
        uint deleteIndex;
        for(uint i=0;i<applications.length;i++)
        {
            if(applications[i].applicationId==applicationId)
            {
                deleteIndex=i;
                break;
            }
        }
        for(uint i=deleteIndex;i<applications.length-1;i++)
        {
            applications[i]=applications[i+1];
        }
        applications.pop();
    }
    function executeApplicationUnsuccessful(uint applicationId) private
    {
        applicationIdToApplicationInfo[applicationId].applicationStatus=2;
        uint deleteIndex;
        for(uint i=0;i<applications.length;i++)
        {
            if(applications[i].applicationId==applicationId)
            {
                deleteIndex=i;
                break;
            }
        }
        for(uint i=deleteIndex;i<applications.length-1;i++)
        {
            applications[i]=applications[i+1];
        }
        applications.pop();
    }
    //Verifiers can vote on an application
    //voteverdict=1(Yes),2(No)
    function vote(uint applicationId, uint voteVerdict) public 
    {
        require(applicationIdToApplicationInfo[applicationId].applicationStatus==0,"Voting closed");
        require(checkIfVerifiers(msg.sender),"Only verifiers are allowed to vote");
        require(voteVerdict==1||voteVerdict==2,"Wrong vote verdict");
        if(voteVerdict==1){
                applicationIdToApplicationInfo[applicationId].totalYesVote++;
                if(applicationIdToApplicationInfo[applicationId].totalYesVote>=verifiers.length/2)
                {
                    executeApplicationSuccessful(applicationId);
                }
        }
        else{
            applicationIdToApplicationInfo[applicationId].totalNoVote++;
            if(applicationIdToApplicationInfo[applicationId].totalNoVote>=verifiers.length/2)
                {
                    executeApplicationUnsuccessful(applicationId);
                }
        }
    }

    
}
