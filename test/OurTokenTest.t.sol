//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    uint256 STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        // the owner is the deployer of the contract
        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowancesByMeAndPatrick() public {
        uint256 initialAllowance = 1000;
        uint256 transferAmount = 500;
        // Bob approves Alice to transfer tokens on his behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
        //ourToken.transferFrom(alice, transferAmount);

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    // function testAllowancesByPhind() public {
    //     //uint256 initialBalance = ourToken.balanceOf(address(this)); unused local variable
    //     uint256 amountToApprove = 100;
    //     ourToken.approve(address(deployer), amountToApprove);
    //     assertEq(ourToken.allowance(address(this), address(deployer)), amountToApprove);
    //     ourToken.approve(address(deployer), 0);
    //     assertEq(ourToken.allowance(address(this), address(deployer)), 0);
    // }

    function testTransfer() public {
        /**
         * made by Phind test failed *********, adjusted
         */
        uint256 amount = 1000;
        address receiver = address(0x1);
        vm.prank(msg.sender);
        ourToken.transfer(receiver, amount);
        assertEq(ourToken.balanceOf(receiver), amount);
    }

    function testTransferFrom() public {
        uint256 amount = 100;
        address receiver = address(0x1);
        vm.prank(msg.sender);
        ourToken.approve(address(this), amount);
        ourToken.transferFrom((msg.sender), receiver, amount);
        assertEq(ourToken.balanceOf(receiver), amount);
    }

    function testBalanceAfterTransfer() public {
        uint256 amount = 100;
        address receiver = address(0x1);
        uint256 initialBalance = ourToken.balanceOf(msg.sender);
        vm.prank(msg.sender);
        ourToken.transfer(receiver, amount);
        assertEq(ourToken.balanceOf(msg.sender), initialBalance - amount);
    }

    function testFailingTransferFrom() public {
        uint256 amountToApprove = 100;
        ourToken.approve(address(deployer), amountToApprove);
        vm.expectRevert("ERC20: transfer amount exceeds allowance");
        ourToken.transferFrom(address(this), address(deployer), amountToApprove + 1);
    }
}
