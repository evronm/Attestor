// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Lib.sol";
import "./ERC20.sol";
import "./Factory.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract Delegator is Ownable{
  Fungible public token;
  reward_formula[] private _forumulas;
  constructor () {
    token=new Fungible("","");
  }
  function formulas() public view returns (reward_formula[] memory){ return _forumulas;}
  function add_forumula(address struct_addr, uint struct_ind, string memory prop_name, string memory prop_value, uint tokens) public onlyOwner {

  }
  function distribute() public onlyOwner {

  }
}