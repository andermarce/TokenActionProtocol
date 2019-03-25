const ERC20Token = artifacts.require("FixedSupplyToken");

module.exports = function(deployer) {
      deployer.deploy(ERC20Token).then((response) => {
      })
};
