// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "../src/Overmint2.sol";

import {console} from "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";

contract Overmint2Test is Test {
    Overmint2 overmint2NFT;
    Overmint2Attacker attacker;
    address owner = address(0x1223);
    address alice = address(0x1889);

    // Deploy the Overmint2 NFT contract
    function setUp() public {
        overmint2NFT = new Overmint2();
    }

    // Test regular mint of 4 NFT's by an address
    function testRegularMint() public {
        vm.startPrank(alice);
        overmint2NFT.mint();
        overmint2NFT.mint();
        overmint2NFT.mint();
        overmint2NFT.mint();

        console.log(overmint2NFT.balanceOf(alice));
    }

    // Test regular mint of 5 NFT's by an address
    function testFailRegularMint() public {
        vm.startPrank(alice);
        overmint2NFT.mint();
        overmint2NFT.mint();
        overmint2NFT.mint();
        overmint2NFT.mint();
        overmint2NFT.mint();
    }

    // Deploy attack contract and  mint 5 NFT's
    function testAttackAndMint5NFTs() public {
        attacker = new Overmint2Attacker(address(overmint2NFT));
        attacker.attack();
        assertEq(overmint2NFT.balanceOf(address(attacker)), 5);
    }
}
