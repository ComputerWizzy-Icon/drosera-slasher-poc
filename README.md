
# ⚡ Drosera Slasher Risk Trap (PoC)

A **proof-of-concept** for an on-chain risk detection and response system — designed to simulate how slashing alerts can be triggered, verified, and recorded on Ethereum without relying on trust or off-chain intermediaries.

This PoC demonstrates the foundation for a **decentralized watchdog** that monitors operator behavior and triggers automated on-chain responses when certain risk thresholds are exceeded.

---

## 🧩 Architecture Overview

**Core Contracts**

* **`SlasherRiskTrap.sol`** — Detects and collects potential risk events.
* **`SlasherRiskResponse.sol`** — Handles verified alerts and emits on-chain slashing responses.
* **`SlasherRiskStorage.sol`** — Logs and stores all alerts and responses for transparency.

**Workflow**

1. The Trap contract collects a suspicious event (`collect()`).
2. It checks if the event exceeds a defined threshold (`shouldRespond()`).
3. If yes, it triggers the Response contract (`respondWithSlashingAlert()`).
4. The Response contract emits a verifiable on-chain event that anyone can audit.

This creates a minimal, composable **risk-response loop** that can later evolve into a full **slashing network** with autonomous verification agents.

---

## ⚙️ Setup

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd drosera-slasher-poc
```

### 2. Install dependencies

```bash
forge install
```

### 3. Create a `.env` file

```
RPC_URL=https://sepolia.infura.io/v3/<your-key>
PRIVATE_KEY=<your-private-key>
ETHERSCAN_API_KEY=<your-etherscan-key>
```

### 4. Load environment

```bash
source .env
```

### 5. Build contracts

```bash
forge build
```

### 6. Deploy contracts

```bash
forge create src/SlasherRiskTrap.sol:SlasherRiskTrap --rpc-url $RPC_URL --private-key $PRIVATE_KEY
forge create src/SlasherRiskResponse.sol:SlasherRiskResponse --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

### 7. Trigger a slashing alert

```bash
cast send \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  <SlasherRiskResponse_Address> \
  "respondWithSlashingAlert(address,uint256,uint256,string)" \
  <operator_address> \
  5 \
  3 \
  "Operator exceeded threshold"
```

### 8. Decode emitted logs

```bash
cast --abi-decode \
"Responded(address,uint256,uint256,string)" \
<event_data_from_logs>
```

---

## 🧪 Example Output

When a slashing alert is triggered successfully, you’ll see:

```
status               1 (success)
transactionHash      0xfa0797d4bc4d7d60d78fe03da3e2eec26e9893331624f744a95d8e2d85f0c9d4
logs                 Responded(operator=0x14e4..., riskLevel=5, severity=3, reason="Operator exceeded threshold")
```

---

## 🔮 Future Improvements

* Automate event detection with off-chain monitoring agents
* Add incentive and penalty logic (real slashing mechanics)
* Integrate zkProofs or verifiable credentials for response validation
* Expand into a modular **risk oracle layer** for DeFi protocols

---

## 🛠 Foundry Toolkit

This project is built using **Foundry**, a fast, modular toolkit for Ethereum development written in Rust.

### Components

* **Forge** — Ethereum testing framework
* **Cast** — Command-line tool for interacting with smart contracts
* **Anvil** — Local Ethereum node for development
* **Chisel** — Solidity REPL for quick experimentation

### Documentation

👉 [https://book.getfoundry.sh](https://book.getfoundry.sh)

---

## 🧰 Common Commands

| Command          | Description          |
| ---------------- | -------------------- |
| `forge build`    | Compile contracts    |
| `forge test`     | Run tests            |
| `forge fmt`      | Format Solidity code |
| `forge snapshot` | Capture gas report   |
| `anvil`          | Run local dev node   |
| `cast send`      | Send transaction     |
| `forge script`   | Deploy via script    |

### Help

```bash
forge --help
cast --help
anvil --help
```

---

## 🧠 License

MIT © 2025 Drosera Labs