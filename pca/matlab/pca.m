clear all;
clc;

% Load the data.
data = [1, 2, 3, 4, 5];

% Standardize the data.
mean = sum(data) / length(data);
std = sqrt(sum((data - mean) .^ 2) / length(data));
for i = 1:length(data)
    data(i) = (data(i) - mean) / std;
end

% Calculate the covariance matrix.
cov = (data' * data) / (length(data) - 1);

% Calculate the eigenvalues and eigenvectors of the covariance matrix.
[eigs, vecs] = eig(cov);

% Sort the eigenvalues and eigenvectors in descending order.
[eigs, vecs] = sort(eigs, 'descend');

% Return the principal components.
principalComponents = vecs(:, 1:size(eigs, 1));

% Print the principal components.
disp(principalComponents);
