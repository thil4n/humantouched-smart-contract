var Token = artifacts.require("./Token.sol");

module.exports = function (deployer) {
    deployer.deploy(Token, "0x627306090abaB3A6e1400e9345bC60c78a8BEf57");
};
