// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "./Lib.sol";

contract AttestationStructure {
  string[] private _prop_names;
  attestation_instance[] private _instances;

  mapping (address => mapping(uint => address[])) private _attestations_about;
  mapping (address => mapping(uint => address[])) private _attestations_by;
  mapping (address => uint) private _num_attestations_about;
  mapping (address => uint) private _num_attestations_by;

  constructor(string[] memory prop_names) {
    _prop_names=prop_names;
  }
  function new_instance(string[] memory vals) public {
    address[] memory foo; //jeez!
    _instances.push(attestation_instance(vals,foo,foo));
  }


  //getters
  function prop_names() public view returns (string[] memory) { return _prop_names; }
  function instances() public view returns (attestation_instance[] memory) {
    return _instances;
  }


}