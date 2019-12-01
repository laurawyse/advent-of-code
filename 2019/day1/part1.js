const fs = require('fs');

const modules = fs.readFileSync('input.txt', 'utf8').split('\n');
// test data:
// const modules = [12, 14, 1969, 100756];
// test answer: 2+2+654+33583 = 34241

const calculateFuel = mass => {
    return Math.floor(mass / 3) - 2;
}

const total = modules.reduce((sum, module) => sum + calculateFuel(module), 0);
console.log(`total fuel needed: ${total}`);