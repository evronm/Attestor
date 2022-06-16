// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./Lib.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract AttestationStructure is Initializable {
  using Utils for *;
  string[] private _prop_names;
  string private _handle;
  attestation_instance[] private _instances;

  mapping (address => mapping(uint => address[])) private _attestations_about;
  mapping (address => mapping(uint => address[])) private _attestations_by;
  mapping (address => uint) public _num_attestations_about;
  mapping (address => uint) public _num_attestations_by;

  function init(string memory handle,string[] memory prop_names) public initializer returns (AttestationStructure){
    _handle=handle;
    _prop_names=prop_names;
    return this;
  }
  function new_instance(string[] memory vals) public {
    address[] memory foo; //jeez!
    _instances.push(attestation_instance(vals,foo,foo));
  }
  function attest(int idx, address attestee) public {
      require(idx>-1, "No Attestation with that index exists"); //This is not necessary right now but probably will be at some point.
      _attestations_about[attestee][uint(idx)].push(msg.sender);
      _num_attestations_about[attestee]+=1;
      _attestations_by[msg.sender][uint(idx)].push(attestee);
      _num_attestations_by[msg.sender]+=1;
      if (_instances[uint(idx)].attestors.find_in_addr_array(msg.sender) == -1) {
          _instances[uint(idx)].attestors.push(msg.sender);
      }
      if (_instances[uint(idx)].attestees.find_in_addr_array(attestee) == -1) {
          _instances[uint(idx)].attestees.push(attestee);
      }
  }


  //getters
  function prop_names() public view returns (string[] memory) { return _prop_names; }
  function instances() public view returns (attestation_instance[] memory) { return _instances; }

  function attestors_of(address attestee, uint attestation_ind) public view returns (address[] memory) { return _attestations_about[attestee][attestation_ind]; }
  function attestations_about(address attestee) public view returns (uint[] memory) {
      uint[] memory attestation_inds =new uint[](_num_attestations_about[attestee]);
      uint j=0; //No words for how ugly this is...
      for (uint i=0;i<_instances.length; i++) {
          if (_attestations_about[attestee][i].length > 0) {
              attestation_inds[j]=i;
              j++;
          }
      }
      return attestation_inds;
  }
  function attestations_by(address attestor) public view returns (uint[] memory) {
      uint[] memory attestation_inds =new uint[](_num_attestations_by[attestor]);
      uint j=0; //No words for how ugly this is...
      for (uint i=0;i<_instances.length; i++) {
          if (_attestations_by[attestor][i].length > 0) {
              attestation_inds[j]=i;
              j++;
          }
      }
      return attestation_inds;
  }

}