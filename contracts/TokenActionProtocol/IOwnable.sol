pragma solidity ^0.5.6;

interface IOwnable {
    function isOwner() external view returns (bool);
    function owner() external view returns (address);
}