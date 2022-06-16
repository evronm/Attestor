// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Lib.sol";
import "./ERC20.sol";
import "./Factory.sol";
contract Delegator {
  Fungible token;
  Factory attestations;
  reward_formula[] forumulas;
  constructor () {
    token=new Fungible("","");
    attestations=new Factory();
  }
}