// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "./Lib.sol";

contract StructuredRepository {
  string[] private _prop_names;
  attestation_instance[] private _attestation_instances;

  mapping (address => mapping(uint => address[])) private _attestations_about;
  mapping (address => mapping(uint => address[])) private _attestations_by;
  mapping (address => uint) private _num_attestations_about;
  mapping (address => uint) private _num_attestations_by;
  constructor(string[] memory prop_names) {
    _prop_names=prop_names;
  }
}