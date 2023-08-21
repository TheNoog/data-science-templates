const std = @import("std");
const mem = @import("std").mem;

const print = @import("std").debug.print;

const LinearProgram = struct {
    c: [2]f64, // Objective function coefficients
    A: [3][2]f64, // Constraint matrix A
    b: [3]f64, // Constraint right-hand side
};

fn main() !void {
    var lp: LinearProgram = .{
        .c = [10.0, 15.0],
        .A = [ [2.0, 3.0], [4.0, 2.0], [1.0, 0.0] ],
        .b = [100.0, 80.0, 20.0],
    };

    var solver = math.lp.newSolver();
    var obj = lp.c[0] * solver.x[0] + lp.c[1] * solver.x[1];

    // Add constraints to the solver
    for (lp.A) |row, i| {
        const lhs = row[0] * solver.x[0] + row[1] * solver.x[1];
        solver.addConstraint(lhs, math.lp.ConstraintType.LessThanOrEqual, lp.b[i]);
    }

    solver.maximize(obj);
    try solver.solve();

    // Get the results
    const optimalValues = solver.x;
    const totalProfit = obj.call([optimalValues[0], optimalValues[1]]);

    // Print the results
    print("Product A units to produce: {}\n", .{optimalValues[0]});
    print("Product B units to produce: {}\n", .{optimalValues[1]});
    print("Total Profit: ${}\n", .{totalProfit});
}
