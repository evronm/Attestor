// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Repository.sol";

interface CheatCodes {
    function prank(address) external;
    function expectRevert(bytes calldata) external;
    function startPrank(address) external;
    function stopPrank() external;
}


contract AttestationStructureTest is Test {
  CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
  function testPropNames() public {

  }

}