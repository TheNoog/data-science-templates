extern crate ndarray;
use ndarray::prelude::*;

struct NeuralNetwork {
    weights1: Array2<f64>,
    weights2: Array2<f64>,
    biases1: Array1<f64>,
    biases2: Array1<f64>,
    learning_rate: f64,
}

impl NeuralNetwork {
    fn new(input_size: usize, hidden_size: usize, output_size: usize, learning_rate: f64) -> Self {
        NeuralNetwork {
            weights1: Array2::random((input_size, hidden_size)),
            weights2: Array2::random((hidden_size, output_size)),
            biases1: Array1::random(hidden_size),
            biases2: Array1::random(output_size),
            learning_rate,
        }
    }

    fn activation(&self, x: f64) -> f64 {
        1.0 / (1.0 + (-x).exp())
    }

    fn derivative(&self, x: f64) -> f64 {
        let activation = self.activation(x);
        activation * (1.0 - activation)
    }

    fn train(&mut self, x: &Array2<f64>, y: &Array2<f64>, epochs: usize) {
        for _ in 0..epochs {
            // Forward pass
            let hidden_layer = x.dot(&self.weights1) + &self.biases1;
            let hidden_layer = hidden_layer.mapv(|x| self.activation(x));
            let output_layer = hidden_layer.dot(&self.weights2) + &self.biases2;
            let output_layer = output_layer.mapv(|x| self.activation(x));

            // Backpropagation
            let output_error = y - &output_layer;
            let output_delta = output_layer.mapv(|x| self.derivative(x));
            let output_error_delta = &output_error * &output_delta;

            let hidden_error = output_error_delta.dot(&self.weights2.t());
            let hidden_delta = hidden_layer.mapv(|x| self.derivative(x));
            let hidden_error_delta = &hidden_error * &hidden_delta;

            // Weight and bias adjustments
            let hidden_adjustment = x.t().dot(&hidden_error_delta);
            let output_adjustment = hidden_layer.t().dot(&output_error_delta);

            self.weights1 += &hidden_adjustment * self.learning_rate;
            self.weights2 += &output_adjustment * self.learning_rate;

            self.biases1 += &hidden_error_delta.sum_axis(Axis(0)) * self.learning_rate;
            self.biases2 += &output_error_delta.sum_axis(Axis(0)) * self.learning_rate;
        }
    }

    fn predict(&self, x: &Array2<f64>) -> Array2<f64> {
        let hidden_layer = x.dot(&self.weights1) + &self.biases1;
        let hidden_layer = hidden_layer.mapv(|x| self.activation(x));
        let output_layer = hidden_layer.dot(&self.weights2) + &self.biases2;
        output_layer.mapv(|x| self.activation(x))
    }
}

fn main() {
    let x = array![[0., 0.], [0., 1.], [1., 0.], [1., 1.]];
    let y = array![[0.], [1.], [1.], [0.]];

    let mut nn = NeuralNetwork::new(2, 4, 1, 0.1);
    let epochs = 1000;
    nn.train(&x, &y, epochs);

    let predictions = nn.predict(&x);
    println!("Predicted Output:");
    println!("{:?}", predictions);
}
