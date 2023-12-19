// eslint-disable-next-line no-undef
const CryptoToys = artifacts.require("CryptoToys");

module.exports = async function(deployer) {
  await deployer.deploy(CryptoToys);
};
