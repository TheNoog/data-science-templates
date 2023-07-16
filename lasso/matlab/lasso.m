% Define the number of samples and features
N_SAMPLES = 100;
N_FEATURES = 20;

% Function to calculate the mean squared error
function mse = calculateMeanSquaredError(yTrue, yPred)
    n = length(yTrue);
    mse = sum((yTrue - yPred) .^ 2) / n;
end

% Function to perform LASSO regression
function lassoRegression(X, y, alpha)
    % Maximum number of iterations for coordinate descent
    maxIterations = 100;
    
    % Step size for coordinate descent
    stepSize = 0.01;

    [nSamples, nFeatures] = size(X);

    % Initialize the coefficients to zero
    coefficients = zeros(nFeatures, 1);

    % Perform coordinate descent
    for iteration = 1:maxIterations
        for j = 1:nFeatures
            % Calculate the gradient for feature j
            gradient = 0;
            for i = 1:nSamples
                pred = X(i, :) * coefficients - X(i, j) * coefficients(j);
                gradient = gradient + (y(i) - pred) * X(i, j);
            end

            % Update the coefficient using LASSO penalty
            if gradient > alpha
                coefficients(j) = (gradient - alpha) * stepSize;
            elseif gradient < -alpha
                coefficients(j) = (gradient + alpha) * stepSize;
            else
                coefficients(j) = 0;
            end
        end
    end

    lassoCoefficients = coefficients;
end

% Generate some synthetic data
function [X, y] = generateSyntheticData()
    X = rand(N_SAMPLES, N_FEATURES);
    y = zeros(N_SAMPLES, 1);

    rng = RandStream('mt19937ar', 'Seed', 42); % Use a random seed for reproducibility
    RandStream.setGlobalStream(rng);

    for i = 1:N_SAMPLES
        y(i) = X(i, :) * (1:N_FEATURES)' + 0.1 * rand();
    end
end

% Main function
function main()
    % Generate some synthetic data
    [X, y] = generateSyntheticData();

    % Split the data into training and test sets
    nTrainSamples = round(N_SAMPLES * 0.8);
    nTestSamples = N_SAMPLES - nTrainSamples;
    XTrain = X(1:nTrainSamples, :);
    yTrain = y(1:nTrainSamples);
    XTest = X(nTrainSamples+1:end, :);
    yTest = y(nTrainSamples+1:end);

    % Perform LASSO regression
    alpha = 0.1;
    coefficients = lassoRegression(XTrain, yTrain, alpha);

    % Make predictions on the test set
    yPred = XTest * coefficients;

    % Calculate the mean squared error
    mse = calculateMeanSquaredError(yTest, yPred);
    disp(['Mean Squared Error: ', num2str(mse)]);

    % Print the true coefficients and the estimated coefficients
    disp(['True Coefficients: [1.0 ', num2str((2:N_FEATURES)), ']']);
    disp(['Estimated Coefficients: ', num2str(coefficients')]);
end

% Call the main function
main();
