// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract PriceFeedOracle is Ownable, Pausable {

    uint256 public constant PRECISION = 1e18;

    uint256 public maxPriceAge = 1 hours;

    struct PriceFeedConfig {
        AggregatorV3Interface feed;
        uint8 feedDecimals;
        bool active;
    }

    mapping(bytes32 => PriceFeedConfig) public priceFeeds;

    error InvalidFeed();
    error InvalidPrice();
    error StalePrice();
    error FeedNotActive();
    error InvalidAsset();
    error InvalidMaxAge();

    event FeedUpdated(
        bytes32 indexed asset,
        address indexed feed,
        uint8 decimals
    );

    event FeedStatusChanged(bytes32 indexed asset, bool active);
    event MaxPriceAgeUpdated(uint256 oldAge, uint256 newAge);

    constructor() Ownable(msg.sender) {}

    // Register or update an asset's Chainlink feed
    function setPriceFeed(
        bytes32 asset,
        address feedAddress
    ) external onlyOwner {

        if (asset == bytes32(0)) revert InvalidAsset();
        if (feedAddress == address(0)) revert InvalidFeed();

        AggregatorV3Interface feed =
            AggregatorV3Interface(feedAddress);

        uint8 decimals = feed.decimals();

        priceFeeds[asset] = PriceFeedConfig({
            feed: feed,
            feedDecimals: decimals,
            active: true
        });

        emit FeedUpdated(asset, feedAddress, decimals);
    }

    // Retrieve normalized price with 18 decimals
    function getLatestPrice(
        bytes32 asset
    ) external view whenNotPaused returns (
        uint256 price,
        uint256 updatedAt
    ) {

        PriceFeedConfig memory config = priceFeeds[asset];

        if (!config.active) revert FeedNotActive();

        (
            ,
            int256 answer,
            ,
            uint256 timestamp,
        ) = config.feed.latestRoundData();

        if (answer <= 0) revert InvalidPrice();

        if (
            timestamp == 0 ||
            block.timestamp - timestamp > maxPriceAge
        ) revert StalePrice();

        uint256 rawPrice = uint256(answer);

        // Normalize feed decimals to 18 decimals
        if (config.feedDecimals < 18) {
            price = rawPrice * (10 ** (18 - config.feedDecimals));
        } else if (config.feedDecimals > 18) {
            price = rawPrice / (10 ** (config.feedDecimals - 18));
        } else {
            price = rawPrice;
        }

        return (price, timestamp);
    }

    // Enable or disable an asset feed
    function setFeedStatus(
        bytes32 asset,
        bool active
    ) external onlyOwner {

        if (address(priceFeeds[asset].feed) == address(0)) {
            revert InvalidFeed();
        }

        priceFeeds[asset].active = active;

        emit FeedStatusChanged(asset, active);
    }

    // Update maximum acceptable price age
    function setMaxPriceAge(
        uint256 newAge
    ) external onlyOwner {

        if (newAge == 0) revert InvalidMaxAge();

        emit MaxPriceAgeUpdated(maxPriceAge, newAge);

        maxPriceAge = newAge;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
