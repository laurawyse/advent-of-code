const fs = require('fs');

const boxIds = fs.readFileSync('input.txt', 'utf8').split('\n');
// for testing
// const boxIds = ['abcde', 'fghij', 'klmno', 'pqrst', 'fguij','axcye', 'wvxyz'];

let matchymatch;

boxIds.forEach(id1 => {
    boxIds.forEach(id2 => {
        if (id1 === id2) {
            // nope, its the same one
            return;
        }

        let numberOfSameChars = 0;
        let sameChars = '';
        const id1Chars = id1.split('');
        const id2Chars = id2.split('');

        for (i=0; i < id1Chars.length; i++) {
            if (id1Chars[i] === id2Chars[i]) {
                numberOfSameChars++;
                sameChars += id1Chars[i];
            }
        }

        if (numberOfSameChars == id1Chars.length - 1) {
            // its these two!
            matchymatch = sameChars;
        } else {
            sameChars = '';
        }
    })
});

console.log(matchymatch);