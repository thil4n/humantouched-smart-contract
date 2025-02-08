// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {ERC721, ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Token is ERC721, ERC721Enumerable, ERC721Burnable, Ownable {
    constructor(
        address initialOwner
    ) ERC721("Token", "MTK") Ownable(initialOwner) {}

    //Events
    event TokensMinted(address indexed user, uint[] tokenIds);

    //Storage variables
    mapping(uint256 => uint) private _initValue;
    mapping(uint256 => uint) private _monthlyIncrementPercent;
    mapping(uint256 => uint256) private _createdTimestamp;

    function safeMint(
        address to,
        uint256 tokenId,
        uint initValue,
        uint monthlyIncrementPercent,
        uint256 createdTimestamp
    ) public onlyOwner {
        _safeMint(to, tokenId);

        _initValue[tokenId] = initValue;
        _monthlyIncrementPercent[tokenId] = monthlyIncrementPercent;
        _createdTimestamp[tokenId] = createdTimestamp;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function mint(
        address userAccount,
        uint tokenCount,
        uint initValue,
        uint monthlyIncrementPercent
    ) external returns (uint[] memory) {
        require(initValue > 0, "Value must be greater than 0");

        uint[] memory mintedTokenIds = new uint[](tokenCount);

        for (uint i = 0; i < tokenCount; i++) {
            uint256 _tokenId = uint256(
                keccak256(abi.encodePacked(block.timestamp, msg.sender, i))
            );

            safeMint(
                userAccount,
                _tokenId,
                initValue,
                monthlyIncrementPercent,
                block.timestamp
            );
            mintedTokenIds[i] = _tokenId;
        }
        emit TokensMinted(userAccount, mintedTokenIds);

        return mintedTokenIds;
    }

    function calculateCurrentValue(uint tokenId) public view returns (uint256) {
        uint256 createdTimeStamp = _createdTimestamp[tokenId];
        uint initValue = _initValue[tokenId];
        uint monthlyIncrementPercent = _monthlyIncrementPercent[tokenId];

        uint256 monthsElapsed = (block.timestamp - createdTimeStamp) / 30 days;
        uint256 currentValue = initValue;

        for (uint i = 0; i < monthsElapsed; i++) {
            currentValue += (currentValue * monthlyIncrementPercent) / 100;
        }

        return currentValue;
    }

    function buyTokens(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    //Overided methods
    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }
}
