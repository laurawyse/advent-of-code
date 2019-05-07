const fs = require('fs');

const frequencyChanges = fs.readFileSync('input.txt', 'utf8').split('\n');
const frequency = frequencyChanges.reduce((frequency, change) => frequency + parseInt(change), 0);

console.log(frequency);