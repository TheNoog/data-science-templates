const GMM = require('gmmjs');

const NSamples = 500;
const NComponents = 2;

// Generate data from the first Gaussian distribution
const data1 = generateData([0, 0], [[1, 0], [0, 1]], NSamples / 2);

// Generate data from the second Gaussian distribution
const data2 = generateData([3, 3], [[1, 0], [0, 1]], NSamples / 2);

// Combine the data from both distributions
const data = data1.concat(data2);

// Fit the Gaussian Mixture Model
const gmm = new GMM();
gmm.train(data, NComponents);

// Retrieve the GMM parameters
const weights = gmm.weights();
const means = gmm.means();
const covariances = gmm.covariances();

// Print the results
console.log('Weights:');
console.log(weights.join(' '));

console.log('\nMeans:');
means.forEach((mean) => {
  console.log(mean.join(' '));
});

console.log('\nCovariances:');
covariances.forEach((cov) => {
  console.log(cov[0][0] + ' ' + cov[0][1]);
});

function generateData(mean, cov, n) {
  const samples = [];
  const mvn = new GMM.MultivariateNormal(mean, cov);
  for (let i = 0; i < n; i++) {
    samples.push(mvn.sample());
  }
  return samples;
}
