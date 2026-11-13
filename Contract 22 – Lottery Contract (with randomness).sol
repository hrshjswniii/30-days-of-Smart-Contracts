// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {VRFConsumerBaseV2Plus} from
    "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";

import {VRFV2PlusClient} from
    "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

import {Ownable} from
    "@openzeppelin/contracts/access/Ownable.sol";

import {Pausable} from
    "@openzeppelin/contracts/utils/Pausable.sol";

import {ReentrancyGuard} from
    "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract AdvancedLottery is
    VRFConsumerBaseV2Plus,
    Ownable,
    Pausable,
    ReentrancyGuard
{
    // --------------------------------------------------
    // CONSTANTS
    // --------------------------------------------------

    uint256 public constant FEE_DENOMINATOR = 10_000;
    uint16 public constant MAX_FEE_BPS = 1_000;

    // --------------------------------------------------
    // ENUMS & STRUCTS
    // --------------------------------------------------

    enum RoundStatus {
        NONE,
        OPEN,
        RANDOMNESS_PENDING,
        COMPLETED,
        CANCELLED
    }

    struct Round {
        uint256 entryFee;
        uint256 prizePool;
        uint256 requestId;
        address winner;
        uint64 startedAt;
        uint64 completedAt;
        uint32 totalEntries;
        uint32 maxEntries;
        RoundStatus status;
    }

    // --------------------------------------------------
    // STATE VARIABLES
    // --------------------------------------------------

    uint256 public currentRoundId;

    uint256 public subscriptionId;
    bytes32 public keyHash;

    uint32 public callbackGasLimit;
    uint16 public requestConfirmations;

    bool public nativePayment;

    uint16 public feeBps;

    address public treasury;

    mapping(uint256 => Round) public rounds;

    mapping(uint256 => address[]) private s_entrants;

    mapping(uint256 => uint256) public requestToRound;

    mapping(address => uint256) public pendingWithdrawals;

    // --------------------------------------------------
    // EVENTS
    // --------------------------------------------------

    event RoundStarted(
        uint256 indexed roundId,
        uint256 entryFee,
        uint32 maxEntries
    );

    event TicketPurchased(
        uint256 indexed roundId,
        address indexed participant,
        uint32 totalEntries
    );

    event RandomnessRequested(
        uint256 indexed roundId,
        uint256 indexed requestId
    );

    event WinnerSelected(
        uint256 indexed roundId,
        address indexed winner,
        uint256 prize
    );

    event PrizeWithdrawn(
        address indexed recipient,
        uint256 amount
    );

    event RoundCancelled(uint256 indexed roundId);

    event TreasuryUpdated(address indexed newTreasury);

    event FeeUpdated(uint16 newFeeBps);

    event VRFConfigUpdated(
        uint256 subscriptionId,
        bytes32 keyHash
    );

    // --------------------------------------------------
    // CUSTOM ERRORS
    // --------------------------------------------------

    error InvalidConfiguration();
    error InvalidEntryFee();
    error InvalidRound();
    error RoundNotOpen();
    error RoundNotReady();
    error RoundCapacityReached();
    error IncorrectPayment();
    error InsufficientEntries();
    error RandomnessAlreadyRequested();
    error InvalidRequest();
    error NoFundsToWithdraw();
    error NothingToCancel();
    error InvalidTreasury();

    // --------------------------------------------------
    // CONSTRUCTOR
    // --------------------------------------------------

    constructor(
        address vrfCoordinator,
        uint256 _subscriptionId,
        bytes32 _keyHash,
        uint32 _callbackGasLimit,
        uint16 _requestConfirmations,
        bool _nativePayment,
        address _treasury
    )
        VRFConsumerBaseV2Plus(vrfCoordinator)
        Ownable(msg.sender)
    {
        if (
            vrfCoordinator == address(0) ||
            _treasury == address(0) ||
            _callbackGasLimit == 0 ||
            _requestConfirmations == 0
        ) {
            revert InvalidConfiguration();
        }

        subscriptionId = _subscriptionId;
        keyHash = _keyHash;
        callbackGasLimit = _callbackGasLimit;
        requestConfirmations = _requestConfirmations;
        nativePayment = _nativePayment;

        treasury = _treasury;

        feeBps = 500; // 5% protocol fee
    }

    // --------------------------------------------------
    // ROUND MANAGEMENT
    // --------------------------------------------------

    function startRound(
        uint256 _entryFee,
        uint32 _maxEntries
    )
        external
        onlyOwner
        whenNotPaused
    {
        if (_entryFee == 0) revert InvalidEntryFee();

        if (_maxEntries < 2) revert InvalidConfiguration();

        currentRoundId++;

        rounds[currentRoundId] = Round({
            entryFee: _entryFee,
            prizePool: 0,
            requestId: 0,
            winner: address(0),
            startedAt: uint64(block.timestamp),
            completedAt: 0,
            totalEntries: 0,
            maxEntries: _maxEntries,
            status: RoundStatus.OPEN
        });

        emit RoundStarted(
            currentRoundId,
            _entryFee,
            _maxEntries
        );
    }

    // --------------------------------------------------
    // ENTER LOTTERY
    // --------------------------------------------------

    function enterLottery(
        uint256 _roundId
    )
        external
        payable
        whenNotPaused
        nonReentrant
    {
        Round storage round = rounds[_roundId];

        if (_roundId == 0) revert InvalidRound();

        if (round.status != RoundStatus.OPEN) {
            revert RoundNotOpen();
        }

        if (msg.value != round.entryFee) {
            revert IncorrectPayment();
        }

        if (round.totalEntries >= round.maxEntries) {
            revert RoundCapacityReached();
        }

        s_entrants[_roundId].push(msg.sender);

        round.totalEntries++;
        round.prizePool += msg.value;

        emit TicketPurchased(
            _roundId,
            msg.sender,
            round.totalEntries
        );
    }

    // --------------------------------------------------
    // REQUEST CHAINLINK VRF RANDOMNESS
    // --------------------------------------------------

    function requestWinner(
        uint256 _roundId
    )
        external
        whenNotPaused
        nonReentrant
    {
        Round storage round = rounds[_roundId];

        if (round.status != RoundStatus.OPEN) {
            revert RoundNotOpen();
        }

        if (round.totalEntries < 2) {
            revert InsufficientEntries();
        }

        if (round.requestId != 0) {
            revert RandomnessAlreadyRequested();
        }

        // Update state before making the external call.
        round.status = RoundStatus.RANDOMNESS_PENDING;

        uint256 requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: 1,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({
                        nativePayment: nativePayment
                    })
                )
            })
        );

        round.requestId = requestId;
        requestToRound[requestId] = _roundId;

        emit RandomnessRequested(_roundId, requestId);
    }

    // --------------------------------------------------
    // CHAINLINK VRF CALLBACK
    // --------------------------------------------------

    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] calldata _randomWords
    )
        internal
        override
    {
        uint256 roundId = requestToRound[_requestId];

        // Unknown or already-processed request.
        if (roundId == 0) return;

        Round storage round = rounds[roundId];

        if (
            round.status != RoundStatus.RANDOMNESS_PENDING ||
            round.requestId != _requestId
        ) {
            return;
        }

        delete requestToRound[_requestId];

        uint256 winningIndex =
            _randomWords[0] % round.totalEntries;

        address winner = s_entrants[roundId][winningIndex];

        uint256 protocolFee =
            (round.prizePool * feeBps) / FEE_DENOMINATOR;

        uint256 winnerPrize =
            round.prizePool - protocolFee;

        // Effects: record all accounting before any withdrawal.
        round.winner = winner;
        round.completedAt = uint64(block.timestamp);
        round.status = RoundStatus.COMPLETED;

        pendingWithdrawals[winner] += winnerPrize;
        pendingWithdrawals[treasury] += protocolFee;

        emit WinnerSelected(
            roundId,
            winner,
            winnerPrize
        );
    }

    // --------------------------------------------------
    // WITHDRAWALS
    // --------------------------------------------------

    function withdrawPrize()
        external
        nonReentrant
    {
        uint256 amount = pendingWithdrawals[msg.sender];

        if (amount == 0) revert NoFundsToWithdraw();

        // Checks-effects-interactions.
        pendingWithdrawals[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{
            value: amount
        }("");

        require(success, "Withdrawal failed");

        emit PrizeWithdrawn(msg.sender, amount);
    }

    // --------------------------------------------------
    // ROUND CANCELLATION
    // --------------------------------------------------

    function cancelEmptyRound(
        uint256 _roundId
    )
        external
        onlyOwner
    {
        Round storage round = rounds[_roundId];

        if (round.status != RoundStatus.OPEN) {
            revert RoundNotOpen();
        }

        // Only empty rounds can be cancelled.
        if (round.totalEntries != 0) {
            revert NothingToCancel();
        }

        round.status = RoundStatus.CANCELLED;

        emit RoundCancelled(_roundId);
    }

    // --------------------------------------------------
    // ADMIN CONFIGURATION
    // --------------------------------------------------

    function updateVRFConfig(
        uint256 _subscriptionId,
        bytes32 _keyHash,
        uint32 _callbackGasLimit,
        uint16 _requestConfirmations,
        bool _nativePayment
    )
        external
        onlyOwner
    {
        if (
            _callbackGasLimit == 0 ||
            _requestConfirmations == 0
        ) {
            revert InvalidConfiguration();
        }

        subscriptionId = _subscriptionId;
        keyHash = _keyHash;
        callbackGasLimit = _callbackGasLimit;
        requestConfirmations = _requestConfirmations;
        nativePayment = _nativePayment;

        emit VRFConfigUpdated(
            _subscriptionId,
            _keyHash
        );
    }

    function updateTreasury(
        address _newTreasury
    )
        external
        onlyOwner
    {
        if (_newTreasury == address(0)) {
            revert InvalidTreasury();
        }

        treasury = _newTreasury;

        emit TreasuryUpdated(_newTreasury);
    }

    function updateFee(
        uint16 _newFeeBps
    )
        external
        onlyOwner
    {
        if (_newFeeBps > MAX_FEE_BPS) {
            revert InvalidConfiguration();
        }

        feeBps = _newFeeBps;

        emit FeeUpdated(_newFeeBps);
    }

    // --------------------------------------------------
    // EMERGENCY CONTROLS
    // --------------------------------------------------

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    // --------------------------------------------------
    // VIEW FUNCTIONS
    // --------------------------------------------------

    function getRoundEntrants(
        uint256 _roundId
    )
        external
        view
        returns (address[] memory)
    {
        return s_entrants[_roundId];
    }

    function getEntrantAt(
        uint256 _roundId,
        uint256 _index
    )
        external
        view
        returns (address)
    {
        return s_entrants[_roundId][_index];
    }

    function getRoundInfo(
        uint256 _roundId
    )
        external
        view
        returns (
            uint256 entryFee,
            uint256 prizePool,
            uint32 totalEntries,
            uint32 maxEntries,
            address winner,
            RoundStatus status
        )
    {
        Round storage round = rounds[_roundId];

        return (
            round.entryFee,
            round.prizePool,
            round.totalEntries,
            round.maxEntries,
            round.winner,
            round.status
        );
    }
}
