// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.30;

import { Test } from "forge-std/Test.sol";

import { DAO } from "../src/DAO.sol";

contract DAOTest is Test {
    uint256 constant CROWDSALE_BLOCK_NUMBER = 1_599_200;
    uint256 internal daoInitialBalance = 11_725_826.068_359_058_772_488_243 ether;

    function setUp() public virtual {
        vm.createSelectFork(vm.envString("MAINNET_RPC_URL"), CROWDSALE_BLOCK_NUMBER);
    }

    function test_initialState() external view {
        vm.assertEq(address(DAO).balance, daoInitialBalance);
    }

    address constant BITTREX = 0xFBb1b73C4f0BDa4f67dcA266ce6Ef42f520fBB98;

    function test_balanceOf() external view {
        vm.assertEq(DAO.balanceOf(BITTREX), 9.99 ether);
    }
}

contract DAOAttacker {
    uint256 private proposalId;

    function buyTokens() external payable {
        (bool ok,) = address(DAO).call{ value: msg.value }("");
        require(ok, "Could not buy. Is it in Crowdsale?");
    }

    function createProposal(string calldata description, uint256 debatingPeriod) external {
        require(proposalId == 0, "Another proposal was already made");
        proposalId = DAO.newProposal(address(this), 0, description, "", debatingPeriod, true);
    }

    function vote(bool supportProposal) external returns (uint256 voteId) {
        require(proposalId != 0, "No proposal set");
        return DAO.vote(proposalId, supportProposal);
    }
}

contract DAOAttackTest is DAOTest {
    DAOAttacker private attacker;

    uint256 constant BOUGHT_ETHER = 0.9 ether;
    uint256 constant INITIAL_BALANCE = 0.6 ether;

    function setUp() public override {
        super.setUp();
        attacker = new DAOAttacker();

        attacker.buyTokens{ value: BOUGHT_ETHER }();
        daoInitialBalance += 2 * BOUGHT_ETHER / 3;

        // skip to after crowdsale
        vm.warp(block.timestamp + 1 days);
    }

    function test_attackerIsHolder() external view {
        vm.assertEq(DAO.balanceOf(address(attacker)), INITIAL_BALANCE);
    }

    function test_canCreateProposal() external {
        attacker.createProposal("A very non-sketchy proposal", 10 days);
        attacker.vote(false);
    }
}
