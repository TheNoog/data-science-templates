use std::f64;

struct LogisticRegression {
  weights: Vec<f64>,
  bias: f64,
}

impl LogisticRegression {
  fn new(feature_count: usize) -> Self {
    Self {
      weights: vec![0.0; feature_count],
      bias: 0.0,
    }
  }

  fn train(&mut self, features: &[f64], label: f64) {
    let prediction = self.sigmoid(self.dot(features));
    let error = label - prediction;

    for i in 0..self.weights.len() {
      self.weights[i] += error * features[i];
    }
    self.bias += error;
  }

  fn sigmoid(&self, x: f64) -> f64 {
    1.0 / (1.0 + f64::exp(-x))
  }

  fn dot(&self, features: &[f64]) -> f64 {
    let mut sum = 0.0;
    for i in 0..features.len() {
      sum += self.weights[i] * features[i];
    }
    sum
  }

  fn predict(&self, features: &[f64]) -> bool {
    self.sigmoid(self.dot(features)) > 0.5
  }
}

fn main() {
  let features = [1.0, 2.0];
  let label = 1.0;

  let mut model = LogisticRegression::new(2);

  for _ in 0..100 {
    model.train(features, label);
  }

  let new_features = [3.0, 4.0];
  let new_label = model.predict(new_features);

  println!("The predicted label is {}", new_label);
}

fn main() {
  let features = [1.0, 2.0];
  let label = 1.0;

  let mut model = LogisticRegression::new(2);

  for _ in 0..100 {
    model.train(features, label);
  }

  let new_features = [3.0, 4.0];
  let new_label = model.predict(new_features);

  println!("The predicted label is {}", new_label);
}
