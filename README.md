# LandDAO Governance System

This project contains two Solidity smart contracts that implement a basic DAO (Decentralized Autonomous Organization) system with its own governance token:

##  Contracts Included

### 1. `GovernanceToken.sol`
A custom ERC-20 token based on OpenZeppelin's implementation. This token acts as the governance token for the DAO.

- **Name:** Gringo Governance Token  
- **Symbol:** GGT  
- **Supply:** 1,000,000 tokens minted to the deployer  
- **Functionality:**  
  - `mint(address, uint256)` — allows the owner to mint new tokens  
  - `burn(address, uint256)` — allows the owner to burn tokens  

Uses OpenZeppelin's `ERC20` and `Ownable` contracts.



### 2. `LandCouncilDAO.sol`
A minimal DAO contract where token holders can create proposals and vote. This DAO governs actions related to land registration or other community-based decisions.

- **Proposal Structure:**  
  ```solidity
  struct Proposal {
      string description;
      uint256 votesFor;
      uint256 votesAgainst;
      bool executed;
  }
  
- **Key Functions:**  
  - `createProposal(string description)`
  - `vote(uint proposalId, bool support)`
  - `executeProposal(uint proposalId)`




##  Technologies Used

- Solidity ^0.8.20  
- OpenZeppelin Contracts v5.0.0  
- Remix IDE (for deployment and testing)




## Author
 Contact: [@Andrei_Shapkin](https://t.me/Andrei_Shapkin)  
 GitHub: [Gringo-Solidity](https://github.com/Gringo-Solidity)
