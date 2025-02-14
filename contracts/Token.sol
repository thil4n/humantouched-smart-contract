// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;
    mapping(uint256 => uint256) public tokenIdToPrice;
    mapping(uint256 => bool) public tokenIdToListed;

    event NFTListed(uint256 indexed tokenId, uint256 price);
    event NFTPurchased(uint256 indexed tokenId, address buyer, uint256 price);

    struct TokenInfo {
        uint256 tokenId;
        uint256 price;
        string tokenURI;
    }

    // Pass the `initialOwner` address to the Ownable constructor
    constructor(
        address initialOwner
    ) ERC721("Token", "HTT") Ownable(initialOwner) {
        tokenCounter = 0;
    }

    // Admin can mint NFTs
    function mintNFT(string memory tokenURI, uint256 price) public onlyOwner {
        _safeMint(msg.sender, tokenCounter);
        _setTokenURI(tokenCounter, tokenURI); // Set the token URI
        tokenIdToPrice[tokenCounter] = price;
        tokenIdToListed[tokenCounter] = true;
        emit NFTListed(tokenCounter, price);
        tokenCounter++;
    }

    // Users can buy listed NFTs
    function buyNFT(uint256 tokenId) public payable {
        require(tokenIdToListed[tokenId], "NFT is not listed for sale");
        require(msg.value >= tokenIdToPrice[tokenId], "Insufficient funds");

        address seller = ownerOf(tokenId);
        _transfer(seller, msg.sender, tokenId);

        // Transfer funds to the seller
        payable(seller).transfer(msg.value);

        // Mark the NFT as not listed
        tokenIdToListed[tokenId] = false;

        emit NFTPurchased(tokenId, msg.sender, msg.value);
    }

    // Get a list of all NFTs currently listed for sale
    function getListedNFTs() public view returns (TokenInfo[] memory) {
        uint256 listedCount = 0;

        // Count the number of listed NFTs
        for (uint256 i = 0; i < tokenCounter; i++) {
            if (tokenIdToListed[i]) {
                listedCount++;
            }
        }

        TokenInfo[] memory listedNFTs = new TokenInfo[](listedCount);
        uint256 index = 0;

        // Populate the array with token info
        for (uint256 i = 0; i < tokenCounter; i++) {
            if (tokenIdToListed[i]) {
                listedNFTs[index] = TokenInfo({
                    tokenId: i,
                    price: tokenIdToPrice[i],
                    tokenURI: tokenURI(i)
                });
                index++;
            }
        }

        return listedNFTs;
    }
}
