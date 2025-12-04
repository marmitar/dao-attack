// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.30;

import { Test } from "forge-std/Test.sol";

import { DAO } from "../src/DAO.sol";

contract DAOTest is Test {
    uint256 constant CROWDSALE_BLOCK_NUMBER = 1_599_200;
    uint256 constant DAO_INITIAL_BALANCE = 11_725_826.068_359_058_772_488_243 ether;

    function setUp() public virtual {
        vm.createSelectFork(vm.envString("MAINNET_RPC_URL"), CROWDSALE_BLOCK_NUMBER);
    }

    function test_initialState() external view {
        vm.assertEq(address(DAO).balance, DAO_INITIAL_BALANCE);
    }

    address constant BITTREX = 0xFBb1b73C4f0BDa4f67dcA266ce6Ef42f520fBB98;

    function test_balanceOf() external view {
        vm.assertEq(DAO.balanceOf(BITTREX), 9.99 ether);
    }
}

contract DAOAttackTest is DAOTest {
    address immutable ATTACKER = makeAddr("attacker");

    function setUp() public override {
        super.setUp();

        gainTrust();
    }

    function gainTrust() private {
        uint256 donorBalance = DAO.balanceOf(BITTREX);
        require(donorBalance > 0, "Donor must be a Token Holder");
        require(donorBalance >= 1 ether, "Our attacker is picky");

        vm.prank(BITTREX);
        bool success = DAO.transfer(ATTACKER, 1 ether);
        require(success, "Donation failed");
    }

    function test_attackerIsHolder() external view {
        vm.assertEq(DAO.balanceOf(ATTACKER), 1 ether);
    }
}
