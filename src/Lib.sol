// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

struct prop {
  string key;
  string val;
}

struct attestation_instance {
  string[] prop_values;
  address[] attestors;
  address[] attestees;
}

struct reward_formula {
  address struct_addr;
  uint struct_ind;
  string prop_name;
  string prop_value;
  uint tokens;
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
