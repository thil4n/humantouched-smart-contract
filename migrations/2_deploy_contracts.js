var Token = artifacts.require("./Token.sol");

module.exports = function (deployer) {
    deployer.deploy(Token, "0x3CE5128475c1d110e6347Ea8C4cf09Aae9eB1506");
};
