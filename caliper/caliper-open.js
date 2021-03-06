'use strict';

module.exports.info = 'Adding Cars';
const { v1: uuidv4 } = require('uuid');

let txnPerBatch;
let bc, contx;
module.exports.init = function (blockchain, context, args) {

    if (!args.hasOwnProperty('txnPerBatch')) {
        args.txnPerBatch = 1;
    }
    txnPerBatch = args.txnPerBatch;
    bc = blockchain;
    contx = context;

    return Promise.resolve();
};

function generateWorkload() {
    let workload = [];
    for (let i = 0; i < txnPerBatch; i++) {

        workload.push({
            chaincodeFunction: 'createCar',
            chaincodeArguments: [uuidv4(), "A", "B", "C", "D"],
        });
    }
    return workload;
}

module.exports.run = function () {
    try {
        let args = generateWorkload();
        return bc.invokeSmartContract(contx, 'fabcar', '2.0', args);
    } catch (err) {
        console.log(err)
    }

};

module.exports.end = function () {
    return Promise.resolve();
};
