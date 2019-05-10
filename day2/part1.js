const fs = require('fs');

const boxIds = fs.readFileSync('input.txt', 'utf8').split('\n');
// for testing
// const boxIds = ['nope', 'twoo', 'threee', 'bothoot', 'threeea'];

const buildCounts = id => {
    let counts = {};
    id.split('').forEach(char => {
        if (counts[char]) {
            counts[char] = counts[char] + 1;
        } else {
            counts[char] = 1;
        }
    })
    return counts;
}

const containsExactlyX = (counts, count) => {
    let hasTwoOfAnyLetter = false;
    Object.keys(counts).forEach(key => {
        if (counts[key] === count) {
            hasTwoOfAnyLetter = true;
        }
    });

    return hasTwoOfAnyLetter;
}

const exactlyTwos = boxIds.filter(id => containsExactlyX(buildCounts(id), 2));
const exactlyThrees = boxIds.filter(id => containsExactlyX(buildCounts(id), 3));

console.log(exactlyTwos.length * exactlyThrees.length);
