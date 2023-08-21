# Objective function coefficients
c <- c(10, 15)

# Constraint matrix A
A <- matrix(c(2, 4, 3, 2, 1, 0), ncol = 2, byrow = TRUE)

# Constraint right-hand side
b <- c(100, 80, 20)

# Solve the linear programming problem
result <- lp("max", c, A, "<=", b, bounds = list(upper = c(Inf, Inf)))

# Get the optimal values of the decision variables
optimal_values <- result$solution

# Calculate the total profit
total_profit <- -result$objval

# Print the results
cat("Product A units to produce:", optimal_values[1], "\n")
cat("Product B units to produce:", optimal_values[2], "\n")
cat("Total Profit: $", total_profit, "\n")
