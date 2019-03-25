pragma solidity ^0.5.6;


interface IConfOwner {
    function isTokenOwner(address token) external view returns(bool);
}