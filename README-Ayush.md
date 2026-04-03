# NoFeeSwap Deployment Setup
This repository demonstrates the deployment and testing of the NoFeeSwap protocol locally. It covers setting up a local blockchain, deploying core and operator contracts, and deploying and minting two mock ERC-20 tokens for testing purposes.

# Table of Contents
- Overview
- Prerequisites
- Setup Local Blockchain
- Deploy Core Contracts
- Deploy Operator Contracts
- Deploy and Mint Mock Tokens
- References

# Overview
NoFeeSwap is a protocol that allows permissionless swaps without fees. This project demonstrates how to deploy its core contracts, operator contracts, and mock tokens on a local blockchain for testing purposes.

# Prerequisites
- Foundry
- Solidity
- Git

# Setup Local Blockchain
- Install foundry
For Windows / Mac / Linux (via curl):
    \`\`\`bash
        curl -L https://foundry.paradigm.xyz | bash
    \`\`\`

After installation, update your path and install latest Foundry binaries:
    \`\`\`bash
        foundryup
    \`\`\`
(if showing command not found, close the git bash and reopen it)

Check installation:
    \`\`\`bash
        forge --version
        anvil --version
        cast --version
    \`\`\`

- Start Local Blockchain
    Run:
    \`\`\`bash
        anvil
    \`\`\`
    (keep it running and execute other commands in new git bash terminal)
    We'll get:
    - RPC: http://127.0.0.8545
    - Private keys (copy any one to be used as deployer key)
    - Accounts (we can select any account from it for smart contract)
    - Other info (like gas limit, base fee, chain id, etc.)

- Clone Repositories (core and operator)
    Run:
    \`\`\`bash
        git clone https://github.com/NoFeeSwap/core.git
        git clone https://github.com/NoFeeSwap/operator.git
    \`\`\`

# Deploy Core Contracts
- Compile Core Contracts
    \`\`\`bash
        cd core
        forge install
        forge build
    \`\`\`

- Execute Script for Core Contracts
    Run:
    \`\`\`bash
        forge script script/DeployCore.s.sol:DeployCore --rpc-url http://127.0.0.1:8545 --broadcast
    \`\`\`

# Deploy Operator Contracts
- Compile Operator Contracts
    \`\`\`bash
        cd operator
        forge install
        forge build
    \`\`\`

- Execute Script for Operator Contracts
    Run:
    \`\`\`bash
        forge script script/DeployOperator.s.sol:DeployOperator --rpc-url http://127.0.0.1:8545 --broadcast
    \`\`\`

# Deploy and Mint Mock Tokens
For checking if the token is minted or not, use the token address from the logs of script and add it to CheckMint.s.sol, execute it and track the transaction balance and if it is greater than 0, it is minted. I know it is not automated yet, I am working upon it.

- Execute Script for Mint Mock Tokens
    Run:
    \`\`\`bash
        forge script script/CheckMint.s.sol:CheckMint --rpc-url http://127.0.0.1:8545 --broadcast
    \`\`\`

# Keys and Credentials
- Private Key:
    Directly exported to git bash as DEPLOYER_KEY which is fetched through anvil(any private key)
- Kernel and Curve Hex Value
    1. Take pre-computed hex values for kernel to activate this parameter somewhat in middle near to 160. 
    2. Similarly, take it for liquidity curve to increase price by tiny amount for every 1 token bought or 0 and then again 8 for showcasing slippage to predict how much the price bounce during trade

# References
- Repository Reference
These are the GitHub repositories you rely on for core and operator contracts:
1. NoFeeSwap Core Contracts
    - GitHub: https://github.com/NoFeeSwap/core
    - Contains the main protocol logic: pools, swaps, and internal utilities.
2. NoFeeSwap Operator Contracts
    - GitHub: https://github.com/NoFeeSwap/operator
    - Contains operator scripts that interact with the core protocol.
    - Examples include swap execution, pool management, and delegated calls.

- Test References
1. Initialize_test.py
    - Path: core/tests/Initialize_test.py
    - Lines L67-L78 show how to initialize pools and deploy the protocol in a test environment.
    - Acts as a reference for deploying core contracts correctly.
2. SwapData_test.py
    - Path: operator/tests/SwapData_test.py
    - Shows how operator contracts interact with the core contracts.
    - Useful for writing operator scripts and understanding function calls.

- ERC-20 References
Since we need mock tokens for testing:
1. ERC-20 Standard (EIP-20): https://eips.ethereum.org/EIPS/eip-20
2. Provides the standard interface for creating mock tokens (mint, transfer, approve).

- Paper Reference
1. NoFeeSwap YellowPaper: https://github.com/NoFeeSwap/docs/blob/main/yellowpaper.pdf


