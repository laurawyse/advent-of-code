const fs = require('fs');

const lines = fs.readFileSync('input.txt', 'utf8').split('\n');
const wire_1_moves = lines[0].split(',');
const wire_2_moves = lines[1].split(',');

const getDirection = move => move.substring(0, 1);
const getNumber = move => parseInt(move.substring(1));

const addPoint = (pointObj, x, y, steps) => {
    if (pointObj[x]) {
        if (!pointObj[x][y]) {
            pointObj[x][y] = steps;
        }
    } else {
        pointObj[x] = {};
        pointObj[x][y] = steps;
    }
}

const buildPointObj = (moves) => {
    const wire_points = {};
    let current_x = 0;
    let current_y = 0;
    let steps = 0;

    moves.forEach(move => {
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
            steps++;
            addPoint(wire_points, current_x, current_y, steps);
              
        }
    });

    return wire_points;
}

// "pointObj" data struction where 1 is an x coordinate and 11, 12 are y coordinates and 5 and 6 are the number of 
// steps taked to get to that place
// each combo represents a point the wire crossed. numbers can be positive or negative
// { 
//     1: {
//         11: 5,
//         12: 6
//     }
// }
// generic:
// { 
//     x1: {
//         y1: steps,
//         y2: steps
//     }
// }
const wire_1_points = buildPointObj(wire_1_moves);
const wire_2_points = buildPointObj(wire_2_moves);

// find all the crossover points
// points = {
//     x: 1,
//     y: 2,
//     steps: x
// }

const crossover_points = []

Object.keys(wire_1_points).forEach(x => {
    const ys = wire_1_points[x];
    if (wire_2_points[x]){
        Object.keys(ys).forEach(y => {
            if (!(x == 0 && y == 0) && wire_2_points[x][y]){
                const steps = wire_2_points[x][y] + wire_1_points[x][y]
                crossover_points.push({x, y, steps});
            }
        });
    }
});

// find the crossover point with the least number of total steps

// this could be better...
let closest_point_by_steps;
let steps;
crossover_points.forEach(pt => {
    if (!steps || pt.steps < steps) {
        // first so this is closest
        closest_point_by_steps = pt;
        steps = pt.steps;
    }
});

console.log('crossover_points', JSON.stringify(crossover_points));
console.log('closest_point_by_steps', JSON.stringify(closest_point_by_steps));
console.log('steps', steps);