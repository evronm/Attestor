// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./Lib.sol";
import './AttestationStructure.sol';
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";


contract Factory is Initializable {
  string[] public _handles;
  mapping (string => address) public attestation_structures;
  address private base_attestation=address(new AttestationStructure());

  function create_attestation_structure(string calldata handle,string[] calldata props) public returns (AttestationStructure) {
    require (! (attestation_structures[handle] > address(0)), "An Attestaion structure with this handle already exists");
    AttestationStructure al=AttestationStructure(Clones.clone(base_attestation)).init(handle,props);
    attestation_structures[handle]=address(al);
    _handles.push(handle);
    return al;
  }

  function handles() public view returns (string[] memory) {return _handles;}
}
