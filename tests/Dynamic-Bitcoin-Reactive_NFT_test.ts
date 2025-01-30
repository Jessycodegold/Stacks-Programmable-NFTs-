import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "Ensures NFT minting works correctly after collection activation",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get('deployer')!;
        const wallet1 = accounts.get('wallet_1')!;
        
        // Activate collection
        let block = chain.mineBlock([
            Tx.contractCall('dynamic-nft', 'activate-collection', [], deployer.address)
        ]);
        assertEquals(block.receipts[0].result, '(ok true)');
        
        // Mint NFT
        block = chain.mineBlock([
            Tx.contractCall('dynamic-nft', 'mint', [], wallet1.address)
        ]);
        assertEquals(block.receipts[0].result, '(ok u1)');
        
        // Verify token URI
        block = chain.mineBlock([
            Tx.contractCall('dynamic-nft', 'get-token-uri', [types.uint(1)], wallet1.address)
        ]);
        assertEquals(block.receipts[0].result.includes('ipfs://'), true);
    }
});