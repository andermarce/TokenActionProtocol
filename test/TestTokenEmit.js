const FST = artifacts.require("./FixedSupplyToken");

contract("FST", accounts => {
    it("should put 10000 FST in the first account", () =>
        FST.deployed()
            .then(instance => {
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

    it("should send coin correctly", () => {
        let meta;

        // Get initial balances of first and second account.
        const account_one = accounts[0];
        const account_two = accounts[1];

        let account_one_starting_balance;
        let account_two_starting_balance;
        let account_one_ending_balance;
        let account_two_ending_balance;

        const amount = 10;

        return FST.deployed()
            .then(instance => {
                meta = instance;
                return meta.balanceOf.call(account_one);
            })
            .then(balance => {
                account_one_starting_balance = balance.toNumber();
                return meta.balanceOf.call(account_two);
            })
            .then(balance => {
                account_two_starting_balance = balance.toNumber();
                return meta.transfer(account_two, amount, { from: account_one });
            })
            .then(() => meta.balanceOf.call(account_one))
            .then(balance => {
                account_one_ending_balance = balance.toNumber();
                return meta.balanceOf.call(account_two);
            })
            .then(balance => {
                account_two_ending_balance = balance.toNumber();

                assert.equal(
                    account_one_ending_balance,
                    account_one_starting_balance - amount,
                    "Amount wasn't correctly taken from the sender"
                );
                assert.equal(
                    account_two_ending_balance,
                    account_two_starting_balance + amount,
                    "Amount wasn't correctly sent to the receiver"
                );
            });
    });
});