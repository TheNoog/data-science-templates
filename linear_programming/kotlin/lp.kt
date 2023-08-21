import org.apache.commons.math3.optim.linear.LinearConstraintSet
import org.apache.commons.math3.optim.linear.LinearObjectiveFunction
import org.apache.commons.math3.optim.linear.Relationship
import org.apache.commons.math3.optim.nonlinear.scalar.GoalType
import org.apache.commons.math3.optim.nonlinear.scalar.ObjectiveFunction
import org.apache.commons.math3.optim.nonlinear.scalar.ObjectiveFunctionGradient
import org.apache.commons.math3.optim.nonlinear.scalar.noderiv.SimplexOptimizer
import org.apache.commons.math3.optim.nonlinear.scalar.noderiv.CMAESOptimizer
import org.apache.commons.math3.optim.nonlinear.scalar.noderiv.BOBYQAOptimizer
import org.apache.commons.math3.optim.nonlinear.scalar.noderiv.PowellOptimizer
import org.apache.commons.math3.optim.nonlinear.scalar.noderiv.NelderMeadSimplex
import org.apache.commons.math3.optim.nonlinear.scalar.GoalType
import org.apache.commons.math3.optim.PointValuePair

fun main() {
    // Objective function coefficients
    val c = doubleArrayOf(10.0, 15.0)

    // Constraint matrix A
    val A = arrayOf(
        doubleArrayOf(2.0, 3.0),
        doubleArrayOf(4.0, 2.0),
        doubleArrayOf(1.0, 0.0)
    )

    // Constraint right-hand side
    val b = doubleArrayOf(100.0, 80.0, 20.0)

    // Create a linear objective function
    val objectiveFunction = LinearObjectiveFunction(c, 0.0)

    // Create linear constraints
    val constraints = LinearConstraintSet(A, Relationship.LEQ, b)

    // Create a simplex optimizer
    val optimizer = SimplexOptimizer(1e-6, 100)

    // Create the optimization problem
    val problem = org.apache.commons.math3.optim.OptimizationProblem(
        objectiveFunction,
        constraints,
        GoalType.MAXIMIZE,
        org.apache.commons.math3.optim.nonlinear.scalar.Constraint(0, 0)
    )

    // Solve the linear programming problem
    val solution = optimizer.optimize(problem)

    // Get the optimal values of the decision variables
    val optimalValues = solution.point

    // Calculate the total profit
    val totalProfit = -(solution.value)

    // Print the results
    println("Product A units to produce: ${optimalValues[0]}")
    println("Product B units to produce: ${optimalValues[1]}")
    println("Total Profit: $$totalProfit")
}
