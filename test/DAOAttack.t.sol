// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.30;

import { Test } from "forge-std/Test.sol";

import { DAOAttack } from "../src/DAOAttack.sol";

contract DAOAttackTest is Test {
    DAOAttack public attack = new DAOAttack();

    uint256 immutable MAINNET_FORK = vm.createFork(vm.envString("MAINNET_RPC_URL"));
    uint256 constant BLOCK_NUMBER = 1_599_200;

    function setUp() public {
        vm.selectFork(MAINNET_FORK);
        vm.rollFork(MAINNET_FORK, BLOCK_NUMBER);
    }
}
