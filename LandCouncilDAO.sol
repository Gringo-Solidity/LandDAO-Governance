// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ILandRegistry {
    function registerPlotFromDAO(string memory _coords, address _owner) external;
    function transferPlotFromDAO(uint256 plotId, address newOwner) external;
    function removePlotFromDAO(uint256 plotId) external;
}

contract LandCouncilDAO is Ownable {
    IERC20 public governanceToken;
    ILandRegistry public registry;
    uint256 public proposalCount;

    enum ProposalType { RegisterPlot, TransferPlot, RemovePlot }

    struct Proposal {
        uint256 id;
        ProposalType proposalType;
        string coordinates;
        address targetOwner;
        uint256 plotIdToModify;
        uint256 voteYes;
        uint256 voteNo;
        uint256 deadline;
        bool executed;
        address proposer;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public voted;

    event ProposalCreated(uint256 indexed id, ProposalType proposalType, address proposer);
    event Voted(uint256 indexed proposalId, address voter, bool support, uint256 weight);
    event ProposalExecuted(uint256 indexed proposalId, bool accepted);

    constructor(address _token, address _registry) {
        governanceToken = IERC20(_token);
        registry = ILandRegistry(_registry);
    }

    function createRegisterProposal(string memory _coordinates, address _targetOwner, uint256 _votingPeriod) external {
        _createProposal(ProposalType.RegisterPlot, _coordinates, _targetOwner, 0, _votingPeriod);
    }

    function createTransferProposal(uint256 _plotId, address _newOwner, uint256 _votingPeriod) external {
        _createProposal(ProposalType.TransferPlot, "", _newOwner, _plotId, _votingPeriod);
    }

    function createRemoveProposal(uint256 _plotId, uint256 _votingPeriod) external {
        _createProposal(ProposalType.RemovePlot, "", address(0), _plotId, _votingPeriod);
    }

    function _createProposal(
        ProposalType _type,
        string memory _coords,
        address _target,
        uint256 _plotId,
        uint256 _period
    ) internal {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            proposalType: _type,
            coordinates: _coords,
            targetOwner: _target,
            plotIdToModify: _plotId,
            voteYes: 0,
            voteNo: 0,
            deadline: block.timestamp + _period,
            executed: false,
            proposer: msg.sender
        });

        emit ProposalCreated(proposalCount, _type, msg.sender);
    }

    function vote(uint256 _proposalId, bool support) external {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp < p.deadline, "Voting ended");
        require(!voted[_proposalId][msg.sender], "Already voted");

        uint256 weight = governanceToken.balanceOf(msg.sender);
        require(weight > 0, "No voting power");

        if (support) {
            p.voteYes += weight;
        } else {
            p.voteNo += weight;
        }

        voted[_proposalId][msg.sender] = true;
        emit Voted(_proposalId, msg.sender, support, weight);
    }

    function execute(uint256 _proposalId) external {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp >= p.deadline, "Voting not ended");
        require(!p.executed, "Already executed");

        p.executed = true;
        bool accepted = p.voteYes > p.voteNo;

        if (accepted) {
            if (p.proposalType == ProposalType.RegisterPlot) {
                registry.registerPlotFromDAO(p.coordinates, p.targetOwner);
            } else if (p.proposalType == ProposalType.TransferPlot) {
                registry.transferPlotFromDAO(p.plotIdToModify, p.targetOwner);
            } else if (p.proposalType == ProposalType.RemovePlot) {
                registry.removePlotFromDAO(p.plotIdToModify);
            }
        }

        emit ProposalExecuted(_proposalId, accepted);
    }

    function setRegistry(address _registry) external onlyOwner {
        registry = ILandRegistry(_registry);
    }

    function setGovernanceToken(address _token) external onlyOwner {
        governanceToken = IERC20(_token);
    }
}
