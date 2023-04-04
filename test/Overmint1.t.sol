// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "../src/Overmint1.sol";

import {console} from "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";

contract Overmint1Test is Test {
    Overmint1 overmint1NFT;
    Overmint1Attacker attacker;
    address owner = address(0x1223);
    address alice = address(0x1889);
    address bob = address(0x1778);

    // Deploy the Overmin1 NFT contract
    function setUp() public {
        // vm.startPrank(owner);
        overmint1NFT = new Overmint1();
        // vm.stopPrank();
    }

    // Test regular mint of 4 NFT's by an address
    function testRegularMint() public {
        vm.startPrank(alice);
        overmint1NFT.mint();
        overmint1NFT.mint();
        overmint1NFT.mint();
        overmint1NFT.mint();
    }

    // Test regular mint of 5 NFT's by an address
    function testFailRegularMint() public {
        vm.startPrank(alice);
        overmint1NFT.mint();
        overmint1NFT.mint();
        overmint1NFT.mint();
        overmint1NFT.mint();
        overmint1NFT.mint();
    }

    // Deploy attack contract and  mint 5 NFT's
    function testAttackAndMint5NFTs() public {
        attacker = new Overmint1Attacker(address(overmint1NFT));
        attacker.attackAndOvermint();
        assertEq(overmint1NFT.balanceOf(address(attacker)), 5);
    }
}
