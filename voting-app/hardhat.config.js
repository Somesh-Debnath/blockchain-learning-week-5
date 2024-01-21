require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config()

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.23",
  networks: {
    mumbai: {
      url: process.env.MUMBAI_URL,
      accounts: [process.env.ACCOUNT]
    },
  },
  etherscan: {
    apiKey: process.env.API_KEY,
  },
};