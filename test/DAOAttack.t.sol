// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import { DAOAttack } from "../src/DAOAttack.sol";
import { Test } from "forge-std/Test.sol";

contract DAOAttackTest is Test {
    DAOAttack public counter;

    function setUp() public {
        counter = new DAOAttack();
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
