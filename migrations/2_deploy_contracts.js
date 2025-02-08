var SimpleStorage = artifacts.require("./SimpleStorage.sol");

module.exports = function (deployer) {
    deployer.deploy(
        SimpleStorage,
        "0x3CE5128475c1d110e6347Ea8C4cf09Aae9eB1506"
    );
};
