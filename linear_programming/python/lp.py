from pulp import LpMaximize, LpProblem, LpVariable

# Create a linear programming problem
problem = LpProblem("Maximize_Profit", LpMaximize)

# Define decision variables
product_a = LpVariable("Product_A", lowBound=0, cat="Integer")
product_b = LpVariable("Product_B", lowBound=0, cat="Integer")

# Define the objective function (profit to maximize)
profit_per_unit_a = 10
profit_per_unit_b = 15
problem += (profit_per_unit_a * product_a) + (profit_per_unit_b * product_b)

# Define resource constraints
resource_1_usage_a = 2
resource_1_usage_b = 3
resource_1_avail = 100
resource_2_usage_a = 4
resource_2_usage_b = 2
resource_2_avail = 80

problem += (resource_1_usage_a * product_a) + (resource_1_usage_b * product_b) <= resource_1_avail
problem += (resource_2_usage_a * product_a) + (resource_2_usage_b * product_b) <= resource_2_avail

# Define production capacity constraints
max_units_product_a = 20
max_units_product_b = 30

problem += product_a <= max_units_product_a
problem += product_b <= max_units_product_b

# Solve the problem
problem.solve()

# Print the results
print(f"Product A units to produce: {product_a.varValue}")
print(f"Product B units to produce: {product_b.varValue}")
print(f"Total Profit: ${problem.objective.value()}")