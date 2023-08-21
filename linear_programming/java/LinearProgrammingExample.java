import org.apache.commons.math3.optim.*;
import org.apache.commons.math3.optim.linear.*;
import org.apache.commons.math3.optim.nonlinear.scalar.GoalType;
import org.apache.commons.math3.optim.nonlinear.scalar.ObjectiveFunction;
import org.apache.commons.math3.optim.nonlinear.scalar.ObjectiveFunctionGradient;

public class LinearProgrammingExample {
    public static void main(String[] args) {
        // Objective function coefficients
        double[] c = {10.0, 15.0};

        // Constraint matrix A
        double[][] A = {
            {2.0, 3.0},
            {4.0, 2.0},
            {1.0, 0.0}
        };

        // Constraint right-hand side
        double[] b = {100.0, 80.0, 20.0};

        // Variable bounds
        double[] lb = {0.0, 0.0};

        // Create the objective function
        LinearObjectiveFunction objectiveFunction = new LinearObjectiveFunction(c, 0);

        // Create linear constraints
        LinearConstraintSet constraints = new LinearConstraintSet(A, Relationship.LEQ, b);

        // Create the optimization problem
        OptimizationProblem problem = new OptimizationProblem(
            objectiveFunction,
            constraints,
            GoalType.MAXIMIZE,
            new NonNegativeConstraint(true)
        );

        // Create and configure the optimizer
        SimplexSolver optimizer = new SimplexSolver(1e-6, 100);

        // Solve the linear programming problem
        PointValuePair solution = optimizer.optimize(problem);

        // Get the results
        double[] optimalPoint = solution.getPoint();
        double totalProfit = -solution.getValue();

        // Print the results
        System.out.println("Product A units to produce: " + optimalPoint[0]);
        System.out.println("Product B units to produce: " + optimalPoint[1]);
        System.out.println("Total Profit: $" + totalProfit);
    }
}
