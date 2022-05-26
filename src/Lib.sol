// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

struct prop {
  string key;
  string val;
}
struct tag {
  string tag;
  string[] names;
}
struct attestation {
    string handle;
    prop[] props;
    address[] attestors;
    address[] attestees;
}

library Utils {
  function compareStrings(string memory a, string memory b) public pure returns (bool) {
    return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
  }
  function find_in_addr_array(address[] memory ary, address addy) public pure returns (int) {
      for(uint i=0; i<ary.length;i++) {
          if (ary[i] == addy) {
              return int(i);
          }
      }
      return -1;
  }
}

library Props {
  function get_index_from_key(prop[] memory props, string memory key) internal pure returns (int) {
    for (uint i=0;i < props.length; i++) {
      if ( Utils.compareStrings(props[i].key, key)) {
        return int(i);
      }
    }
    return -1;
  }
  function get_val_from_key(prop[] memory props, string memory key) public pure returns (string memory) {
    int i=get_index_from_key(props, key);
    require(i > -1);
    return props[uint(i)].val;
  }

}

library Attestations {
  function get_index_from_handle(attestation[] memory attestations, string memory handle) internal pure returns (int) {
    for (uint i=0;i < attestations.length; i++) {
      if ( Utils.compareStrings(attestations[i].handle, handle)) {
        return int(i);
      }
    }
    return -1;
  }
    
}