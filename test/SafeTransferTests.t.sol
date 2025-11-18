// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/SafeTransferLib.sol";
import "test/MockERC20.sol";
import "src/interfaces/IERC20.sol";

contract ETHReceiver {
    event Received(uint256 amount);

    receive() external payable {
        emit Received(msg.value);
    }
}

contract SafeTransferTests is Test {
    MockERC20 token;
    ETHReceiver receiver;

    address user = address(0xBEEF);

    function setUp() public {
        token = new MockERC20("Mock Token", "MTK", 18);
        receiver = new ETHReceiver();

        token.mint(address(this), 1000 ether);
        vm.deal(address(this), 10 ether);
    }

    function testSafeTransferETH() public {
        uint256 initialBalance = address(receiver).balance;
        SafeTransferLib.safeTransferETH(address(receiver), 1 ether);
        assertEq(address(receiver).balance, initialBalance + 1 ether);
    }

    function testSafeTransferERC20() public {
        uint256 initialBalance = token.balanceOf(address(receiver));
        SafeTransferLib.safeTransfer(token, address(receiver), 100 ether);
        assertEq(
            token.balanceOf(address(receiver)),
            initialBalance + 100 ether
        );
    }
}
