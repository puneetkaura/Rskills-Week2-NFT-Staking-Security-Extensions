// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "../src/ERC721Enumerable.sol";

import {console} from "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";

contract ERC721EnumerableTest is Test {
    ERC721EnumerablePrime enumerableERC721;
    PrimeCount primeCounter;
    address alice = address(0x1889);
    address bob = address(0x1778);

    function setUp() public {
        enumerableERC721 = new ERC721EnumerablePrime();
        primeCounter = new PrimeCount(address(enumerableERC721));
    }

    function testFailMintExceeded() public {
        vm.startPrank(alice);

        for (uint8 i = 1; i < 30; i++) {
            enumerableERC721.mint(i);
        }
    }

    function testMint() public {
        vm.startPrank(alice);

        for (uint8 i = 1; i < 6; i++) {
            enumerableERC721.mint(i);
        }

        assertEq(enumerableERC721.balanceOf(alice), 5);
    }

    function testPrimeCount() public {
        vm.startPrank(alice);
        uint8[4] memory tokenIds = [10, 11, 12, 13];

        for (uint8 i = 0; i < tokenIds.length; i++) {
            enumerableERC721.mint(tokenIds[i]);
        }

        assertEq(primeCounter.countPrimes(alice), 2);
    }
}
