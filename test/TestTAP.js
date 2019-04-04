const FST = artifacts.require("./FixedSupplyToken");
const TAP = artifacts.require("./TokenActionProtocol");
const Confirmator = artifacts.require("./ConfirmOwnership");

/*
    1. Test to emmit coins
    2. Emit contract confirmator

 */

var fst;

contract("FST", accounts => {
    it("should put 10000 FST in the first account", () =>
        FST.deployed()
            .then(instance => {
                fst = instance;
                console.log(fst.address);
                //console.log(fst);
                instance.balanceOf.call(accounts[0])
                    .then(balance => {
                        assert.equal(
                            balance.valueOf(),
                            10000,
                            "10000 wasn't in the first account"
                        );
                    })
            })
    );

    it("Is address token is inside of acc", () => {
        Confirmator.deployed()
            .then(instance => {
                try {
                    instance.addToWL.call(fst.address)
                        .then(() => {
                            instance.isTokenOwner.call(accounts[0])
                                .then(res => {
                                    console.log(res);
                                    assert.equal(
                                        true,
                                        res,
                                        "is owner"
                                    );
                                })
                        })
                } catch (e) {
                    console.log(e.message)
                }
            })

    })
});