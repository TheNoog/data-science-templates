struct RNN {
  input_dim: usize,
  hidden_dim: usize,
  output_dim: usize,

  weights: [usize; input_dim]<[usize; hidden_dim]f32],
  biases: [usize; hidden_dim]f32,

  h: [usize; hidden_dim]f32,
}

impl RNN {
  fn new(input_dim: usize, hidden_dim: usize, output_dim: usize) -> Self {
    Self {
      input_dim,
      hidden_dim,
      output_dim,

      weights: [
        [
          rand::random() - 0.5; hidden_dim
        ]
        for _ in 0..input_dim
      ],
      biases: [rand::random() - 0.5; hidden_dim],

      h: [0.0; hidden_dim],
    }
  }

  fn train(&mut self, data: &[[f32]]) {
    for sequence in data {
      for t in sequence {
        let mut z = 0.0;
        for i in 0..self.input_dim {
          z += t[i] * self.weights[i][self.h.len()];
        }
        self.h.push(tanh(z + self.biases[self.h.len()]));
      }
    }
  }

  fn predict(&mut self, data: &[f32]) -> [f32] {
    let mut predictions = [];
    self.h = [0.0; self.hidden_dim];
    for t in data {
      let mut z = 0.0;
      for i in 0..self.input_dim {
        z += t[i] * self.weights[i][self.h.len()];
      }
      self.h.push(tanh(z + self.biases[self.h.len()]));
      predictions.push(self.h[self.h.len() - 1]);
    }
    return predictions;
  }
}
