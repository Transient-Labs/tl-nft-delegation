# Transient Labs NFT Delegation Registry
An immutable delegation registry that provides a common interface for Transient Labs creator contracts to check nft ownership delegation.

## Problem Statement
NFT security is one of the biggest concerns in our space. As such, most people keep their NFTs in wallets/vaults that they don't connect to any dApps. This can either be in the form of a hardware wallet or a mutli-sig smart contract wallet. If someone ones to sell an NFT, they just simply transfer the NFT to a selling wallet that they can connect to marketplaces. 

Transient Labs contracts have features that are unique and provide more utlity to NFT owners. To start, we initially required the NFT owner to send the transaction to either add a story inscription, accept a metadata update, or something else. Looking towards the future, with NFT security in mind, we want to create a universal interface for Transient Labs contracts to check NFT ownership delegations.

## Solution
NFT delegation is not new. [delegate.xyz](https://delegate.xyz) has done a good job of bringing NFT delegation to the market and many projects are integrating with it for allowlisting, airdrops, etc. There are also other products coming to the market outside of delegate.xyz. For example, Punk 6529 and his team have created their own delegation registry, [NFTDelegation](https://docs.nftdelegation.com/), that allows for more fine-grained control. This registry is used for all memecard drops from 6529.

The purpose of this NFT Delegation Registry is not to sping up our own version, but rather to provide a universal interface that our contracts can call, without having to worry about what delegation solutions are being checked under the hood. We think that there will be many delegation solutions in the future and want to support them all.

To start, the Transient Labs NFT Delegation Registry just checks [delegate.xyz v2](https://docs.delegate.xyz/delegate/upgrade-to-v2/v2-is-a-separate-contract). We considered supporting NFTDelegation, however, we have several questions and concerns and are in discussion with that team to address prior to integrating into this project.

### Immutable by Design
The registry we create follows a specific interface `src/ITlNftDelegationRegistry.sol`. However, we are not making the implementation upgradeable and rather will build our creator contracts to be able to migrate registries in the future.

## How This Registry Should Be Used
This registry MUST NEVER be used for any on-chain functionality that affects NFT ownership. As an example, delegates MUST NOT be able transfer or sell tokens on behalf of the token owner. ERC-721 and ERC-1155 already have mechanisms in place to handle this. Future token standards will also have those provisions in place.

## Disclaimer
This codebase is provided on an "as is" and "as available" basis.

We do not give any warranties and will not be liable for any loss incurred through any use of this codebase.

## License
This code is copyright Transient Labs, Inc 2023 and is licensed under the MIT license.