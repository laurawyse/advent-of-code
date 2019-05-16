const fs = require('fs');

const polymer = fs.readFileSync('input.txt', 'utf8');
// test input:
// const polymer = 'dabAcCabBbBCBAcCcaDAa';

const react = polymer => {
    let reacted = '';

    for (i=0; i < polymer.length; i++) {
        // if i is the last, add it, there's nothing to react with
        if (i == polymer.length + 1) {
            reacted += polymer.substring(i);
        }
        const current = polymer.substring(i, i+1);
        const next = polymer.substring(i+1, i+2);
    
        if (current != next && current.toLowerCase() === next.toLowerCase()) {
            // current and next react so leave them out
            i++;
        } else {
            reacted += current;
        }
    }

    if (reacted === polymer) {
        // base case - no more reactions were found
        return reacted
    }

    // recursively react the new string
    return react(reacted);
}

const fullyReacted = react(polymer);

// console.log(`expected: dabCBAcaD`);
// console.log(`actual:   ${fullyReacted}`)
console.log(`length of fully reacted: ${fullyReacted.length}`);
