// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTMarketplace {

    struct Listing {
        address seller;
        uint256 price;
    }

    // NFT contract → tokenId → listing
    mapping(address => mapping(uint256 => Listing)) public listings;

    // List NFT for sale
    function listNFT(
        address nftAddress,
        uint256 tokenId,
        uint256 price
    ) external {

        require(price > 0, "Price must be greater than zero");

        IERC721 nft = IERC721(nftAddress);

        require(nft.ownerOf(tokenId) == msg.sender, "Not NFT owner");

        require(
            nft.getApproved(tokenId) == address(this),
            "Marketplace not approved"
        );

        listings[nftAddress][tokenId] = Listing(msg.sender, price);
    }

    // Buy listed NFT
    function buyNFT(address nftAddress, uint256 tokenId) external payable {

        Listing memory listing = listings[nftAddress][tokenId];

        require(listing.price > 0, "NFT not listed");
        require(msg.value >= listing.price, "Insufficient payment");

        delete listings[nftAddress][tokenId];

        payable(listing.seller).transfer(listing.price);

        IERC721(nftAddress).safeTransferFrom(
            listing.seller,
            msg.sender,
            tokenId
        );
    }

    // Cancel listing
    function cancelListing(address nftAddress, uint256 tokenId) external {

        Listing memory listing = listings[nftAddress][tokenId];

        require(listing.seller == msg.sender, "Not seller");

        delete listings[nftAddress][tokenId];
    }
}