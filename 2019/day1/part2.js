const fs = require('fs');

const modules = fs.readFileSync('input.txt', 'utf8').split('\n');
// test data:
// const modules = [14, 1969, 100756];
// test answer: 2+966+50346 = 51314

const calculateFuel = mass => {
    const fuel =  Math.floor(mass / 3) - 2;
    return fuel <= 0 ? 0 : fuel + calculateFuel(fuel);
}

const total = modules.reduce((sum, module) => sum + calculateFuel(module), 0);
console.log(`total fuel needed: ${total}`);