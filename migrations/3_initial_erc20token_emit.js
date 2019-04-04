//require('./2_initial_erc20token_emit');

module.exports = function(deployer) {
    deployer.deploy(ConfirmOwnership).then((instance) => {
        //console.log(instance);
        //console.log(token.address);
        //console.log(token.address);
/*        instance.addToWL.call(token.address).then(() => {
            instance.isTokenOwner.call(token.address).then((r) => {
                resolve(r)
            })
        })*/
    })
};

