class SVM {

    constructor(C, kernel) {
      this.C = C;
      this.kernel = kernel;
      this.w = [0, 0];
      this.b = 0;
    }
  
    fit(X, y, n) {
      for (let i = 0; i < n; i++) {
        let score = 0;
        for (let j = 0; j < 2; j++) {
          score += this.w[j] * X[i][j];
        }
        if (y[i] * score + this.b <= 1) {
          for (let j = 0; j < 2; j++) {
            this.w[j] += this.C * y[i] * X[i][j];
          }
          this.b += this.C * y[i];
        }
      }
    }
  
    predict(X) {
      let score = 0;
      for (let j = 0; j < 2; j++) {
        score += this.w[j] * X[j];
      }
      return score >= 0 ? 1 : -1;
    }
  
  }
  
  const svm = new SVM(1.0, "linear");
  svm.fit([[1, 2], [3, 4]], [1, -1], 2);
  console.log(svm.predict([5, 6])); // 1
  