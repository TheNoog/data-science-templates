import numpy as np
import matplotlib.pyplot as plt
from sklearn.mixture import GaussianMixture

# Generate some random data from two Gaussian distributions
np.random.seed(0)
n_samples = 500

# Generate data from the first Gaussian distribution
mean1 = [0, 0]
cov1 = [[1, 0], [0, 1]]
data1 = np.random.multivariate_normal(mean1, cov1, int(n_samples/2))

# Generate data from the second Gaussian distribution
mean2 = [3, 3]
cov2 = [[1, 0], [0, 1]]
data2 = np.random.multivariate_normal(mean2, cov2, int(n_samples/2))

# Combine the data from both distributions
data = np.vstack((data1, data2))

# Fit the Gaussian Mixture Model
n_components = 2  # Number of Gaussian components to fit
gmm = GaussianMixture(n_components=n_components)
gmm.fit(data)

# Generate new samples from the learned model
new_samples = gmm.sample(100)[0]

# Plot the original data and the generated samples
plt.scatter(data[:, 0], data[:, 1], label='Original Data')
plt.scatter(new_samples[:, 0], new_samples[:, 1], label='Generated Samples')
plt.legend()
plt.title('Gaussian Mixture Model')
plt.show()
