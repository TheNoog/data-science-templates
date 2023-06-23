library(xgboost)

# Load the training and testing data
trainData <- read.csv("train.csv")
testData <- read.csv("test.csv")

# Separate the features (X) and labels (y)
X_train <- trainData[, 2:ncol(trainData)]
y_train <- trainData[, 1]
X_test <- testData[, 2:ncol(testData)]
y_test <- testData[, 1]

# Set the parameters for the XGBoost model
params <- list(
  objective = "reg:squarederror",
  max_depth = 3,
  eta = 0.1,
  subsample = 0.8,
  colsample_bytree = 0.8
)

# Train the model
numRounds <- 100
model <- xgboost(data = as.matrix(X_train), label = y_train, params = params, nrounds = numRounds)

# Make predictions on the test data
predictions <- predict(model, as.matrix(X_test))

# Evaluate the model
rmse <- sqrt(mean((y_test - predictions)^2))
cat("RMSE:", rmse, "\n")
