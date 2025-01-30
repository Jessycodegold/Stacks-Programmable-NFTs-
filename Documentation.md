# Evolution System Documentation

## Overview

The NFT evolution system responds to Bitcoin network events through a multi-stage progression mechanism. Each evolution stage represents a unique state of the NFT, with corresponding metadata and visual attributes.

## Evolution Stages

### Stage 1: Genesis
- Initial minting state
- Base attributes established
- Bitcoin block height recorded

### Stage 2: Activated
Requirements:
- 144 Bitcoin blocks confirmed
- Initial network difficulty recorded
- First transaction count snapshot

### Stage 3: Evolved
Requirements:
- 288 Bitcoin blocks confirmed
- Network difficulty increase verified
- Transaction count threshold met

### Stage 4: Ascended
Requirements:
- 576 Bitcoin blocks confirmed
- Multiple difficulty changes recorded
- High transaction volume achieved

## Evolution Mechanics

### Trigger Conditions
```clarity
(define-private (can-evolve? (token-id uint))
    (let (
        (stage-data (unwrap! (map-get? token-stage {token-id: token-id}) false))
        (blocks-passed (- block-height (get last-evolution stage-data)))
    )
    (and
        (>= blocks-passed u144)
        (is-btc-block-valid?)
    ))
)
```

### State Transitions
1. Check evolution eligibility
2. Verify Bitcoin network conditions
3. Update token stage
4. Modify metadata
5. Emit evolution event

### Metadata Updates
Each evolution updates:
- Current stage
- Blocks passed
- Network difficulty
- Transaction count

## Implementation Guide

### Triggering Evolution
```clarity
(define-public (evolve-nft (token-id uint))
```

### Checking Status
```clarity
(define-read-only (get-token-stage (token-id uint))
```

### Monitoring Progress
```clarity
(define-read-only (get-token-uri (token-id uint))
```