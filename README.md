# LandDAO Governance System

This project contains two Solidity smart contracts that implement a basic DAO (Decentralized Autonomous Organization) system with its own governance token:

## 📄 Contracts Included

### 1. `GovernanceToken.sol`
A custom ERC-20 token based on OpenZeppelin's implementation. This token acts as the governance token for the DAO.

- **Name:** Gringo Governance Token  
- **Symbol:** GGT  
- **Supply:** 1,000,000 tokens minted to the deployer  
- **Functionality:**  
  - `mint(address, uint256)` — allows the owner to mint new tokens  
  - `burn(address, uint256)` — allows the owner to burn tokens  

Uses OpenZeppelin's `ERC20` and `Ownable` contracts.

---

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
  ```
- **Key Functions:**  
  - `createProposal(string description)`
  - `vote(uint proposalId, bool support)`
  - `executeProposal(uint proposalId)`

Access control and weight of votes can be improved in future versions to consider token balances.

---

## 🛠 Technologies Used

- Solidity ^0.8.20  
- OpenZeppelin Contracts v5.0.0  
- Remix IDE (for deployment and testing)

---

## 🚀 Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/)
- [Hardhat](https://hardhat.org/)
- MetaMask & Sepolia ETH for testnet deployments

### Compile & Deploy

```bash
npx hardhat compile
npx hardhat run scripts/deploy.js --network sepolia
```

*(You can also deploy using Remix, as was done in this project.)*

---

## 📌 License

MIT — free to use, modify, and build upon.

---

**Author:** Gringo  
**Contact:** @Andrei_Shapkin (Telegram)
