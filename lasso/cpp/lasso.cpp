#include <iostream>
#include <vector>
#include <random>
#include <algorithm>
#include <cmath>

// Define the number of samples and features
constexpr int N_SAMPLES = 100;
constexpr int N_FEATURES = 20;

// Function to calculate the mean squared error
double calculate_mean_squared_error(const std::vector<double>& y_true, const std::vector<double>& y_pred) {
    double mse = 0.0;
    int n = y_true.size();
    for (int i = 0; i < n; i++) {
        double diff = y_true[i] - y_pred[i];
        mse += diff * diff;
    }
    return mse / n;
}

// Function to perform LASSO regression
void lasso_regression(std::vector<std::vector<double>>& X, std::vector<double>& y, std::vector<double>& coefficients, double alpha) {
    // Maximum number of iterations for coordinate descent
    int max_iterations = 100;
    
    // Step size for coordinate descent
    double step_size = 0.01;
    
    int n_samples = X.size();
    int n_features = X[0].size();
    
    // Initialize the coefficients to zero
    std::fill(coefficients.begin(), coefficients.end(), 0.0);
    
    // Perform coordinate descent
    for (int iteration = 0; iteration < max_iterations; iteration++) {
        for (int j = 0; j < n_features; j++) {
            // Calculate the gradient for feature j
            double gradient = 0.0;
            for (int i = 0; i < n_samples; i++) {
                double pred = 0.0;
                for (int k = 0; k < n_features; k++) {
                    if (k != j) {
                        pred += X[i][k] * coefficients[k];
                    }
                }
                gradient += (y[i] - pred) * X[i][j];
            }
            
            // Update the coefficient using LASSO penalty
            if (gradient > alpha) {
                coefficients[j] = (gradient - alpha) * step_size;
            } else if (gradient < -alpha) {
                coefficients[j] = (gradient + alpha) * step_size;
            } else {
                coefficients[j] = 0.0;
            }
        }
    }
}

int main() {
    // Generate some synthetic data
    std::mt19937 rng(42);
    std::uniform_real_distribution<double> dist(0.0, 1.0);
    
    std::vector<std::vector<double>> X(N_SAMPLES, std::vector<double>(N_FEATURES, 0.0));
    std::vector<double> y(N_SAMPLES, 0.0);
    std::vector<double> true_coefficients(N_FEATURES, 0.0);
    true_coefficients[0] = 1.0;
    true_coefficients[1] = 1.0;
    true_coefficients[2] = 1.0;
    true_coefficients[3] = 1.0;
    true_coefficients[4] = 1.0;
    
    for (int i = 0; i < N_SAMPLES; i++) {
        for (int j = 0; j < N_FEATURES; j++) {
            X[i][j] = dist(rng);
        }
        
        y[i] = 0.0;
        for (int j = 0; j < N_FEATURES; j++) {
            y[i] += X[i][j] * true_coefficients[j];
        }
        y[i] += 0.1 * dist(rng);
    }
    
    // Split the data into training and test sets
    int n_train_samples = N_SAMPLES * 0.8;
    int n_test_samples = N_SAMPLES - n_train_samples;
    std::vector<std::vector<double>> X_train(n_train_samples, std::vector<double>(N_FEATURES, 0.0));
    std::vector<double> y_train(n_train_samples, 0.0);
    std::vector<std::vector<double>> X_test(n_test_samples, std::vector<double>(N_FEATURES, 0.0));
    std::vector<double> y_test(n_test_samples, 0.0);
    
    for (int i = 0; i < n_train_samples; i++) {
        for (int j = 0; j < N_FEATURES; j++) {
            X_train[i][j] = X[i][j];
        }
        y_train[i] = y[i];
    }
    
    for (int i = 0; i < n_test_samples; i++) {
        for (int j = 0; j < N_FEATURES; j++) {
            X_test[i][j] = X[n_train_samples + i][j];
        }
        y_test[i] = y[n_train_samples + i];
    }
    
    // Perform LASSO regression
    double alpha = 0.1;
    std::vector<double> coefficients(N_FEATURES, 0.0);
    lasso_regression(X_train, y_train, coefficients, alpha);
    
    // Make predictions on the test set
    std::vector<double> y_pred(n_test_samples, 0.0);
    for (int i = 0; i < n_test_samples; i++) {
        for (int j = 0; j < N_FEATURES; j++) {
            y_pred[i] += X_test[i][j] * coefficients[j];
        }
    }
    
    // Calculate the mean squared error
    double mse = calculate_mean_squared_error(y_test, y_pred);
    std::cout << "Mean Squared Error: " << mse << std::endl;
    
    // Print the true coefficients and the estimated coefficients
    std::cout << "True Coefficients: ";
    for (int i = 0; i < N_FEATURES; i++) {
        std::cout << true_coefficients[i] << " ";
    }
    std::cout << std::endl;
    
    std::cout << "Estimated Coefficients: ";
    for (int i = 0; i < N_FEATURES; i++) {
        std::cout << coefficients[i] << " ";
    }
    std::cout << std::endl;
    
    return 0;
}
