# Bitcoin-Reactive NFT Project

A sophisticated NFT collection that dynamically evolves based on Bitcoin network events, built on the Stacks blockchain. Each NFT in this collection responds to and changes based on Bitcoin block data, creating a unique connection between NFT attributes and blockchain activity.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Technical Architecture](#technical-architecture)
- [Getting Started](#getting-started)
- [Contract Functions](#contract-functions)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)
- [Security](#security)
- [Contributing](#contributing)
- [License](#license)

## Overview

The Bitcoin-Reactive NFT project creates dynamic NFTs that evolve based on Bitcoin network activities. Each NFT maintains a state that changes according to Bitcoin block confirmations, network difficulty, and transaction volumes.

### Core Concepts
- Dynamic evolution based on Bitcoin network events
- Metadata updates reflecting blockchain state
- Multi-stage progression system
- SIP-009 compliant implementation

## Features

### NFT Evolution System
- Multiple evolution stages
- Bitcoin-triggered state changes
- Progressive metadata updates
- Verifiable on-chain history

### Evolution Triggers
- Bitcoin block confirmations (144 blocks minimum)
- Network difficulty thresholds
- Transaction volume milestones
- Time-based progression gates

### Metadata System
- Dynamic URI generation
- Bitcoin state tracking
- Evolution history
- Stage-based attributes

## Technical Architecture

### Project Structure
```
bitcoin-reactive-nft/
├── Clarinet.toml
├── contracts/
│   ├── dynamic-nft.clar        # Main NFT contract
│   └── traits/
│       └── nft-trait.clar      # SIP-009 trait implementation
├── tests/
│   └── dynamic-nft_test.ts     # Test suite
├── scripts/
│   ├── deploy.ts               # Deployment scripts
│   └── interact.ts             # Contract interaction utilities
└── frontend/                   # Optional web interface
```

### Smart Contract Components
1. NFT Core Logic
2. Evolution Mechanics
3. Metadata Management
4. Bitcoin Network Interface

## Getting Started

### Prerequisites
```bash
# Install Clarinet
curl -L https://github.com/hirosystems/clarinet/releases/download/v1.0.0/clarinet-linux-x64-glibc.tar.gz | tar xz

# Install Stacks CLI
npm install -g @stacks/cli

# Clone Repository
git clone https://github.com/your-username/bitcoin-reactive-nft
cd bitcoin-reactive-nft
```

### Environment Setup
```bash
# Initialize project
clarinet new bitcoin-reactive-nft

# Install dependencies
clarinet install

# Configure network (local)
clarinet integrate
```

## Contract Functions

### Core Functions

#### Minting
```clarity
(define-public (mint))
```
Creates new NFT with initial state

#### Evolution
```clarity
(define-public (evolve-nft (token-id uint)))
```
Progresses NFT to next stage if conditions met

#### Metadata
```clarity
(define-read-only (get-token-uri (token-id uint)))
```
Returns current token URI based on stage

### Admin Functions
```clarity
(define-public (activate-collection))
(define-public (update-ipfs-root (new-root (string-ascii 80))))
```

## Development

### Local Development
```bash
# Start local development chain
clarinet integrate

# Run tests
clarinet test

# Check contract
clarinet check
```

### Testing Environment
```bash
# Run specific test
clarinet test tests/dynamic-nft_test.ts

# Run all tests
clarinet test
```

## Testing

### Test Suite Coverage
- Minting functionality
- Evolution mechanics
- Authentication systems
- Bitcoin network interaction
- Error handling scenarios
- Metadata updates
- Admin functions

### Running Tests
```bash
# Full test suite
clarinet test

# Individual test files
clarinet test tests/dynamic-nft_test.ts
```

## Deployment

### Testnet Deployment
```bash
# Deploy contract
clarinet deploy --testnet

# Verify deployment
stx call get-last-token-id
```

### Mainnet Deployment
```bash
# Deploy contract
clarinet deploy --mainnet

# Activate collection
stx call activate-collection
```

## Security

### Security Features
- Owner authentication
- Evolution cooldown periods
- Stage progression validation
- Bitcoin block verification
- Rate limiting
- Access control

### Best Practices
1. Always verify transaction status
2. Monitor evolution conditions
3. Validate Bitcoin block data
4. Check authentication status
5. Implement proper error handling

## Contributing

### Development Process
1. Fork repository
2. Create feature branch
3. Implement changes
4. Add tests
5. Submit pull request

### Code Style
- Follow Clarity style guide
- Maintain test coverage
- Document changes
- Update README if needed

## License

MIT License - See LICENSE file for details

---

## FAQ

### Q: How do NFTs evolve?
A: NFTs evolve based on Bitcoin network events, requiring minimum block confirmations and meeting specific network conditions.

### Q: What triggers evolution?
A: Evolution is triggered by:
- Bitcoin block confirmations (144 minimum)
- Network difficulty changes
- Transaction volume thresholds

### Q: How to track NFT status?
A: Use `get-token-stage` and `get-token-uri` functions to monitor NFT status and metadata.

---

## Support

For support and questions:
- Create GitHub issue
- Join Discord community
- Check documentation