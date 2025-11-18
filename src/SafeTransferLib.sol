//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IERC20.sol";

library SafeTransferLib {
    error EthTransferFailed();
    error ERC20TransferFailed();
    error ERC20ApproveFailed();

    function safeTransferETH(address to, uint256 amount) internal {
        (bool success, ) = to.call{value: amount}("");
        if (!success) revert EthTransferFailed();
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 amount
    ) internal {
        bool success = token.transferFrom(from, to, amount);
        if (!success) revert ERC20TransferFailed();
        //these only work for erc20 that return a bool
    }

    function safeTransfer(IERC20 token, address to, uint256 amount) internal {
        bool success = token.transfer(to, amount);
        if (!success) revert ERC20TransferFailed();
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 amount
    ) internal {
        bool success = token.approve(spender, amount);
        if (!success) revert ERC20ApproveFailed();
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 amount
    ) internal {
        uint256 currentAllowance = token.allowance(address(this), spender);
        bool success = token.approve(spender, currentAllowance + amount);
        if (!success) revert ERC20ApproveFailed();
    }

    function sqrt(uint256 x) internal pure returns (uint256 z) {
        if (x == 0) return 0;

        // Initial guess: 2^(log2(x) / 2)
        z = 1 << (log2(x) >> 1);

        // Newton iterations – 7 is enough for full 256-bit convergence
        for (uint256 i = 0; i < 7; i++) {
            z = (z + x / z) >> 1;
        }
    }

    function log2(uint256 x) internal pure returns (uint256 y) {
        //just a helper function for sqrt
        while (x > 1) {
            x >>= 1;
            y++;
        }
    }
}
