//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "../src/Ownable.sol";

contract Pausable is Ownable {
    bool internal paused;
    error AlreadyPaused();
    error NotPaused();
    error StillPaused();

    modifier whenNotPaused() {
        if (paused) revert StillPaused();
        _;
    }

    modifier whenPaused() {
        if (paused == false) revert NotPaused();
        _;
    }

    function pause() external onlyOwner {
        if (paused) revert AlreadyPaused();
        paused = true;
    }

    function unPause() external onlyOwner {
        if (paused == false) revert NotPaused();
        paused = false;
    }
}
