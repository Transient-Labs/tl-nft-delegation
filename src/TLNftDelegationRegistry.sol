// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Ownable} from "openzeppelin/access/Ownable.sol";
import {Pausable} from "openzeppelin/utils/Pausable.sol";
import {IDelegateRegistry} from "src/interfaces/IDelegateRegistry.sol";
import {ITLNftDelegationRegistry} from "src/ITLNftDelegationRegistry.sol";

/// @title TLNftDelegationRegistry.sol
/// @notice Transient Labs NFT Delegation Registry, providing a universal interface for TL contracts to check NFT delegation and use it for features like Story Inscriptions, Synergy, Multi-Metadata and more.
/// @dev This registry is not intended to be used in core ownership functions defined by ERC-721 and ERC-1155.
/// @author transientlabs.xyz
/// @custom:version 1.0.0
contract TLNftDelegationRegistry is Ownable, Pausable, ITLNftDelegationRegistry {
    /*//////////////////////////////////////////////////////////////////////////
                                State Variables
    //////////////////////////////////////////////////////////////////////////*/

    IDelegateRegistry public immutable delegateRegistry;

    /*//////////////////////////////////////////////////////////////////////////
                               Constructor
    //////////////////////////////////////////////////////////////////////////*/

    constructor(address initOwner, address delegateRegistry_) Ownable(initOwner) {
        delegateRegistry = IDelegateRegistry(delegateRegistry_);
    }

    /*//////////////////////////////////////////////////////////////////////////
                            ITLNftDelegationRegistry
    //////////////////////////////////////////////////////////////////////////*/

    /// @inheritdoc ITLNftDelegationRegistry
    function checkDelegateForERC721(address delegate, address vault, address nftContract, uint256 tokenId)
        external
        view
        returns (bool)
    {
        if (paused()) {
            return false;
        } else {
            try delegateRegistry.checkDelegateForERC721(delegate, vault, nftContract, tokenId, 0) returns (
                bool isDelegated
            ) {
                return isDelegated;
            } catch {
                return false;
            }
        }
    }

    /// @inheritdoc ITLNftDelegationRegistry
    function checkDelegateForERC1155(address delegate, address vault, address nftContract, uint256 tokenId)
        external
        view
        returns (bool)
    {
        if (paused()) {
            return false;
        } else {
            try delegateRegistry.checkDelegateForERC1155(delegate, vault, nftContract, tokenId, 0) returns (
                uint256 delegatedBalance
            ) {
                bool isDelegated = delegatedBalance > 0 ? true : false;
                return isDelegated;
            } catch {
                return false;
            }
        }
    }

    /*//////////////////////////////////////////////////////////////////////////
                               Owner Functions
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Function to pause the contract (always return false)
    /// @dev Only callable by the owner
    /// @param status A boolean indicating to pause or unpause the contract
    function setPaused(bool status) external onlyOwner {
        status ? _pause() : _unpause();
    }
}
