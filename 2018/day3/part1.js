const fs = require('fs');

const claims = fs.readFileSync('input.txt', 'utf8').split('\n');
// testing
// const claims = [ '#1 @ 2,2: 4x2', '#2 @ 1,3: 3x6'];

const getClaimNumber = claim => parseInt(claim.substring(claim.indexOf('#')+1, claim.indexOf(' @')));
const getX = claim => parseInt(claim.substring(claim.indexOf('@')+2, claim.indexOf(',')));
const getY = claim => parseInt(claim.substring(claim.indexOf(',')+1, claim.indexOf(':')));
const getWidth = claim => parseInt(claim.substring(claim.indexOf(':')+2, claim.indexOf('x')));
const getHeight = claim => parseInt(claim.substring(claim.indexOf('x')+1));

// an array of arrays - toplevel array is the grid
// [
//     [<empty>, 1, 1, 1, 2], -each array inside is a row, each point in that array is a sq in
//     [<empty>, 1, 1, 1, 2]
// ]

// access a point like grid[y][x]
let grid = [];
let count = 0;

claims.forEach(claim => {
    const xStart = getX(claim);
    const yStart = getY(claim);
    const width = getWidth(claim);
    const height = getHeight(claim);

    for (row = yStart; row< yStart+height; row++) {
        for (col = xStart; col < xStart+width; col++) {
            if (!grid[row]) {
                grid[row] = [];
            }

            if (!grid[row][col]) {
                grid[row][col] = getClaimNumber(claim);
            } else if (grid[row][col] !== 'X') {
                // marked and we have not counted it yet
                grid[row][col] = 'X';
                count++;
            }
        }
    }
})


// console.log(grid);
console.log(`count: ${count}`);
