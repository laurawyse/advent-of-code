const fs = require('fs');

const frequencyChanges = fs.readFileSync('input.txt', 'utf8').split('\n');

let frequency = 0;
let i = 0;
let done = false;
let pastFrequencies = [];

while (!done) {
    frequency = frequency + parseInt(frequencyChanges[i]);
    if (pastFrequencies.includes(frequency)) {
        console.log('duplicate frequency reached!');
        done = true;
    }
    pastFrequencies.push(frequency);

    // increment or if we're at the end then start over at the beginning
    i = (i == frequencyChanges.length - 1) ? 0 : i+1;
}
console.log(frequency);