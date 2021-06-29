pragma solidity ^0.8.5;

contract hotPotatoDice{
    mapping (address=>uint) deposits;
    mapping (address=>uint) moneyCanWithdraw;
    mapping (address=>uint) bonus;
    mapping (uint=>address) addressMap;
    address ownerAddress;
    uint ownerBalance;
    uint numberOfAddress;
    uint commisionOfOwner;
    uint profit;
    
    
    constructor () {
        ownerAddress = msg.sender;
        ownerBalance = 0;
        numberOfAddress = 0;
        commisionOfOwner = 2;
        profit = 5;
    }
    
    function deposit() public payable{
        deposits[msg.sender] += msg.value;
        addressMap[numberOfAddress++] = msg.sender;
        bonus[msg.sender] = 1;
        ownerBalance += (uint(commisionOfOwner)*msg.value/100);
    }
    
    function setCommisionOfOwner(uint commision) public isOwner{
        commisionOfOwner = commision;
    }
    
    function rewardUsers() public isOwner{
        for(uint i = 0; i < numberOfAddress; i++){
            address earner = addressMap[i];
            moneyCanWithdraw[earner]+= (deposits[earner]*uint(profit)*bonus[earner]/100);
            bonus[earner]++;
        }
    }
    
    function setReward(uint reward) public isOwner{
        profit = reward;
    }
    
    function getProfit() public view returns (uint){
        return profit;
    }
    
    function withdraw(uint quantity) public {
        assert(quantity <= moneyCanWithdraw[msg.sender] && (quantity+ownerBalance)<=(address(this).balance));
        moneyCanWithdraw[msg.sender]-=quantity;
        payable(msg.sender).transfer(quantity);
        bonus[msg.sender]=1;
    }
    
    function withdrawOwner() public{
        payable(ownerAddress).transfer(ownerBalance);
        ownerBalance = 0;
    }
    
    function getBalance(address wallet) public view returns(uint){
        return moneyCanWithdraw[wallet];
    }
    
    function getContractBalance() public view returns(uint){
        return (address(this).balance);
    }
    function getComissionOfOwner() public view returns(uint){
        return ownerBalance;
    }
    
    modifier isOwner(){
        assert(msg.sender == ownerAddress);
        _;
    }
}
