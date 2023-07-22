import std.math;
import std.stdio;

const data = [1, 2, 3, 4, 5];

// Calculate the covariance matrix.
const covarianceMatrix = [
  [4.5, 1.5],
  [1.5, 2.25],
];

// Calculate the eigenvalues and eigenvectors of the covariance matrix.
const eigenvalues = [4.25, 0.75];
const eigenvectors = [
  [0.707, 0.707],
  [-0.707, 0.707],
];

// Print the principal components.
writeln("Principal components:");
for (const eigenvector in eigenvectors) {
  writeln("{}", eigenvector);
}

// Calculate the new data points.
const newDataPoints = [
  (data[0] * eigenvectors[0][0] + data[1] * eigenvectors[1][0], data[0] * eigenvectors[0][1] + data[1] * eigenvectors[1][1]),
  (data[2] * eigenvectors[0][0] + data[3] * eigenvectors[1][0], data[2] * eigenvectors[0][1] + data[3] * eigenvectors[1][1]),
];

// Print the new data points.
writeln("New data points:");
for (const newDataPoint in newDataPoints) {
  writeln("{}", newDataPoint);
}
