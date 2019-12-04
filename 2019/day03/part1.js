const fs = require('fs');

const lines = fs.readFileSync('input.txt', 'utf8').split('\n');
const wire_1_moves = lines[0].split(',');
const wire_2_moves = lines[1].split(',');

const getDirection = move => move.substring(0, 1);
const getNumber = move => parseInt(move.substring(1));

const addPoint = (pointObj, x, y) => {
    if (pointObj[x]) {
        if (!pointObj[x].includes(y)) {
            pointObj[x].push(y);
        }
    } else {
        pointObj[x] = [y];
    }
}

const buildPointObj = (moves) => {
    const wire_points = {};
    let current_x = 0;
    let current_y = 0;

    moves.forEach(move => {
        addPoint(wire_points, current_x, current_y);
    
        const direction = getDirection(move);
        const number = getNumber(move);
    
        for (let i=0; i < number; i++) {
            switch(direction) {
                case 'R':
                    current_x++;
                    break;
                case 'L':
                    current_x--;
                    break;
                case 'U':
                    current_y++;
                    break;
                case 'D':
                    current_y--;
                    break;
                default:
                  console.log('uh oh this shouldnt happen');
                }
              addPoint(wire_points, current_x, current_y);
        }
    });

    return wire_points;
}

// "pointObj" data struction where 1 is an x coordinate and 10, 11, 12 are y coordinates. 
// each combo represents a point the wire crossed. numbers can be positive or negative
// { 
//     1: [11, 12, 13]
// }
// generic:
// { 
//     x1: [y1, y2, y3],
//     x2: [y1, y2, y3]
// }
const wire_1_points = buildPointObj(wire_1_moves);
const wire_2_points = buildPointObj(wire_2_moves);

// find all the crossover points
// points = {
//     x: 1,
//     y: 2
// }

const crossover_points = []

Object.keys(wire_1_points).forEach(x => {
    const ys = wire_1_points[x];
    if (wire_2_points[x]){
        ys.forEach(y => {
            if (!(x == 0 && y == 0) && wire_2_points[x].includes(y)){
                crossover_points.push({x, y});
            }
        });
    }
});

// find the crossover point with the shortest manhattah distance from (0,0)
const ZERO = {
    x: 0,
    y: 0
};
const manhattanDist = (pt1, pt2) => Math.abs(pt1.x - pt2.x) + Math.abs(pt1.y - pt2.y);

let closest_point;
let closest_distance;
crossover_points.forEach(pt => {
    const dist = manhattanDist(ZERO, pt);
    if (!closest_distance || dist < closest_distance) {
        // first so this is closest
        closest_point = pt;
        closest_distance = dist;
    }
});

console.log('crossover_points', JSON.stringify(crossover_points));
console.log('closest_point', JSON.stringify(closest_point));
console.log('closest_distance', closest_distance);