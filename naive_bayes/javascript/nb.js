class DataPoint {
    constructor(features, label) {
      this.features = features;
      this.label = label;
    }
  }
  
  class Dataset {
    constructor(data) {
      this.data = data;
    }
  }
  
  function loadDataset() {
    // Load the dataset
    const data = [];
  
    // Your code to load the data from a file or any other source goes here
    // Push each data point as a DataPoint object to the data array
  
    return new Dataset(data);
  }
  
  function trainNaiveBayes(dataset) {
    const numDataPoints = dataset.data.length;
    const numClasses = 3; // Number of classes in your dataset
    const numFeatures = 4; // Number of features in your dataset
  
    const classCounts = Array(numClasses).fill(0);
    const priors = Array(numClasses).fill(0);
    const likelihoods = Array(numClasses)
      .fill()
      .map(() => Array(numFeatures).fill(0));
  
    // Count the occurrences of each class label
    dataset.data.forEach((dataPoint) => {
      classCounts[dataPoint.label]++;
    });
  
    // Calculate priors
    for (let i = 0; i < numClasses; i++) {
      priors[i] = classCounts[i] / numDataPoints;
    }
  
    // Calculate likelihoods
    for (let i = 0; i < numClasses; i++) {
      for (let j = 0; j < numFeatures; j++) {
        let featureSum = 0.0;
        let featureCount = 0;
  
        // Sum the values of the feature for the current class
        dataset.data.forEach((dataPoint) => {
          if (dataPoint.label === i) {
            featureSum += dataPoint.features[j];
            featureCount++;
          }
        });
  
        // Calculate the average of the feature for the current class
        likelihoods[i][j] = featureSum / featureCount;
      }
    }
  
    return { priors, likelihoods };
  }
  
  function predict(dataPoint, priors, likelihoods) {
    const numClasses = priors.length;
    const numFeatures = likelihoods[0].length;
    let maxPosterior = 0.0;
    let predictedClass = -1;
  
    // Calculate the posterior probability for each class
    for (let i = 0; i < numClasses; i++) {
      let posterior = priors[i];
  
      for (let j = 0; j < numFeatures; j++) {
        posterior *= Math.exp(
          -Math.pow(dataPoint.features[j] - likelihoods[i][j], 2) / 2
        );
      }
  
      // Update the predicted class if the posterior is higher than the current maximum
      if (posterior > maxPosterior) {
        maxPosterior = posterior;
        predictedClass = i;
      }
    }
  
    return predictedClass;
  }
  
  // Main program
  const dataset = loadDataset();
  const { priors, likelihoods } = trainNaiveBayes(dataset);
  
  // Example usage: Predict the class label for a new data point
  const newDataPoint = new DataPoint([5.1, 3.5, 1.4, 0.2], 0);
  
  const predictedLabel = predict(newDataPoint, priors, likelihoods);
  console.log("Predicted Label:", predictedLabel);
  