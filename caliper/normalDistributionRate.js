
'use strict';

// const RateInterface = require('~/caliper-workspace/node_modules/@hyperledger/caliper-core/lib/rate-control/rateInterface.js');
// const Sleep = require('../../common/utils/caliper-utils').sleep;
const RateInterface = require('/hyperledger/caliper/workspace/node_modules/@hyperledger/caliper-core/lib/worker/rate-control/rateInterface.js');
const Sleep = require('/hyperledger/caliper/workspace/node_modules/@hyperledger/caliper-core/lib/common/utils/caliper-utils').sleep;

/**
 * Rate controller for normal-distribution of workload generation.
 *
 * @property {object} options The user-supplied options for the controller. Empty.
 */
class NormalRate extends RateInterface{

    /**
     * Initializes the rate controller instance.
     * @param {TestMessage} testMessage The testMessage passed for the round execution
     * @param {TransactionStatisticsCollector} stats The TX stats collector instance.
     * @param {number} workerIndex The 0-based index of the worker node.
     * @param {number} roundIndex The 0-based index of the current round.
     * @param {number} numberOfWorkers The total number of worker nodes.
     * @param {object} roundConfig The round configuration object.
     */
    constructor(testMessage, stats, workerIndex) {
        super(testMessage, stats, workerIndex);
        
        // change TPS, instead of a fixed value, a sequence of values
        // const tps = this.options.tps ? this.options.tps : 10;
        // var tpsPerWorker = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        // this.sleepTimes = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        // const tps = [
        //     11.37,
        //     11.11,
        //     10.12,
        //     8.44,
        //     9.77,
        //     10.29,
        //     9.76,
        //     9.75,
        //     9.43,
        //     9.14];
        // for (var i = 0, length = tps.length; i < length; i++)
        this.sleepTimes = new Array();
        // confirm the standard deviation and the mean!!!
        const standardDeviation = this.options.standardDeviation;
        const mean = this.options.mean;
        let s, u, v;
        // generate 20000 normally distributed random numbers
        for (let i = 0, length = 10000; i < length; i++)
        {
            // var tpsPerWorker = tps[i] / this.numberOfWorkers;
            // this.sleepTimes[i] = 1000/tpsPerWorker;
            do
            {
                u = Math.random()*2-1;
                v = Math.random()*2-1;
                s = u*u+v*v;
            } while(s == 0 || s >= 1);
            let mul = Math.sqrt(-2 * Math.log(s) / s);
            let normRand1 = (mul * u) * standardDeviation + mean;
            this.sleepTimes.push(normRand1);
            let normRand2 = (mul * v) * standardDeviation + mean;
            this.sleepTimes.push(normRand2);
            // normRand is an interarrival time
            // let tpsPerWorker = normRand / this.numberOfWorkers;
            // this.sleepTimes.push(1000/tpsPerWorker);
        }
        this.sleptTime = 0;

    }

    /**
     * Applies normally distributed rate control
     * @async
     */
    async applyRateControl() {
        // if (this.sleepTime === 0) {
        //     return;
        // }

        // const totalSubmitted = this.stats.getTotalSubmittedTx();
        // let sleptTime = 0;
        // for (let i = 0, length = totalSubmitted; i < length; i++)
        // {
        //     sleptTime = sleptTime + this.sleepTimes[i];
        // }
        this.sleptTime = this.sleptTime + this.sleepTimes[this.stats.getTotalSubmittedTx() + 1];
        let diff = (this.sleptTime - (Date.now() - this.stats.getRoundStartTime()));
        // console.log(`INPUTGEN ${this.sleptTime} sleptTime`);
        // console.log(`INPUTGEN ${Date.now()} now`);
        // console.log(`INPUTGEN ${this.stats.getRoundStartTime()} roundstarttime`);
        
        // print input diff
        if (diff < 0) {
            diff = 0;
        }
        console.log(`INPUTGEN ${diff}`);
        await Sleep(diff);
    }

    /**
     * Notify the rate controller about the end of the round.
     * @async
     */
    async end() { 
        // nothing to dispose of
    }
}

/**
 * Factory for creating a new rate controller instance.
 * @param {TestMessage} testMessage start test message
 * @param {TransactionStatisticsCollector} stats The TX stats collector instance.
 * @param {number} workerIndex The 0-based index of the worker node.
 *
 * @return {RateInterface} The new rate controller instance.
 */
function createRateController(testMessage, stats, workerIndex) {
    return new NormalRate(testMessage, stats, workerIndex);
}

module.exports.createRateController = createRateController;
