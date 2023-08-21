using System;
using MathNet.Numerics.LinearAlgebra;
using MathNet.Numerics.Optimization;
using MathNet.Numerics.LinearAlgebra.Double;

class Program
{
    static void Main()
    {
        // Define the objective coefficients
        Vector<double> objectiveCoefficients = DenseVector.OfArray(new double[] { 10.0, 15.0 });

        // Define the constraint matrix
        Matrix<double> constraintMatrix = DenseMatrix.OfArray(new double[,]
        {
            { 2.0, 3.0 },
            { 4.0, 2.0 },
            { 1.0, 0.0 }
        });

        // Define the constraint upper bounds
        Vector<double> constraintBounds = DenseVector.OfArray(new double[] { 100.0, 80.0, 20.0 });

        // Define the constraint types
        Vector<ConstraintType> constraintTypes = DenseVector.OfArray(new ConstraintType[]
        {
            ConstraintType.LessThanOrEqual,
            ConstraintType.LessThanOrEqual,
            ConstraintType.LessThanOrEqual
        });

        // Create a linear programming problem
        var problem = new LinearProgram(objectiveCoefficients, constraintMatrix, constraintBounds, constraintTypes);

        // Solve the linear programming problem
        var solver = new CeresSolver();
        var solution = solver.FindMinimum(problem);

        // Print the results
        Console.WriteLine("Product A units to produce: " + solution.MinimizingPoint[0]);
        Console.WriteLine("Product B units to produce: " + solution.MinimizingPoint[1]);
        Console.WriteLine("Total Profit: $" + (-solution.FunctionInfoAtMinimum.Value));
    }
}
