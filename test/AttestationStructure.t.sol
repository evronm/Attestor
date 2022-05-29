// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
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
  AttestationStructure s;
  function testPropNames() public {
    foo=["name","date","place"];
    s=new AttestationStructure(foo);
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

}