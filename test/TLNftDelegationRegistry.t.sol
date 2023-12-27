// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "forge-std/Test.sol";
import {TLNftDelegationRegistry, IDelegateRegistry} from "src/TLNftDelegationRegistry.sol";

contract TLNftDelegationRegistryTest is Test {
    TLNftDelegationRegistry public dr;
    address public constant DELEGATE_REGISTRY = 0x00000000000000447e69651d841bD8D104Bed493;
    address public constant CDB_CONTRACT = 0x42069ABFE407C60cf4ae4112bEDEaD391dBa1cdB;
    uint256 public forkId;

    address public ben = makeAddr("gm from a real place");
    address public benDelegate = makeAddr("i need coffee");
    address public bsy = makeAddr("boomer");
    address public bsyDelegate = makeAddr("1d=1b");

    function setUp() public {
        dr = new TLNftDelegationRegistry(address(this), DELEGATE_REGISTRY);
        forkId = vm.createFork(vm.envString("ETH_RPC_URL"));
    }

    function setUpFork() public {
        // select fork
        vm.selectFork(forkId);

        // deploy contract to fork
        dr = new TLNftDelegationRegistry(address(this), DELEGATE_REGISTRY);
    }

    /// @dev test check ERC721, not paused, return false
    function test_fuzz_checkDelegateForERC721_notPaused_returnsFalse(
        address delegate,
        address vault,
        address nftContract,
        uint256 tokenId
    ) public {
        // mock call to delegate registry to return false
        vm.mockCall(
            DELEGATE_REGISTRY,
            abi.encodeWithSelector(IDelegateRegistry.checkDelegateForERC721.selector),
            abi.encode(false)
        );

        // ensure response is false
        assertFalse(dr.checkDelegateForERC721(delegate, vault, nftContract, tokenId));

        // clear mocked calls
        vm.clearMockedCalls();
    }

    /// @dev test check ERC721, not paused, returns true
    function test_fuzz_checkDelegateForERC721_notPaused_returnsTrue(
        address delegate,
        address vault,
        address nftContract,
        uint256 tokenId
    ) public {
        // mock call to delegate registry to return true
        vm.mockCall(
            DELEGATE_REGISTRY,
            abi.encodeWithSelector(IDelegateRegistry.checkDelegateForERC721.selector),
            abi.encode(true)
        );

        // ensure response is true
        assertTrue(dr.checkDelegateForERC721(delegate, vault, nftContract, tokenId));

        // clear mocked calls
        vm.clearMockedCalls();
    }

    /// @dev test check ERC721, paused, returns false
    function test_fuzz_checkDelegateForERC721_paused_returnsFalse(
        address delegate,
        address vault,
        address nftContract,
        uint256 tokenId
    ) public {
        // pause delegation registry
        dr.setPaused(true);

        // mock call to delegate registry to return false, returns false
        vm.mockCall(
            DELEGATE_REGISTRY,
            abi.encodeWithSelector(IDelegateRegistry.checkDelegateForERC721.selector),
            abi.encode(false)
        );

        // ensure response is false
        assertFalse(dr.checkDelegateForERC721(delegate, vault, nftContract, tokenId));

        // clear mocked calls
        vm.clearMockedCalls();

        // mock call to delegate registry to return true
        vm.mockCall(
            DELEGATE_REGISTRY,
            abi.encodeWithSelector(IDelegateRegistry.checkDelegateForERC721.selector),
            abi.encode(true)
        );

        // ensure response is false
        assertFalse(dr.checkDelegateForERC721(delegate, vault, nftContract, tokenId));

        // clear mocked calls
        vm.clearMockedCalls();
    }

    /// @dev test check ERC721, delegate set to EOA, reverts
    function test_fuzz_checkDelegateForERC721_delegateEOA_reverts(
        address delegate,
        address vault,
        address nftContract,
        uint256 tokenId
    ) public {
        // deploy new delegation registry with EOA as delegate registry
        dr = new TLNftDelegationRegistry(address(this), ben);

        // ensure response reverts
        vm.expectRevert();
        dr.checkDelegateForERC721(delegate, vault, nftContract, tokenId);
    }

    /// @dev test check ERC721, delegate registry reverts, returns false
    function test_fuzz_checkDelegateForERC721_delegateRegistryReverts_returnsFalse(
        address delegate,
        address vault,
        address nftContract,
        uint256 tokenId
    ) public {
        // mock call to delegate registry to return false, returns false
        vm.mockCallRevert(
            DELEGATE_REGISTRY,
            abi.encodeWithSelector(IDelegateRegistry.checkDelegateForERC721.selector),
            abi.encode("REVERT")
        );

        // ensure response is false
        assertFalse(dr.checkDelegateForERC721(delegate, vault, nftContract, tokenId));

        // clear mocked calls
        vm.clearMockedCalls();
    }

    /// @dev test check ERC1155, not paused, returns false
    function test_fuzz_checkDelegateForERC1155_notPaused_returnsFalse(
        address delegate,
        address vault,
        address nftContract,
        uint256 tokenId
    ) public {
        // mock call to delegate registry to return 0
        vm.mockCall(
            DELEGATE_REGISTRY, abi.encodeWithSelector(IDelegateRegistry.checkDelegateForERC1155.selector), abi.encode(0)
        );

        // ensure response is false
        assertFalse(dr.checkDelegateForERC1155(delegate, vault, nftContract, tokenId));

        // clear mocked calls
        vm.clearMockedCalls();
    }

    /// @dev test check ERC1155, not paused, returns true
    function test_fuzz_checkDelegateForERC1155_notPaused_returnsTrue(
        address delegate,
        address vault,
        address nftContract,
        uint256 tokenId
    ) public {
        // mock call to delegate registry to return 1
        vm.mockCall(
            DELEGATE_REGISTRY, abi.encodeWithSelector(IDelegateRegistry.checkDelegateForERC1155.selector), abi.encode(1)
        );

        // ensure response is true
        assertTrue(dr.checkDelegateForERC1155(delegate, vault, nftContract, tokenId));

        // clear mocked calls
        vm.clearMockedCalls();
    }

    /// @dev test check ERC1155, paused, returns false
    function test_fuzz_checkDelegateForERC1155_paused_returnsFalse(
        address delegate,
        address vault,
        address nftContract,
        uint256 tokenId
    ) public {
        // pause
        dr.setPaused(true);

        // mock call to delegate registry to return 0
        vm.mockCall(
            DELEGATE_REGISTRY, abi.encodeWithSelector(IDelegateRegistry.checkDelegateForERC1155.selector), abi.encode(0)
        );

        // ensure response is false
        assertFalse(dr.checkDelegateForERC1155(delegate, vault, nftContract, tokenId));

        // clear mocked calls
        vm.clearMockedCalls();

        // mock call to delegate registry to return 1
        vm.mockCall(
            DELEGATE_REGISTRY, abi.encodeWithSelector(IDelegateRegistry.checkDelegateForERC1155.selector), abi.encode(1)
        );

        // ensure response is false
        assertFalse(dr.checkDelegateForERC1155(delegate, vault, nftContract, tokenId));

        // clear mocked calls
        vm.clearMockedCalls();
    }

    /// @dev test check ERC1155, delegate set to EOA
    function test_fuzz_checkDelegateForERC1155_delegateEOA_reverts(
        address delegate,
        address vault,
        address nftContract,
        uint256 tokenId
    ) public {
        // deploy new delegation registry with EOA as delegate registry
        dr = new TLNftDelegationRegistry(address(this), ben);

        // ensure response reverts
        vm.expectRevert();
        dr.checkDelegateForERC1155(delegate, vault, nftContract, tokenId);
    }

    /// @dev test check ERC1155, delegate reverts
    function test_fuzz_checkDelegateForERC1155_delegateRegistryReverts_returnsFalse(
        address delegate,
        address vault,
        address nftContract,
        uint256 tokenId
    ) public {
        // mock call to delegate registry to return false, returns false
        vm.mockCallRevert(
            DELEGATE_REGISTRY,
            abi.encodeWithSelector(IDelegateRegistry.checkDelegateForERC1155.selector),
            abi.encode("REVERT")
        );

        // ensure response is false
        assertFalse(dr.checkDelegateForERC1155(delegate, vault, nftContract, tokenId));

        // clear mocked calls
        vm.clearMockedCalls();
    }

    /// @dev test check ERC721, fork test, returns false
    function test_fork_checkDelegateForERC721_notPaused_returnsFalse() public {
        // setup fork
        setUpFork();

        // check for ben's delegate
        assertFalse(dr.checkDelegateForERC721(benDelegate, ben, CDB_CONTRACT, 420));

        // // check for bsy's delegate
        assertFalse(dr.checkDelegateForERC721(bsyDelegate, bsy, CDB_CONTRACT, 4200));
    }

    /// @dev test check ERC721, fork test, returns true, delegated token
    function test_fork_checkDelegateForERC721_notPaused_returnsTrue_delegatedToken() public {
        // setup fork
        setUpFork();

        // have ben and bsy set delegates for tokens
        vm.prank(ben);
        IDelegateRegistry(DELEGATE_REGISTRY).delegateERC721(benDelegate, CDB_CONTRACT, 420, bytes32(0), true);
        vm.prank(bsy);
        IDelegateRegistry(DELEGATE_REGISTRY).delegateERC721(bsyDelegate, CDB_CONTRACT, 4200, bytes32(0), true);

        // check for ben's delegate
        assertTrue(dr.checkDelegateForERC721(benDelegate, ben, CDB_CONTRACT, 420));

        // // check for bsy's delegate
        assertTrue(dr.checkDelegateForERC721(bsyDelegate, bsy, CDB_CONTRACT, 4200));
    }

    /// @dev test check ERC721, fork test, returns true, delegated contract
    function test_fork_checkDelegateForERC721_notPaused_returnsTrue_delegatedContract() public {
        // setup fork
        setUpFork();

        // have ben and bsy set delegates for contract
        vm.prank(ben);
        IDelegateRegistry(DELEGATE_REGISTRY).delegateContract(benDelegate, CDB_CONTRACT, bytes32(0), true);
        vm.prank(bsy);
        IDelegateRegistry(DELEGATE_REGISTRY).delegateContract(bsyDelegate, CDB_CONTRACT, bytes32(0), true);

        // check for ben's delegate
        assertTrue(dr.checkDelegateForERC721(benDelegate, ben, CDB_CONTRACT, 420));

        // // check for bsy's delegate
        assertTrue(dr.checkDelegateForERC721(bsyDelegate, bsy, CDB_CONTRACT, 4200));
    }

    /// @dev test check ERC721, fork test, returns true, delegated all
    function test_fork_checkDelegateForERC721_notPaused_returnsTrue_delegatedAll() public {
        // setup fork
        setUpFork();

        // have ben and bsy set delegates for all
        vm.prank(ben);
        IDelegateRegistry(DELEGATE_REGISTRY).delegateAll(benDelegate, bytes32(0), true);
        vm.prank(bsy);
        IDelegateRegistry(DELEGATE_REGISTRY).delegateAll(bsyDelegate, bytes32(0), true);

        // check for ben's delegate
        assertTrue(dr.checkDelegateForERC721(benDelegate, ben, CDB_CONTRACT, 420));

        // // check for bsy's delegate
        assertTrue(dr.checkDelegateForERC721(bsyDelegate, bsy, CDB_CONTRACT, 4200));
    }

    /// @dev test check ERC1155, fork test, returns false
    function test_fork_checkDelegateForERC1155_notPaused_returnsFalse() public {
        // setup fork
        setUpFork();

        // check for ben's delegate
        assertFalse(dr.checkDelegateForERC1155(benDelegate, ben, CDB_CONTRACT, 420));

        // // check for bsy's delegate
        assertFalse(dr.checkDelegateForERC1155(bsyDelegate, bsy, CDB_CONTRACT, 4200));
    }

    /// @dev test check ERC1155, fork test, returns true, delegated token
    function test_fork_checkDelegateForERC1155_notPaused_returnsTrue_delegatedToken() public {
        // setup fork
        setUpFork();

        // have ben and bsy set delegates for tokens
        vm.prank(ben);
        IDelegateRegistry(DELEGATE_REGISTRY).delegateERC1155(benDelegate, CDB_CONTRACT, 420, bytes32(0), 42);
        vm.prank(bsy);
        IDelegateRegistry(DELEGATE_REGISTRY).delegateERC1155(bsyDelegate, CDB_CONTRACT, 4200, bytes32(0), 42);

        // check for ben's delegate
        assertTrue(dr.checkDelegateForERC1155(benDelegate, ben, CDB_CONTRACT, 420));

        // // check for bsy's delegate
        assertTrue(dr.checkDelegateForERC1155(bsyDelegate, bsy, CDB_CONTRACT, 4200));
    }

    /// @dev test check ERC1155, fork test, returns true, delegated contract
    function test_fork_checkDelegateForERC1155_notPaused_returnsTrue_delegatedContract() public {
        // setup fork
        setUpFork();

        // have ben and bsy set delegates for contract
        vm.prank(ben);
        IDelegateRegistry(DELEGATE_REGISTRY).delegateContract(benDelegate, CDB_CONTRACT, bytes32(0), true);
        vm.prank(bsy);
        IDelegateRegistry(DELEGATE_REGISTRY).delegateContract(bsyDelegate, CDB_CONTRACT, bytes32(0), true);

        // check for ben's delegate
        assertTrue(dr.checkDelegateForERC1155(benDelegate, ben, CDB_CONTRACT, 420));

        // // check for bsy's delegate
        assertTrue(dr.checkDelegateForERC1155(bsyDelegate, bsy, CDB_CONTRACT, 4200));
    }

    /// @dev test check ERC1155, fork test, returns true, delegated all
    function test_fork_checkDelegateForERC1155_notPaused_returnsTrue_delegatedAll() public {
        // setup fork
        setUpFork();

        // have ben and bsy set delegates for all
        vm.prank(ben);
        IDelegateRegistry(DELEGATE_REGISTRY).delegateAll(benDelegate, bytes32(0), true);
        vm.prank(bsy);
        IDelegateRegistry(DELEGATE_REGISTRY).delegateAll(bsyDelegate, bytes32(0), true);

        // check for ben's delegate
        assertTrue(dr.checkDelegateForERC1155(benDelegate, ben, CDB_CONTRACT, 420));

        // // check for bsy's delegate
        assertTrue(dr.checkDelegateForERC1155(bsyDelegate, bsy, CDB_CONTRACT, 4200));
    }
}
