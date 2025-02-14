var Token = artifacts.require("./Token.sol");

module.exports = function (deployer) {
    deployer.deploy(Token, "0x119813b14d0f7d6FB10334ddE7FD0Df2C90977e0");
};
