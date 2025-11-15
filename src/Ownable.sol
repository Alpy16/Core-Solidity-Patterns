//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable {
    address internal _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event OwnershipReleased(address indexed previousOwner);
    error ZeroAddressNotAllowed();
    error CallerIsNotOwner();

    constructor() {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner); // its only address 0 for the inital deployment
    }

    modifier onlyOwner() {
        if (msg.sender != _owner) revert CallerIsNotOwner();
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner == address(0)) revert ZeroAddressNotAllowed();
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function getOwner() public view returns (address) {
        // normally the name for this function is owner() because most frameworks (etherscan,ABI tooling etc.)recognise it automatically.
        return _owner;
    }

    function releaseOwnership() public onlyOwner {
        emit OwnershipReleased(_owner);
        _owner = address(0);
    }
}
