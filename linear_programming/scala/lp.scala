import org.apache.commons.math3.optim.linear._
import org.apache.commons.math3.optim.nonlinear.scalar.GoalType
import org.apache.commons.math3.optim.OptimizationData
import org.apache.commons.math3.optim.PointValuePair

object LinearProgrammingExample extends App {
  // Objective function coefficients
  val c: Array[Double] = Array(10.0, 15.0)

  // Constraint matrix A
  val A: Array[Array[Double]] = Array(
    Array(2.0, 3.0),
    Array(4.0, 2.0),
    Array(1.0, 0.0)
  )

  // Constraint right-hand side
  val b: Array[Double] = Array(100.0, 80.0, 20.0)

  // Create a linear objective function
  val objectiveFunction = new LinearObjectiveFunction(c, 0.0)

  // Create linear constraints
  val constraints = new LinearConstraintSet(A, Relationship.LEQ, b)

  // Create a linear programming problem
  val problem = new OptimizationProblem(objectiveFunction, constraints, GoalType.MAXIMIZE)

  // Solve the linear programming problem
  val solver = new SimplexSolver
  val solution: PointValuePair = solver.optimize(problem)

  // Get the optimal values of the decision variables
  val optimalValues: Array[Double] = solution.getPoint

  // Calculate the total profit
  val totalProfit: Double = -solution.getValue

  // Print the results
  println(s"Product A units to produce: ${optimalValues(0)}")
  println(s"Product B units to produce: ${optimalValues(1)}")
  println(s"Total Profit: $$$totalProfit")
}
