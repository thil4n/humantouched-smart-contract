// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MarketPlace is ERC721URIStorage, Ownable {
    uint256 public tokenCount;

    struct Property {
        uint256 price;
        bool forSale;
    }

    mapping(uint256 => Property) public properties;

    event TokenListed(uint256 indexed tokenId, uint256 price);
    event TokenSold(uint256 indexed tokenId, address indexed buyer);

    constructor() ERC721("HumanTouchedTokens", "HTT") {}

    // Function to mint a new token
    function mintToken(string memory tokenURI, uint256 price) public onlyOwner {
        tokenCount++;
        uint256 tokenId = tokenCount;

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);

        properties[tokenId] = Property({price: price, forSale: true});

        emit TokenListed(tokenId, price);
    }

    // Function to buy a token
    function buyToken(uint256 tokenId) public payable {
        Property storage property = properties[tokenId];
        require(property.forSale, "Token is not for sale");
        require(msg.value == property.price, "Incorrect value sent");

        address previousOwner = ownerOf(tokenId);
        require(
            previousOwner != msg.sender,
            "Owner cannot buy their own Token"
        );

        // Update state before external calls
        property.forSale = false;

        // Transfer ownership
        _transfer(previousOwner, msg.sender, tokenId);

        // Send funds safely
        (bool sent, ) = payable(previousOwner).call{value: msg.value}("");
        require(sent, "Payment failed");

        emit TokenSold(tokenId, msg.sender);
    }

    // Function to list a purchased token for resale
    function listTokenForSale(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "Not the token owner");
        require(price > 0, "Price must be greater than zero");

        properties[tokenId] = Property({price: price, forSale: true});

        emit TokenListed(tokenId, price);
    }

    // Function to get all listed tokens
    function getListedTokens()
        public
        view
        returns (uint256[] memory, uint256[] memory)
    {
        uint256 listedCount = 0;

        // Count listed tokens
        for (uint256 i = 1; i <= tokenCount; i++) {
            if (properties[i].forSale) {
                listedCount++;
            }
        }

        // Prepare arrays
        uint256[] memory ids = new uint256[](listedCount);
        uint256[] memory prices = new uint256[](listedCount);
        uint256 index = 0;

        // Populate arrays
        for (uint256 i = 1; i <= tokenCount; i++) {
            if (properties[i].forSale) {
                ids[index] = i;
                prices[index] = properties[i].price;
                index++;
            }
        }

        return (ids, prices);
    }
}
