// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.30;

import { Test } from "forge-std/Test.sol";

import { DAO } from "../src/DAO.sol";

contract DAOAttackTest is Test {
    uint256 constant BLOCK_NUMBER = 1_598_000;
    uint256 constant INITIAL_BALANCE = 11_665_078.365_239_790_310_821_263 ether;

    function setUp() public {
        vm.createSelectFork(vm.envString("MAINNET_RPC_URL"), BLOCK_NUMBER);
    }

    function test_initialState() external view {
        vm.assertEq(address(DAO).balance, INITIAL_BALANCE);
    }

    address constant BITTREX = 0xFBb1b73C4f0BDa4f67dcA266ce6Ef42f520fBB98;

    function test_balanceOf() external pure {
        vm.assertEq(DAO.balanceOf(BITTREX), 9.99 ether);
    }
}
