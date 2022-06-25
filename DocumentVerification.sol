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
    
    constructor()
    {
        transferOwnership(msg.sender);
    }
    //onlyowner can add verifiers
    function addVerifiers(address verifierAddress) public onlyOwner 
    {
        verifiers.push(verifierAddress);
    }
 }
