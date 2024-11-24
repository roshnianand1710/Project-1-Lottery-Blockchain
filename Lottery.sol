// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery{
 //entities - manager,players and winner
 address public manager; //stores the address of the manager , public accessibilty.
 address payable[] public players; //an array of players "payable" because they can send(participation fees) and recieve money(if they win).
 address payable public winner; //winner's address is also payable.

  constructor(){
      manager=msg.sender; //when the smart contract gets deployed, the manager's address will be stored.
  }

  function participate() public payable{
      require(msg.value==1 ether,"Please pay 1 ether only"); //" " if require condition is false
      players.push(payable(msg.sender));//if require condition is true
  }

  function getBalance() public view returns(uint){
      require(manager==msg.sender,"You are not the manager"); //" " if require condition is false
      return address(this).balance; //if require condition is true
  }

  function random() internal view returns(uint){
      return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players.length))); //to get the random value
  }

  function pickWinner() public{
      require(manager==msg.sender,"You are not the manager");
      require(players.length>=3,"Players are less than 3");

      uint r=random();
      uint index = r%players.length; //randomvalue%n = [0,1,2,..,n-1]
      winner=players[index];
      winner.transfer(getBalance()); //transfers money to the winner
      players= new address payable[](0); //this will intiliaze the players array back to 0
  }

}
