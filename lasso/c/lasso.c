#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// Define the number of samples and features
#define N_SAMPLES 100
#define N_FEATURES 20

// Function to calculate the mean squared error
double calculate_mean_squared_error(double *y_true, double *y_pred, int n) {
    double mse = 0.0;
    for (int i = 0; i < n; i++) {
        double diff = y_true[i] - y_pred[i];
        mse += diff * diff;
    }
    return mse / n;
}

// Function to perform LASSO regression
void lasso_regression(double X[][N_FEATURES], double *y, double *coefficients, double alpha, int n_samples, int n_features) {
    // Maximum number of iterations for coordinate descent
    int max_iterations = 100;
    
    // Step size for coordinate descent
    double step_size = 0.01;
    
    // Initialize the coefficients to zero
    for (int i = 0; i < n_features; i++) {
        coefficients[i] = 0.0;
    }
    
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
    srand(42);
    double X[N_SAMPLES][N_FEATURES];
    double y[N_SAMPLES];
    double true_coefficients[N_FEATURES] = {0.0};
    true_coefficients[0] = 1.0;
    true_coefficients[1] = 1.0;
    true_coefficients[2] = 1.0;
    true_coefficients[3] = 1.0;
    true_coefficients[4] = 1.0;
    
    for (int i = 0; i < N_SAMPLES; i++) {
        for (int j = 0; j < N_FEATURES; j++) {
            X[i][j] = (double)rand() / RAND_MAX;
        }
        
        y[i] = 0.0;
        for (int j = 0; j < N_FEATURES; j++) {
            y[i] += X[i][j] * true_coefficients[j];
        }
        y[i] += 0.1 * ((double)rand() / RAND_MAX);
    }
    
    // Split the data into training and test sets
    int n_train_samples = N_SAMPLES * 0.8;
    int n_test_samples = N_SAMPLES - n_train_samples;
    double X_train[n_train_samples][N_FEATURES];
    double y_train[n_train_samples];
    double X_test[n_test_samples][N_FEATURES];
    double y_test[n_test_samples];
    
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
    double coefficients[N_FEATURES];
    lasso_regression(X_train, y_train, coefficients, alpha, n_train_samples, N_FEATURES);
    
    // Make predictions on the test set
    double y_pred[n_test_samples];
    for (int i = 0; i < n_test_samples; i++) {
        y_pred[i] = 0.0;
        for (int j = 0; j < N_FEATURES; j++) {
            y_pred[i] += X_test[i][j] * coefficients[j];
        }
    }
    
    // Calculate the mean squared error
    double mse = calculate_mean_squared_error(y_test, y_pred, n_test_samples);
    printf("Mean Squared Error: %.4f\n", mse);
    
    // Print the true coefficients and the estimated coefficients
    printf("True Coefficients: ");
    for (int i = 0; i < N_FEATURES; i++) {
        printf("%.4f ", true_coefficients[i]);
    }
    printf("\nEstimated Coefficients: ");
    for (int i = 0; i < N_FEATURES; i++) {
        printf("%.4f ", coefficients[i]);
    }
    printf("\n");
    
    return 0;
}
