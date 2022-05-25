// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Repository.sol";
contract RepositoryTest is Test {
    Repository repository;
    prop[] props; //Man, this sucks!!
    function setUp() public {
        repository=new Repository();
    }

    function testFailNoHandle() public {
        repository.create_attestation("",props);
    }
    function testFailDup() public {
        repository.create_attestation("test",props);
        repository.create_attestation("test",props);
    }
    function testAttestationWithProps() public {
        props.push(prop("name","test"));
        repository.create_attestation("test",props);
        assertEq(1,repository.attestations().length);
        assert(Utils.compareStrings("name", repository.attestations()[0].props[0].key));
        assert(Utils.compareStrings("test", repository.attestations()[0].props[0].val));
    }
}
