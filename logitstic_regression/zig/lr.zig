const
  featuresCount = 2
;

struct LogisticRegression {
  weights: [featuresCount]f32,
  bias: f32,
}

impl LogisticRegression {
  fn new() -> LogisticRegression {
    LogisticRegression {
      weights: [0.0; featuresCount],
      bias: 0.0,
    }
  }

  fn train(&mut self, features: [f32; featuresCount], label: f32) {
    let prediction = self.sigmoid(self.dot(features));
    let error = label - prediction;

    for i in 0 .. featuresCount {
      self.weights[i] += error * features[i];
    }
    self.bias += error;
  }

  fn sigmoid(self, x: f32) -> f32 {
    1.0 / (1.0 + exp(-x))
  }

  fn dot(self, features: [f32; featuresCount]) -> f32 {
    var sum = 0.0;
    for i in 0 .. featuresCount {
      sum += self.weights[i] * features[i];
    }

    sum
  }

  fn predict(&self, features: [f32; featuresCount]) -> i32 {
    if self.sigmoid(self.dot(features)) > 0.5 {
      1
    } else {
      0
    }
  }
}

pub fn main() {
  let features = [1.0, 2.0];
  let label = 1.0;

  let mut model = LogisticRegression::new();

  for _ in 0 .. 100 {
    model.train(features, label);
  }

  let newFeatures = [3.0, 4.0];
  let newLabel = model.predict(newFeatures);

  println!("The predicted label is {}", newLabel);
}
