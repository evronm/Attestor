// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "./Lib.sol";

contract Repository {
    using Attestations for *;
    using Props for *;
    attestation[] private _attestations;
    attestation_about[] private _attestees;
    attestation_by[] private _attestors;

    //getters
    function attestations() public view returns (attestation[] memory) {return _attestations;}
    function attestatees() public view returns (attestation_about[] memory) {return _attestees;}
    function attestators() public view returns (attestation_by[] memory) {return _attestors;}

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

}
