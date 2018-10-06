var Migrations = artifacts.require("./Migrations.sol");
var Panda = artifacts.require("./Panda.sol");

module.exports = function(deployer) {
	deployer.deploy(Migrations);
	deployer.deploy(Panda);
};
