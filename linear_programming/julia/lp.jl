using JuMP
using GLPK

# Create a JuMP model with GLPK solver
model = Model(optimizer_with_attributes(GLPK.Optimizer))

# Define the decision variables
@variable(model, product_a >= 0, Int)
@variable(model, product_b >= 0, Int)

# Set the objective function to maximize profit
@objective(model, Max, 10 * product_a + 15 * product_b)

# Add resource constraints
@constraint(model, 2 * product_a + 3 * product_b <= 100)
@constraint(model, 4 * product_a + 2 * product_b <= 80)

# Add production capacity constraints
@constraint(model, product_a <= 20)
@constraint(model, product_b <= 30)

# Solve the linear programming problem
optimize!(model)

# Get the optimal values of the decision variables
opt_product_a = value(product_a)
opt_product_b = value(product_b)

# Calculate the total profit
total_profit = objective_value(model)

# Print the results
println("Product A units to produce: ", opt_product_a)
println("Product B units to produce: ", opt_product_b)
println("Total Profit: \$", total_profit)
