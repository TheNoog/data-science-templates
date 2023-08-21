require 'linear_programming'

# Objective function coefficients
c = [10, 15]

# Constraint matrix A
A = [
  [2, 3],
  [4, 2],
  [1, 0]
]

# Constraint right-hand side
b = [100, 80, 20]

# Create a linear program
lp = LinearProgramming::Problem.new
lp.maximize(c)

# Add constraints
A.each_with_index do |row, i|
  lp.add_constraint(row, "<=", b[i])
end

# Solve the linear program
solution = lp.solve

# Get the optimal values of the decision variables
optimal_values = solution[:point]

# Calculate the total profit
total_profit = -solution[:value]

# Print the results
puts "Product A units to produce: #{optimal_values[0]}"
puts "Product B units to produce: #{optimal_values[1]}"
puts "Total Profit: $#{total_profit}"
