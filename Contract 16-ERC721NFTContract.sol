// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {

    uint256 public tokenCounter;

    constructor() ERC721("HarshNFT", "HNFT") Ownable(msg.sender) {
        tokenCounter = 0;
    }

    function mintNFT(address recipient) public onlyOwner {

        uint256 newTokenId = tokenCounter;

        _safeMint(recipient, newTokenId);

        tokenCounter += 1;
    }
}