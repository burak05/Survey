module.exports = {
  networks: {
    development: {
        host: "127.0.0.1",
        port: 8545,
        network_id: "*",
        gas: 8000000  // Gas limitinizi artırın.
    },
},
  compilers: {
    solc: {
      version: "^0.8.0"
    }
  }
};