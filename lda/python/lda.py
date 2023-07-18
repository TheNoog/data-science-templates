import numpy as np
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis

# Load the data
data = np.loadtxt("data.csv", delimiter=",")

# Split the data into features and labels
X = data[:, :-1]
y = data[:, -1]

# Create the LDA model
lda = LinearDiscriminantAnalysis(n_components=2)

# Fit the model to the data
lda.fit(X, y)

# Print the discriminant function
print(lda.coef_)

# Print the class means
print(lda.means_)
