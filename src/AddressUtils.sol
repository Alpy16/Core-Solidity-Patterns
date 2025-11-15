//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library AddressUtils {
    function isContract(address target) internal view returns (bool) {
        return target.code.length > 0;
    }
}
