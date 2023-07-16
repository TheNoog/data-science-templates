using Random

# Define the number of samples and features
const N_SAMPLES = 100
const N_FEATURES = 20

# Function to calculate the mean squared error
function calculateMeanSquaredError(yTrue, yPred)
    n = length(yTrue)
    mse = sum((yTrue .- yPred) .^ 2) / n
    return mse
end

# Function to perform LASSO regression
function lassoRegression(X, y, coefficients, alpha)
    # Maximum number of iterations for coordinate descent
    maxIterations = 100
    
    # Step size for coordinate descent
    stepSize = 0.01

    nSamples = size(X, 1)
    nFeatures = size(X, 2)

    # Initialize the coefficients to zero
    fill!(coefficients, 0.0)

    # Perform coordinate descent
    for iteration in 1:maxIterations
        for j in 1:nFeatures
            # Calculate the gradient for feature j
            gradient = 0.0
            for i in 1:nSamples
                pred = dot(view(X, i, :), view(coefficients, :)) - X[i, j] * coefficients[j]
                gradient += (y[i] - pred) * X[i, j]
            end

            # Update the coefficient using LASSO penalty
            if gradient > alpha
                coefficients[j] = (gradient - alpha) * stepSize
            elseif gradient < -alpha
                coefficients[j] = (gradient + alpha) * stepSize
            else
                coefficients[j] = 0.0
            end
        end
    end
end

# Generate some synthetic data
function generateSyntheticData()
    X = rand(N_SAMPLES, N_FEATURES)
    y = zeros(N_SAMPLES)

    rng = Random.MersenneTwister(42) # Use a random seed for reproducibility

    for i in 1:N_SAMPLES
        y[i] = dot(X[i, :], 1:N_FEATURES) + 0.1 * rand(rng)
    end

    return X, y
end

# Main function
function main()
    # Generate some synthetic data
    X, y = generateSyntheticData()

    # Split the data into training and test sets
    nTrainSamples = Int(round(N_SAMPLES * 0.8))
    nTestSamples = N_SAMPLES - nTrainSamples
    XTrain = X[1:nTrainSamples, :]
    yTrain = y[1:nTrainSamples]
    XTest = X[nTrainSamples+1:end, :]
    yTest = y[nTrainSamples+1:end]

    # Perform LASSO regression
    alpha = 0.1
    coefficients = zeros(N_FEATURES)
    lassoRegression(XTrain, yTrain, coefficients, alpha)

    # Make predictions on the test set
    yPred = [dot(XTest[i, :], coefficients) for i in 1:nTestSamples]

    # Calculate the mean squared error
    mse = calculateMeanSquaredError(yTest, yPred)
    println("Mean Squared Error: ", mse)

    # Print the true coefficients and the estimated coefficients
    println("True Coefficients: [1.0 ", join([string(i+1) for i in 1:N_FEATURES-1], " "), "]")
    println("Estimated Coefficients: ", coefficients)
end

main()
