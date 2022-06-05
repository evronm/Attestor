// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Factory.sol";
import "src/AttestationStructure.sol";

interface CheatCodes {
    function prank(address) external;
    function expectRevert(bytes calldata) external;
    function startPrank(address) external;
    function stopPrank() external;
}

contract AttestationStructureTest is Test {
  CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
  string[] foo; // Oh boy, does this suck!
  Factory factory=new Factory();
  AttestationStructure s;

  function testPropNames() public {
    foo=["name","date","place"];
    s=new AttestationStructure().init("test",foo);
    assertEq(3,s.prop_names().length);
    assert(Utils.compareStrings("name", s.prop_names()[0]));
    assert(Utils.compareStrings("place", s.prop_names()[2]));
  }
  function testInstances() public {
    testPropNames();
    s.new_instance(foo);
    assertEq(1,s.instances().length);
    assert(Utils.compareStrings("name", s.instances()[0].prop_values[0]));
    assert(Utils.compareStrings("date", s.instances()[0].prop_values[1]));
    foo=["name1","date1","place1"];
    s.new_instance(foo);
    foo=["name2","date2","place2"];
    s.new_instance(foo);
    assertEq(3,s.instances().length);
    assert(Utils.compareStrings("name1", s.instances()[1].prop_values[0]));
    assert(Utils.compareStrings("date2", s.instances()[2].prop_values[1]));
    assert(Utils.compareStrings("place2", s.instances()[2].prop_values[2]));
  }

  function testSigs() public {
    createTestStructures(5, 3);
    assertEq(5,factory.handles().length);
    assertEq(3, AttestationStructure(factory.attestation_structures("handle1")).prop_names().length);
    createTestInstances("handle1", 4);
    assertEq(4, AttestationStructure(factory.attestation_structures("handle1")).instances().length);

  }

  function createTestStructures(uint num, uint num_props) private {
    for (uint i=1;i <= num; i++) {
      delete foo;
      for (uint j=1; j<=num_props;j++) {
        foo.push(string.concat("propname",str_num(i),str_num(j)));
      }
      factory.create_attestation_structure(string.concat("handle", str_num(i)), foo);
    }
  }
  function createTestInstances(string memory handle, uint num) private {
    s=AttestationStructure(factory.attestation_structures(handle));
    delete foo;
    for (uint i=1;i <= s.prop_names().length; i++) {
      foo.push(string.concat("val", str_num(i)));
    }
    for (uint i=1;i <= num; i++) {
      s.new_instance(foo);
    }
  }
  function str_num(uint i) private view returns (string memory) {
    return ["1","2","3","4","5","6","7","8","9"][i-1];
  }

}