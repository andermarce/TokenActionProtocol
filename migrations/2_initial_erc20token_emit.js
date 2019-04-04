const ERC20Token = artifacts.require("FixedSupplyToken");
//const TokenActionProtocol = artifacts.require("TokenActionProtocol");
const ConfirmOwnership = artifacts.require("ConfirmOwnership");
/*module.exports = function(deployer) {
    deployer.deploy(TokenActionProtocol,
        param1,
        param2,
        ..
).then((response) => {
    })
};*/

module.exports = function(deployer) {
    deployer.deploy(ERC20Token).then((response) => {
      console.log(response.address);
    });
};
