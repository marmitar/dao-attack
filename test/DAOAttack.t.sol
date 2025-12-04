// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.30;

import { Test } from "forge-std/Test.sol";

import { DAO } from "../src/DAO.sol";

contract DAOAttackTest is Test {
    uint256 immutable MAINNET_FORK = vm.createFork(vm.envString("MAINNET_RPC_URL"));
    uint256 constant BLOCK_NUMBER = 1_599_200;

    function setUp() public {
        vm.selectFork(MAINNET_FORK);
        vm.rollFork(MAINNET_FORK, BLOCK_NUMBER);
    }

    address constant BITTREX = 0xFBb1b73C4f0BDa4f67dcA266ce6Ef42f520fBB98;

    function test_balanceOf() external pure {
        vm.assertEq(DAO.balanceOf(BITTREX), 9.99 ether);
    }
}
