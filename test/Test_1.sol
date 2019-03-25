pragma solidity ^0.5.6;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/erc20/FixedSupplyToken.sol";

contract Test_1 {
    using Assert for *;

    event Hello(string text);

    constructor() public {
        emit Hello("hi");
    }

    function testInitialBalanceUsingDeployedContract() {
        FixedSupplyToken meta = FixedSupplyToken(DeployedAddresses.FixedSupplyToken());

        uint256 expected = 1000000;

        Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 1000000 FixedSupplyToken initially");
    }
    
}
