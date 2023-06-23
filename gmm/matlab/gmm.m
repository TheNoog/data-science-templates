rng('default');  % Set the random number generator seed for reproducibility

NSamples = 500;
NComponents = 2;

% Generate data from the first Gaussian distribution
data1 = mvnrnd([0 0], [1 0; 0 1], NSamples/2);

% Generate data from the second Gaussian distribution
data2 = mvnrnd([3 3], [1 0; 0 1], NSamples/2);

% Combine the data from both distributions
data = [data1; data2];

% Fit the Gaussian Mixture Model
gmm = fitgmdist(data, NComponents);

% Retrieve the GMM parameters
weights = gmm.ComponentProportion;
means = gmm.mu;
covariances = gmm.Sigma;

% Print the results
disp('Weights:');
disp(weights);

disp('Means:');
disp(means);

disp('Covariances:');
for i = 1:NComponents
    disp(covariances(:, :, i));
end
