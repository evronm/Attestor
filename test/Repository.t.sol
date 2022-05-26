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


contract RepositoryTest is Test {
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
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
    function testAttestationWithProp() public {
        props.push(prop("name","test"));
        repository.create_attestation("test",props);
        assertEq(1,repository.attestations().length);
        assert(Utils.compareStrings("name", repository.attestations()[0].props[0].key));
        assert(! Utils.compareStrings("ame", repository.attestations()[0].props[0].key));
        assert(Utils.compareStrings("test", repository.attestations()[0].props[0].val));
        assert(! Utils.compareStrings("tst", repository.attestations()[0].props[0].val));
    }
    function testAttestationWithProps() public {
        props.push(prop("name","test"));
        props.push(prop("name2","test2"));
        props.push(prop("name3","test3"));
        repository.create_attestation("test",props);
        assertEq(1,repository.attestations().length);
        assert(Utils.compareStrings("name", repository.attestations()[0].props[0].key));
        assert(Utils.compareStrings("test", repository.attestations()[0].props[0].val));
        assert(Utils.compareStrings("name2", repository.attestations()[0].props[1].key));
        assert(Utils.compareStrings("test2", repository.attestations()[0].props[1].val));
        assert(Utils.compareStrings("name3", repository.attestations()[0].props[2].key));
        assert(Utils.compareStrings("test3", repository.attestations()[0].props[2].val));
    }

    function testFailNonExistentAttestation() public { 
        props.push(prop("name","test"));
        repository.create_attestation("test",props);
        cheats.startPrank(address(10));
        repository.attest("asdf", address(9));
    }


    function testAttestationWithSig() public { 
        props.push(prop("name","test"));
        repository.create_attestation("test",props);
        cheats.startPrank(address(10));
        repository.attest("test", address(9));
        assertEq(1,repository.attestations_about(address(9)).length);
        assertEq(1,repository.attestations_by(address(10)).length);
        assertEq(0,repository.attestations_about(address(9))[0]);
        assertEq(0,repository.attestations_by(address(10))[0]);
        assertEq(1, repository.attestations()[0].attestors.length);
        assertEq(1, repository.attestations()[0].attestees.length);
        assertEq(address(9), repository.attestations()[0].attestees[0]);
        assertEq(address(10), repository.attestations()[0].attestors[0]);
    }
}
