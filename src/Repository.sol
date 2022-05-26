// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "./Lib.sol";

contract Repository {
    using Attestations for *;
    using Props for *;
    using Utils for *;
    attestation[] private _attestations;
    mapping (address => mapping(uint => address[])) private _attestations_about;
    mapping (address => mapping(uint => address[])) private _attestations_by;
    mapping (address => uint) private _num_attestations_about;
    mapping (address => uint) private _num_attestations_by;

    //getters
    function attestations() public view returns (attestation[] memory) {return _attestations;}
    function attestors_of(address attestee, uint attestation_ind) public view returns (address[] memory) { return _attestations_about[attestee][attestation_ind]; }
    function attestations_about(address attestee) public view returns (uint[] memory) {
        uint[] memory attestation_inds =new uint[](_num_attestations_about[attestee]);
        uint j=0; //No words for how ugly this is...
        for (uint i=0;i<_attestations.length; i++) {
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
        for (uint i=0;i<_attestations.length; i++) {
            if (_attestations_by[attestor][i].length > 0) {
                attestation_inds[j]=i;
                j++;
            }
        }
        return attestation_inds;
    }


    function create_attestation(string memory handle, prop[] calldata props) public returns (attestation memory) {
        require (! Utils.compareStrings("", handle),"Handle is required");
        require(_attestations.get_index_from_handle(handle)==-1, "An attestation with that handle already exists");
        uint new_ind;
        _attestations.push();
        new_ind=_attestations.length - 1;
        _attestations[new_ind].handle=handle;
        for (uint i=0; i < props.length; i++) {
            _attestations[new_ind].props.push(props[i]);
        }
        return _attestations[new_ind];
    }
    function attest(int idx, address attestee) public {
        require(idx>-1, "No Attestation with that handle exists");
        _attestations_about[attestee][uint(idx)].push(msg.sender);
        _num_attestations_about[attestee]+=1;
        _attestations_by[msg.sender][uint(idx)].push(attestee);
        _num_attestations_by[msg.sender]+=1;
        if (_attestations[uint(idx)].attestors.find_in_addr_array(msg.sender) == -1) {
            _attestations[uint(idx)].attestors.push(msg.sender);
        }
        if (_attestations[uint(idx)].attestees.find_in_addr_array(attestee) == -1) {
            _attestations[uint(idx)].attestees.push(attestee);
        }
    }
    //override to allow attesting using handle
    function attest(string memory handle, address attestee) public {
        attest(_attestations.get_index_from_handle(handle), attestee);
    }
}
