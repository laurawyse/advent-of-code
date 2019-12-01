const fs = require('fs');

// format of each guard record: 
// {
//     "guardId": {
//         0: ["1518-07-09", "1518-07-10"], -- minute followed by a list of the dates they were asleep
//         1: ["1518-07-10", "1518-07-19"],
//         // ...
//         59: ["1518-07-01"]
//     }
// }

const isBeginShiftRecord = record => record.indexOf('begins shift') > -1;
const isWakesUpRecord = record => record.indexOf('wakes up') > -1;
const isFallsAsleepRecord = record => record.indexOf('falls asleep') > -1;

const getGuardId = record => record.substring(record.indexOf('#') + 1, record.indexOf('begins') - 1);
const getDate = record => record.substring(record.indexOf('[') + 1, record.indexOf(' '));
const getMinute = record => parseInt(record.substring(record.indexOf(':') + 1, record.indexOf(']')));

const initializeMinutesObj = () => {
    let minObj = {};
    for (i=0; i<60; i++) {
        minObj[i] = [];
    }
    return minObj;
}

const records = fs.readFileSync('input.txt', 'utf8').split('\n').sort();
// testing
// const records = [
//     '[1518-06-12 00:00] Guard #1234 begins shift',
//     '[1518-06-12 00:26] falls asleep',
//     '[1518-06-12 00:30] wakes up',
//     '[1518-07-13 00:04] Guard #1 begins shift',
//     '[1518-07-13 00:30] falls asleep',
//     '[1518-07-13 00:41] wakes up',
//     '[1518-07-14 00:00] Guard #1234 begins shift',
//     '[1518-07-14 00:29] falls asleep',
//     '[1518-07-14 00:40] wakes up'
// ];
const sorted = {};

// build data structure sorted by guard id then by minute (above)
let currentGuard, asleepStartMinute;
let isAsleep = false;

records.forEach(record => {
    if (isBeginShiftRecord(record)) {
        currentGuard = getGuardId(record);
        if (!sorted[currentGuard]) {
            sorted[currentGuard] = initializeMinutesObj();
        }
    } else if (isFallsAsleepRecord(record)) {
        isAsleep = true;
        asleepStartMinute = getMinute(record);
    } else if (isWakesUpRecord(record)) {
        for (m=asleepStartMinute; m<getMinute(record); m++) {
            const date = getDate(record);
            sorted[currentGuard][m].push(date);
        }

        // reset
        isAsleep = false;
        asleepStartMinute = '';
    }
})

const findMinuteWithMost = (sortedObj, guardId) => {
    const guardMinutes = sortedObj[guardId];
    return Object.keys(guardMinutes).reduce((highestMinute, nextMinute) => {
        return guardMinutes[nextMinute].length > guardMinutes[highestMinute].length ? nextMinute : highestMinute;
    }, 0);

}

let guardWithMostPerMin = Object.keys(sorted)[0];
let minuteWithMost = 0;

Object.keys(sorted).forEach(nextGuard => {
    const highestMinuteForNextGuard = findMinuteWithMost(sorted, nextGuard);
    if (sorted[nextGuard][highestMinuteForNextGuard].length > sorted[guardWithMostPerMin][minuteWithMost].length) {
        guardWithMostPerMin = nextGuard;
        minuteWithMost = highestMinuteForNextGuard;
    }
})


console.log(`Guard with most: ${guardWithMostPerMin}`);
// console.log(sorted[guardWithMostPerMin]);
console.log(`Minute with most: ${minuteWithMost}`)
console.log(`Answer: ${guardWithMostPerMin*minuteWithMost}`)

