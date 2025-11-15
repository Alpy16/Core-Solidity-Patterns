//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Very simple reentrancy guard that checks there is no ongoing function being executed

contract ReEntrancyGuard {
    bool locked;
    error ReEntranceDetected();

    modifier nonReentrant() {
        if (locked) revert ReEntranceDetected();
        locked = true;
        _;
        locked = false;
    }

    function getLockState() internal view returns (bool) {
        return locked;
    }
}
