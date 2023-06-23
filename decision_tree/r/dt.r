library(caret)
library(rpart)
library(rpart.plot)

# Load the dataset (Iris dataset as an example)
data(iris)

# Split the dataset into training and testing sets
set.seed(42)
train_indices <- createDataPartition(iris$Species, p = 0.8, list = FALSE)
train_data <- iris[train_indices, ]
test_data <- iris[-train_indices, ]

# Create a decision tree classifier
classifier <- rpart(Species ~ ., data = train_data)

# Visualize the decision tree
rpart.plot(classifier)

# Make predictions on the test data
y_pred <- predict(classifier, newdata = test_data, type = "class")

# Calculate the accuracy of the model
accuracy <- sum(y_pred == test_data$Species) / length(test_data$Species)
print(paste("Accuracy:", accuracy))
