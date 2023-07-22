import std/math/linalg/vector;

struct SVM {
    weight: vec2,
    bias: f32,
}

impl SVM {
    fn new(c: f32, kernel: &str) -> SVM {
        SVM {
            weight: vec2(0.0, 0.0),
            bias: 0.0,
        }
    }

    fn fit(&mut self, x: []const vec2, y: []const i32, n: usize) {
        for _ in 0..n {
            let score = self.weight * x[0] + self.bias;
            if y[0] * score <= 1.0 {
                for i in 0..2 {
                    self.weight[i] += c * y[0] * x[0][i];
                }
                self.bias += c * y[0];
            }
        }
    }

    fn predict(&self, x: vec2) -> i32 {
        let score = self.weight * x + self.bias;
        if score >= 0.0 { 1 } else { -1 }
    }
}

pub fn main() {
    let svm = SVM::new(1.0, "linear");
    svm.fit(
        &[vec2(1.0, 2.0), vec2(3.0, 4.0)],
        &[1, -1],
        2,
    );
    assert(svm.predict(vec2(5.0, 6.0)) == 1);
}
