using XGBoost, CSV

# Load the training and testing data
trainData = CSV.File("train.csv") |> DataFrame
testData = CSV.File("test.csv") |> DataFrame

# Convert data to DMatrix format
trainMatrix = DMatrix(convert(Matrix, trainData[2:end]))
testMatrix = DMatrix(convert(Matrix, testData[2:end]))

# Set the parameters for the XGBoost model
params = Dict(
    "objective" => "reg:squarederror",
    "max_depth" => 3,
    "eta" => 0.1,
    "subsample" => 0.8,
    "colsample_bytree" => 0.8
)

# Train the model
numRounds = 100
booster = xgboost(trainMatrix, num_round=numRounds, params=params)

# Make predictions on the test data
predictions = predict(booster, testMatrix)

# Evaluate the model
labels = testMatrix.labels
sumSquaredError = sum((labels .- predictions) .^ 2)
rmse = sqrt(sumSquaredError / length(labels))
println("RMSE: ", rmse)
