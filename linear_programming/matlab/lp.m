% Objective function coefficients
c = [10; 15];

% Constraint matrix A
A = [2, 3; 4, 2; 1, 0];

% Constraint right-hand side
b = [100; 80; 20];

% Lower bounds for variables
lb = [0; 0];

% Upper bounds for variables
ub = [];

% Solve the linear programming problem
options = optimoptions('linprog', 'Algorithm', 'simplex', 'Display', 'off');
[x, fval, exitflag, output] = linprog(-c, A, b, [], [], lb, ub, [], options);

% Calculate the total profit
totalProfit = -fval;

% Print the results
fprintf('Product A units to produce: %.2f\n', x(1));
fprintf('Product B units to produce: %.2f\n', x(2));
fprintf('Total Profit: $%.2f\n', totalProfit);
