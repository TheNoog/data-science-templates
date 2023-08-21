const LinearProgram = require('linear-programming');

// Define the objective function coefficients
const c = [10, 15];

// Define the constraint matrix A
const A = [
    [2, 3],
    [4, 2],
    [1, 0]
];

// Define the constraint right-hand side vector
const b = [100, 80, 20];

// Create a new linear program
const lp = new LinearProgram(c);

// Add constraints to the linear program
for (let i = 0; i < A.length; i++) {
    lp.addConstraint(A[i], '<=', b[i]);
}

// Set the linear program to maximize the objective
lp.maximize();

// Solve the linear program
const solution = lp.solve();

// Get the optimal values of the decision variables
const optimalValues = solution.vector;

// Calculate the total profit
const totalProfit = c[0] * optimalValues[0] + c[1] * optimalValues[1];

// Print the results
console.log(`Product A units to produce: ${optimalValues[0]}`);
console.log(`Product B units to produce: ${optimalValues[1]}`);
console.log(`Total Profit: $${totalProfit.toFixed(2)}`);
