use std::collections::Vec;

struct RNN {
    input_dim: usize,
    hidden_dim: usize,
    output_dim: usize,

    weights: Vec<Vec<f64>>,
    biases: Vec<f64>,

    h: Vec<f64>,
}

impl RNN {
    pub fn new(input_dim: usize, hidden_dim: usize, output_dim: usize) -> Self {
        Self {
            input_dim,
            hidden_dim,
            output_dim,

            weights: vec![vec![rand::random() - 0.5; hidden_dim]; input_dim],
            biases: vec![rand::random() - 0.5; hidden_dim],

            h: vec![0.0; hidden_dim],
        }
    }

    pub fn train(&mut self, data: &Vec<Vec<f64>>) {
        for sequence in data {
            for t in sequence {
                let mut z = 0.0;
                for i in 0..input_dim {
                    z += t[i] * self.weights[i][self.h.len()];
                }
                self.h.push(tanh(z + self.biases[self.h.len()]));
            }
        }
    }

    pub fn predict(&mut self, data: &Vec<f64>) -> Vec<f64> {
        let mut predictions = Vec::new();
        self.h = vec![0.0; self.hidden_dim];
        for t in data {
            let mut z = 0.0;
            for i in 0..input_dim {
                z += t[i] * self.weights[i][self.h.len()];
            }
            self.h.push(tanh(z + self.biases[self.h.len()]));
            predictions.push(self.h[self.h.len() - 1]);
        }
        return predictions;
    }
}
