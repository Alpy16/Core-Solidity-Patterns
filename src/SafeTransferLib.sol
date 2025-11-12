//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);
}

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
}
