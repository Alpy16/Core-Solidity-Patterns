//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library CallHelpers {
    error CallFailed(string reason);
    error CallReverted(bytes returnData);
    error StaticCallReverted(bytes returnData);
    error DelegateCallFailed(string reason);

    function encodeFunctionCall(
        string memory functionSignature,
        bytes memory parameters
    ) internal pure returns (bytes memory) {
        bytes4 selector = bytes4(keccak256(bytes(functionSignature)));
        return abi.encodePacked(selector, parameters);
    }

    function safeCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        if (target.code.length == 0) {
            revert CallFailed("Call to non-contract address");
        }
        (bool success, bytes memory returnData) = target.call(data);
        if (!success) {
            if (returnData.length > 0) {
                // The call reverted with a revert reason or a custom error.
                revert CallReverted(returnData);
            } else {
                revert CallFailed(
                    "Call to target contract failed without a revert reason"
                );
            }
        }
        return returnData;
    }

    function safeStaticCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        //basically the same function but read-only
        if (target.code.length == 0) {
            revert CallFailed("Call to non-contract address");
        }
        (bool success, bytes memory returnData) = target.staticcall(data);
        if (!success) {
            if (returnData.length > 0) {
                // The call reverted with a revert reason or a custom error.
                revert StaticCallReverted(returnData);
            } else {
                revert CallFailed(
                    "Static call to target contract failed without a revert reason"
                );
            }
        }
        return returnData;
    }

    function safeDelegateCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        if (target.code.length == 0) {
            revert CallFailed("Delegate call to non-contract address");
        }
        (bool success, bytes memory returnData) = target.delegatecall(data);
        if (!success) {
            if (returnData.length > 0) {
                // The call reverted with a revert reason or a custom error.
                revert CallReverted(returnData);
            } else {
                revert CallFailed(
                    "Delegate call to target contract failed without a revert reason"
                );
            }
        }
        return returnData;
    }
}
