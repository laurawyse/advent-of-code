const fs = require('fs');

const pts = fs.readFileSync('input.txt', 'utf8').split('\n');
// testing
// const pts = [ 
//     '1, 1', 
//     '1, 6',
//     '8, 3',
//     '3, 4',
//     '5, 5',
//     '8, 9'
// ];

const getX = pt => parseInt(pt.substring(0, pt.indexOf(',')));
const getY = pt => parseInt(pt.substring(pt.indexOf(',')+2));
const PLACE_HOLDER ='.';

/**
 * an obj with 'x' and 'y'
 * @param {*} pt string version of the point like '1, 1'
 */
const getPoint = pt => {
    return {
        x: getX(pt),
        y: getY(pt)
    };
};

const manhattanDist = (pt1, pt2) => Math.abs(pt1.x - pt2.x) + Math.abs(pt1.y - pt2.y);

// build the grid
// an array of arrays - toplevel array is the grid
// [
//     [<empty>, X, <empty>],
//     [<empty>, <empty>, X]
// ]

// find max x and y
const xMax = pts.reduce((x, pt) => getX(pt) > x ? getX(pt) : x, 0);
const yMax = pts.reduce((y, pt) => getY(pt) > y ? getY(pt) : y, 0);

// access a point like grid[y][x]
let grid = [];

let ptNumber = 0;
pts.forEach(pt => {
    const x = getX(pt);
    const y = getY(pt);

    if (!grid[y]) {
        grid[y] = [];
    }

    grid[y][x] = ptNumber;
    ptNumber++;
})

// fill out empties
grid = Array.from(grid, item => item || []);
grid = grid.map(row => {
    return Array.from(row, item => item || PLACE_HOLDER);
})

// console.log('just points\n', grid);

const findClosest = currentPt => {
    let closestPt;
    let closestDist = 'start';
    let tie = false;
    for (ptNumber = 0; ptNumber < pts.length; ptNumber++) {
        currentDist = manhattanDist(getPoint(currentPt), getPoint(pts[ptNumber]));
        if (closestDist == 'start' || currentDist < closestDist) {
            // this one is closer (or its just the first)
            closestPt = ptNumber;
            closestDist = currentDist;
            tie = false;
        } else if (currentDist == closestDist) {
            // theres a tie
            tie = true;
        }
    }

    return tie && currentPt != pts[closestPt] ? 'TIE' : closestPt;
};

// add letters for manhattan distance ? can I do this above? idk how to do this efficiently... or at all
for (row = 0; row <= yMax; row++){
    for (col = 0; col <= yMax; col++) {
        if (!grid[row]) {
            grid[y] = [];
        }

        if (!grid[row][col] || grid[row][col] == PLACE_HOLDER) {
            const closest = findClosest(`${col}, ${row}`);
            grid[row][col] = closest === 'TIE' ? '-' : closest;
        }   
    }
}

// console.log('filled out\n', grid);

// now count the numbers
let pointTotals = {};
for (row = 0; row <= yMax; row++){
    for (col = 0; col <= yMax; col++) {
        const point = grid[row][col];
        if (point != '-'){
            // add it
            const t = pointTotals[point];
            pointTotals[point] = t>0 ? t+1 : 1;
        }  
    }
}

// TODO - DO NOT INCLUDE INFINITE AREAS
// set pointTotal to 0 for those that are infinite
// anything in first row is infinite
for (col = 0; col <= yMax; col++) {
    const point = grid[0][col];
    pointTotals[point] = 0;
}
// anything in last row is infinite
for (col = 0; col <= yMax; col++) {
    const point = grid[yMax][col];
    pointTotals[point] = 0;
}
// anything in first col is infinite
for (row = 0; row <= yMax; row++) {
    const point = grid[row][0];
    pointTotals[point] = 0;
}
// anything in last col is infinite
for (row = 0; row <= yMax; row++) {
    const point = grid[row][xMax];
    pointTotals[point] = 0;
}

// now find the max count
let pointNumberWithMost = '0';
let most = pointTotals['0'];
Object.keys(pointTotals).forEach(pointNumber => {
    if (pointTotals[pointNumber] > most) {
        most = pointTotals[pointNumber];
        pointNumberWithMost = pointNumber;
    };
})

console.log(pointTotals);
console.log('pointNumberWithMost', pointNumberWithMost)
console.log('most', most);
