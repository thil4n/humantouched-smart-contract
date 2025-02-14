module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            port: 8545,
            network_id: "*",
            from: "0x119813b14d0f7d6FB10334ddE7FD0Df2C90977e0",
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
