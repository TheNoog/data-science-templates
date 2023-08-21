use rust_lp_solver::{ColIdx, Direction, Problem};

fn main() {
    // Define the objective function coefficients
    let c = vec![10.0, 15.0];

    // Define the constraint matrix A
    let a = vec![
        vec![2.0, 3.0],
        vec![4.0, 2.0],
        vec![1.0, 0.0],
    ];

    // Define the constraint right-hand side
    let b = vec![100.0, 80.0, 20.0];

    // Create a new linear programming problem
    let mut problem = Problem::new();
    
    // Set the problem to maximize the objective function
    problem.set_direction(Direction::Maximize);

    // Add the variables
    let product_a = problem.add_var("Product_A");
    let product_b = problem.add_var("Product_B");

    // Add the objective function
    problem.set_obj(ColIdx(product_a), c[0]);
    problem.set_obj(ColIdx(product_b), c[1]);

    // Add the constraints
    for (i, row) in a.iter().enumerate() {
        problem.add_constraint(row.iter().enumerate().map(|(j, &value)| {
            (ColIdx(j), value)
        }), b[i]);
    }

    // Solve the linear programming problem
    let solution = problem.solve();

    // Get the optimal values of the decision variables
    let optimal_values = solution.vars();

    // Calculate the total profit
    let total_profit = solution.objective();

    // Print the results
    println!("Product A units to produce: {}", optimal_values[0]);
    println!("Product B units to produce: {}", optimal_values[1]);
    println!("Total Profit: ${:.2}", total_profit);
}
