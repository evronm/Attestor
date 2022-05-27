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

    function testMultipleAttestationsMultiplePropsMultipleSigs() public {
        createTestAttestations(5, 3);
        createTestSig("test1", address(10), address(9));
        createTestSig("test1", address(10), address(8));
        createTestSig("test1", address(10), address(7));
        createTestSig("test1", address(9), address(8));
        createTestSig("test1", address(9), address(7));
        assertEq(1,repository.attestations_about(address(9)).length);
        assertEq(2,repository.attestations_about(address(8)).length);
        assertEq(2, repository.attestations()[0].attestors.length);
        assertEq(3, repository.attestations()[0].attestees.length);
        assertEq(address(9), repository.attestations()[0].attestees[0]);
        assertEq(address(7), repository.attestations()[0].attestees[2]);
        assertEq(address(10), repository.attestations()[0].attestors[0]);
        assertEq(address(9), repository.attestations()[0].attestors[1]);

        createTestSig("test4", address(1), address(9));
        createTestSig("test4", address(1), address(10));
        createTestSig("test4", address(2), address(8));
        createTestSig("test4", address(1), address(8));
        createTestSig("test4", address(2), address(9));
        assertEq(3,repository.attestations_about(address(9)).length);
        assertEq(1,repository.attestations_about(address(10)).length);
        assertEq(address(9), repository.attestations()[3].attestees[0]);
        assertEq(address(1), repository.attestations()[3].attestors[0]);

    }
    function createTestAttestations(uint num, uint num_props) public {
        string memory bi;
        string memory bj; //[Beavis and Butthead laugh]
        for (uint i=1;i <= num; i++) {
            delete props;
            bi=["1","2","3","4","5","6","7","8"][i-1];
            for (uint j=1; j<=num_props;j++) {
                bj=["1","2","3","4","5"][j-1];
                props.push(prop(string.concat("name",string(bj),string(bi)), string.concat("test",string(bj),string(bi))));
            }
            repository.create_attestation(string.concat("test",string(bi)),props);
        }
    }
    function createTestSig(string memory handle, address by, address about ) public {
        cheats.startPrank(by);
        repository.attest(handle, about);
        cheats.stopPrank();
    }
}
