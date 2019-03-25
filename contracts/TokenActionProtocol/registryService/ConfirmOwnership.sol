pragma solidity ^0.5.6;

import '../Ownable.sol';
import '../IOwnable.sol';

/** @dev endless contract */
contract ConfrimOwnership is Ownable {

    mapping (address => mapping (address => bool)) private _owners_WL;

    function detectOwner(address token) public view returns (bool) {
        return keccak256(abi.encodePacked(IOwnable(address(token)).owner())) == keccak256(abi.encodePacked(msg.sender));
    }

    modifier isValidOwner(address token) {
        require(true == _owners_WL[msg.sender][token]);
        _;
    }

    function isTokenOwner(address token) public view returns(bool) {
        require(true == _owners_WL[msg.sender][token]);
        return true;
    }

    function addToWL(address token) public {
        if(detectOwner(token)) {
            _owners_WL[msg.sender][token] = true;
        } else {
            revert('Not confirmed');
        }
    }

    function addToWL(address token, address addr) public onlyOwner {
        _owners_WL[token][addr] = true;
    }
}

