;; Dynamic Bitcoin-Reactive NFT
;; This NFT evolves based on Bitcoin network events

(use-trait sip-009 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u101))
(define-constant ERR-NOT-FOUND (err u102))
(define-constant ERR-ALREADY-LISTED (err u103))
(define-constant ERR-WRONG-STAGE (err u104))

;; Data variables
(define-data-var last-token-id uint u0)
(define-data-var ipfs-root (string-ascii 80) "ipfs://QmYourBaseURI/")
(define-data-var btc-height uint u0)
(define-data-var collection-activated bool false)

;; NFT Evolution stages
(define-map token-stage {token-id: uint} {stage: uint, last-evolution: uint})
(define-map token-metadata 
    {token-id: uint} 
    {
        base-uri: (string-ascii 80),
        btc-blocks: uint,
        difficulty: uint,
        transaction-count: uint
    }
)
;; SIP-009 NFT Implementation
(define-non-fungible-token bitcoin-reactive-nft uint)

;; Read-only functions
(define-read-only (get-last-token-id)
    (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
    (let (
        (token-data (unwrap! (map-get? token-metadata {token-id: token-id}) (err u404)))
        (stage-data (unwrap! (map-get? token-stage {token-id: token-id}) (err u404)))
    )
    (ok (some (concat 
        (get base-uri token-data) 
        (concat 
            (uint-to-ascii token-id)
            (concat "-" (uint-to-ascii (get stage stage-data)))
        )
    )))
    )
)

(define-read-only (get-token-stage (token-id uint))
    (map-get? token-stage {token-id: token-id})
)

;; Minting
(define-public (mint)
    (let (
        (token-id (+ (var-get last-token-id) u1))
    )
    (asserts! (var-get collection-activated) ERR-WRONG-STAGE)
    
    ;; Mint token
    (try! (nft-mint? bitcoin-reactive-nft token-id tx-sender))
    
    ;; Initialize metadata
    (map-set token-metadata
        {token-id: token-id}
        {
            base-uri: (var-get ipfs-root),
            btc-blocks: block-height,
            difficulty: default-btc-difficulty,
            transaction-count: u0
        }
    )
    
    ;; Set initial stage
    (map-set token-stage
        {token-id: token-id}
        {stage: u1, last-evolution: block-height}
    )
       ;; Update last token id
    (var-set last-token-id token-id)
    (ok token-id)
    )
)

;; Evolution mechanics
(define-public (evolve-nft (token-id uint))
    (let (
        (owner (unwrap! (nft-get-owner? bitcoin-reactive-nft token-id) ERR-NOT-FOUND))
        (current-stage (unwrap! (map-get? token-stage {token-id: token-id}) ERR-NOT-FOUND))
        (metadata (unwrap! (map-get? token-metadata {token-id: token-id}) ERR-NOT-FOUND))
    )
    
    ;; Check ownership
    (asserts! (is-eq tx-sender owner) ERR-NOT-AUTHORIZED)
    
    ;; Check evolution conditions based on Bitcoin block data
    (asserts! (can-evolve? token-id) ERR-WRONG-STAGE)
    
    ;; Update stage
    (map-set token-stage
        {token-id: token-id}
        {
            stage: (+ (get stage current-stage) u1),
            last-evolution: block-height
        }
    )
    ;; Update metadata with new Bitcoin state
    (map-set token-metadata
        {token-id: token-id}
        {
            base-uri: (get base-uri metadata),
            btc-blocks: (- block-height (get btc-blocks metadata)),
            difficulty: (get-btc-difficulty),
            transaction-count: (+ (get transaction-count metadata) u1)
        }
    )
    
    (ok true)
    )
)

;; Bitcoin network interaction helpers
(define-private (can-evolve? (token-id uint))
    (let (
        (stage-data (unwrap! (map-get? token-stage {token-id: token-id}) false))
        (blocks-passed (- block-height (get last-evolution stage-data)))
    )
    (and
        (>= blocks-passed u144) ;; Require minimum 1 day of Bitcoin blocks
        (is-btc-block-valid?)
    ))
)

(define-private (is-btc-block-valid?)
    (get-block-info? was-btc-block-processed? (- block-height u1))
)

(define-private (get-btc-difficulty)
    (default-to u1 (get-block-info? btc-difficulty (- block-height u1)))
)

;; Admin functions
(define-public (activate-collection)
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (var-set collection-activated true)
        (ok true)
    )
)

(define-public (update-ipfs-root (new-root (string-ascii 80)))
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (var-set ipfs-root new-root)
        (ok true)
    )
)