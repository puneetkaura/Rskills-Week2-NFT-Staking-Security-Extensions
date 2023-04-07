// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

// For these type of contracts - Can I Deploy NFT's via this contract itself ? - Best way to test as address keeps changing

// Have not included the ERC721 but still this works contract ERC721EnumerablePrime is ERC721, ERC721Enumerable
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

// Why do I need to inherit ERC721 when ERC721Enumerable already inherits ERC721
contract ERC721EnumerablePrime is ERC721, ERC721Enumerable {
    constructor() ERC721("NFTPRIME", "NFTPRIME") {}

    // Since only 1-20 TokenIds are allowed, is there a better way to accomplish the former
    modifier checkTokenIdValidity(uint8 tokenId) {
        require(tokenId >= 1 && tokenId <= 20, "TokenId not in range");
        _;
    }

    // Try the ERC721Consecutive.sol
    function mint(uint8 tokenId) external checkTokenIdValidity(tokenId) {
        super._mint(msg.sender, tokenId);
    }

    // Read more about this - if implemented in 2 parents why not call from the first super
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // Read more about this - if implemented in 2 parents why not call from the first super
    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}

contract PrimeCount {
    IERC721Enumerable erc721enumerableNFT;

    // What is a better approach - Pass the contract or passthe contract from IERC(address)
    constructor(address erc721enumerableNFTAddress) {
        erc721enumerableNFT = IERC721Enumerable(erc721enumerableNFTAddress);
    }

    // accepts an address and returns how many NFTs are owned by that address which have tokenIDs that are prime numbers.
    // For example, if an address owns tokenIds 10, 11, 12, 13, it should return 2.
    function countPrimes(address nftHolder) external view returns (uint8) {
        uint8 primeCount;
        // Why can't I call ERC721.balanceOf - Can I do it once I include the ERC21 in import ?
        uint256 nftCount = erc721enumerableNFT.balanceOf(nftHolder);
        require(nftCount > 0, "Address does not own any NFT");

        for (uint8 i = 0; i < nftCount; i++) {
            // for(uint8 i=0; i < erc721enumerableNFT.ERC721.balanceOf(nftHolder); i++){
            uint tokenId = erc721enumerableNFT.tokenOfOwnerByIndex(
                nftHolder,
                i
            );
            if (_checkPrime(tokenId) == true) {
                ++primeCount;
            }
        }
        return primeCount;
    }

    // Why console.log leads to view from pure ? Not able to replicate
    // View vs Pure - Gas cost + Other considerations
    function _checkPrime(uint num) private pure returns (bool) {
        if (num == 1) return false;
        if (num == 2) return true;

        for (uint i = 2; i < num; i++) {
            // console.log(i);
            if (num % i == 0) {
                return false;
            }
        }
        return true;
    }
}
