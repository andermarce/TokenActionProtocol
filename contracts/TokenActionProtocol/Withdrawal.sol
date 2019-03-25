pragma solidity ^0.5.6;

import './libs/SafeMath.sol';
import './Ownable.sol';
/**
*   @dev Withdrawal contract - implements withdrawal pattern contract
*/
contract Withdrawal is Ownable {
    using SafeMath for uint;
    // FundsReceived
    // Emits when funds (Ether or tokens) are sent to the token contract's default/fallback function.
    event FundsReceived(address indexed from, uint256 fundsReceived);
    // FundsWithdrawn
    // Emits when a token holder claims funds from the token contract.
    event FundsWithdrawn(address indexed by, uint256 fundsWithdrawn);

    /** @dev total accumulated balance by this contract. */
    uint256 internal totalAccumulatedBalance;
    /** @dev current withdrawal balance */
    mapping (address => uint256) public pendingWithdrawals;
    mapping (address => uint256) public withdrawnBalance;  // return total withdrawn balance by current rightholder address

    /** @dev balance counter */
    function getAccumulatedBalance() public view returns (uint256) {
        return totalAccumulatedBalance;
    }

    /** @dev internal base method that is used for interest calculation */
    function prepareWithdrawal(uint256 _toWithdraw) internal returns (bool) {
        pendingWithdrawals[msg.sender] = pendingWithdrawals[msg.sender].add(_toWithdraw);
    }

    /** @dev top up the balance, permission only owner */
    function replenishBalance() public onlyOwner payable returns (bool) {
        totalAccumulatedBalance = totalAccumulatedBalance.add(msg.value);
        emit FundsReceived(msg.sender, msg.value);
        return true;
    }

    function withdraw() public returns(bool) {
        uint256 amount = pendingWithdrawals[msg.sender];
        pendingWithdrawals[msg.sender] = 0;
        withdrawnBalance[msg.sender] = withdrawnBalance[msg.sender].add(amount);
        msg.sender.transfer(amount);
        emit FundsWithdrawn(msg.sender, amount);
        return true;
    }
}
