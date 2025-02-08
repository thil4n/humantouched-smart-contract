module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            port: 8545,
            network_id: "*",
            from: "0x3CE5128475c1d110e6347Ea8C4cf09Aae9eB1506",
        },
    },
    compilers: {
        solc: {
            version: "0.8.20",
            settings: {
                optimizer: {
                    enabled: false,
                    runs: 200,
                },
                evmVersion: "byzantium",
            },
        },
    },
};
