const fs = require('fs');

const polymer = fs.readFileSync('input.txt', 'utf8');
// test input:
// const polymer = 'dabAcCabBbBCBAcCcaDAa';

const removeChar = (polymer, char) => polymer.replace(new RegExp(char, 'gi'), '');

const alpha = [
    'a', 
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
]

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


const byChar = alpha.map(char => {
    return {
        char,
        length: react(removeChar(polymer, char)).length
    }
})

const most = byChar.reduce((lowest, current) => current.length < lowest.length ? current : lowest, byChar[0]);
console.log(most);