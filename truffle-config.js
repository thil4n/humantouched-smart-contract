module.exports = {
    networks: {
        development: {
            host: "77.37.121.45",
            port: 8545,
            network_id: "*",
            from: "0x627306090abaB3A6e1400e9345bC60c78a8BEf57",
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
