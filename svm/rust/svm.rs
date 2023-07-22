use std::f32;

struct SVM {
    weight: Vec<f32>,
    bias: f32,
}

impl SVM {
    fn new(c: f32, kernel: &str) -> SVM {
        SVM {
            weight: vec![0.0; 2],
            bias: 0.0,
        }
    }

    fn fit(&mut self, x: &[Vec<f32>], y: &[i32], n: usize) {
        for _ in 0..n {
            let score = self.weight.dot(&x[0]) + self.bias;
            if y[0] * score <= 1.0 {
                for i in 0..2 {
                    self.weight[i] += c * y[0] * x[0][i];
                }
                self.bias += c * y[0];
            }
        }
    }

    fn predict(&self, x: Vec<f32>) -> i32 {
        let score = self.weight.dot(&x) + self.bias;
        if score >= 0.0 { 1 } else { -1 }
    }
}

fn main() {
    let svm = SVM::new(1.0, "linear");
    svm.fit(&[[1.0, 2.0], [3.0, 4.0]], &[1, -1], 2);
    println!("{}", svm.predict([5.0, 6.0])); // prints 1
}
