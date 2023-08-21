package main

import (
	"fmt"
	"math"

	"github.com/gonum/matrix/mat64"
	"github.com/gonum/optimize"
)

func main() {
	// Objective coefficients
	c := mat64.NewDense(1, 2, []float64{10, 15})

	// Constraint matrix
	A := mat64.NewDense(3, 2, []float64{
		2, 3,
		4, 2,
		1, 0,
	})

	// Constraint bounds
	b := mat64.NewDense(3, 1, []float64{100, 80, 20})

	// Variables upper bounds
	ub := mat64.NewDense(2, 1, []float64{math.Inf(1), math.Inf(1)})

	// Create the linear programming problem
	lp := optimize.Problem{
		Func: func(x []float64) float64 {
			obj := mat64.NewDense(1, 2, x)
			var result mat64.Dense
			result.Mul(obj, c.T())
			return result.At(0, 0)
		},
		Grad: func(grad, x []float64) {
			copy(grad, c.RawRowView(0))
		},
		Constraints: []optimize.Constraint{
			{
				F: func(x []float64) float64 {
					var result mat64.Dense
					var xVec mat64.Dense
					xVec.SetRawMatrix(mat64.NewDense(2, 1, x))
					result.Mul(A, &xVec)
					return b.At(0, 0) - result.At(0, 0)
				},
				Grad: func(grad, x []float64) {
					copy(grad, A.RawRowView(0))
				},
				Lower: -math.Inf(1),
			},
			{
				F: func(x []float64) float64 {
					var result mat64.Dense
					var xVec mat64.Dense
					xVec.SetRawMatrix(mat64.NewDense(2, 1, x))
					result.Mul(A, &xVec)
					return b.At(1, 0) - result.At(0, 0)
				},
				Grad: func(grad, x []float64) {
					copy(grad, A.RawRowView(1))
				},
				Lower: -math.Inf(1),
			},
			{
				F: func(x []float64) float64 {
					return b.At(2, 0) - x[0]
				},
				Grad: func(grad, x []float64) {
					grad[0] = -1
				},
				Lower: -math.Inf(1),
			},
		},
	}

	// Solve the linear programming problem
	result, err := optimize.Local(lp, nil, nil, nil)
	if err != nil {
		fmt.Println("Optimization error:", err)
		return
	}

	// Print the results
	fmt.Printf("Product A units to produce: %.2f\n", result.X[0])
	fmt.Printf("Product B units to produce: %.2f\n", result.X[1])
	fmt.Printf("Total Profit: $%.2f\n", -result.F)
}
