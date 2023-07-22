const LogisticRegression = function (featureCount) {
    this.weights = new Array(featureCount);
    this.bias = 0;
  };
  
  LogisticRegression.prototype.train = function (features, label) {
    const prediction = this.sigmoid(this.dot(features));
    const error = label - prediction;
  
    for (let i = 0; i < featureCount; i++) {
      this.weights[i] += error * features[i];
    }
    this.bias += error;
  };
  
  LogisticRegression.prototype.sigmoid = function (x) {
    return 1.0 / (1.0 + Math.exp(-x));
  };
  
  LogisticRegression.prototype.dot = function (features) {
    let sum = 0;
  
    for (let i = 0; i < featureCount; i++) {
      sum += features[i] * this.weights[i];
    }
  
    return sum;
  };
  
  LogisticRegression.prototype.predict = function (features) {
    return this.sigmoid(this.dot(features)) > 0.5;
  };
  
  function main() {
    const features = [1.0, 2.0];
    const label = 1;
  
    const model = new LogisticRegression(2);
  
    for (let i = 0; i < 100; i++) {
      model.train(features, label);
    }
  
    const newFeatures = [3.0, 4.0];
    const newLabel = model.predict(newFeatures);
  
    console.log("The predicted label is", newLabel);
  }
  
  main();
  